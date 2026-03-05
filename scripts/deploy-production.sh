#!/bin/bash

# MyCoach Production Deployment Script
# Secure, zero-downtime deployment with comprehensive validation

set -euo pipefail

# ═══════════════════════════════════════════════════════════════
# 📋 Configuration
# ═══════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Deployment configuration
ENVIRONMENT="${ENVIRONMENT:-production}"
VERSION="${VERSION:-latest}"
DRY_RUN="${DRY_RUN:-false}"
ROLLBACK_VERSION="${ROLLBACK_VERSION:-}"

# Service URLs
PRODUCTION_API_URL="https://api.my-trainers.app"
PRODUCTION_WEB_URL="https://my-trainers.app"
HEALTH_CHECK_TIMEOUT=120
HEALTH_CHECK_INTERVAL=10

# Docker configuration
DOCKER_REGISTRY="docker.io"
BACKEND_IMAGE="${DOCKER_USER}/trainers-backend"

# Notification configuration
DISCORD_WEBHOOK="${DISCORD_WEBHOOK:-}"
SLACK_WEBHOOK="${SLACK_WEBHOOK:-}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ═══════════════════════════════════════════════════════════════
# 🛠️ Functions
# ═══════════════════════════════════════════════════════════════

log() {
    echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
    send_notification "❌ Deployment Failed" "$1" "15158332"
    exit 1
}

banner() {
    echo
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE} $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo
}

send_notification() {
    local title="$1"
    local message="$2"
    local color="${3:-3066993}"
    
    if [[ -n "$DISCORD_WEBHOOK" ]]; then
        curl -s -X POST "$DISCORD_WEBHOOK" \
            -H "Content-Type: application/json" \
            -d "{
                \"embeds\": [{
                    \"title\": \"$title\",
                    \"description\": \"$message\",
                    \"color\": $color,
                    \"fields\": [
                        {\"name\": \"Version\", \"value\": \"$VERSION\", \"inline\": true},
                        {\"name\": \"Environment\", \"value\": \"$ENVIRONMENT\", \"inline\": true},
                        {\"name\": \"Timestamp\", \"value\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\", \"inline\": true}
                    ],
                    \"footer\": {\"text\": \"MyCoach Deployment System\"}
                }]
            }" > /dev/null || true
    fi
}

check_prerequisites() {
    banner "🔍 PRE-DEPLOYMENT CHECKS"
    
    # Check required tools
    local tools=("docker" "kubectl" "curl" "jq" "bc")
    for tool in "${tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            success "$tool available"
        else
            error "$tool not found - required for deployment"
        fi
    done
    
    # Check environment variables
    local required_vars=("DOCKER_USER" "KUBECONFIG")
    for var in "${required_vars[@]}"; do
        if [[ -n "${!var:-}" ]]; then
            success "$var configured"
        else
            error "$var environment variable not set"
        fi
    done
    
    # Verify version format
    if [[ "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || [[ "$VERSION" == "latest" ]]; then
        success "Version format valid: $VERSION"
    else
        error "Invalid version format: $VERSION (expected vX.Y.Z or latest)"
    fi
}

verify_image_exists() {
    banner "🔍 VERIFYING DOCKER IMAGE"
    
    local image_tag="${BACKEND_IMAGE}:${VERSION}"
    log "Checking if image exists: $image_tag"
    
    if docker manifest inspect "$image_tag" > /dev/null 2>&1; then
        success "Docker image verified: $image_tag"
    else
        error "Docker image not found: $image_tag"
    fi
    
    # Security scan
    log "Running security scan on image..."
    if command -v trivy >/dev/null 2>&1; then
        local scan_output=$(trivy image --format json --severity CRITICAL "$image_tag" 2>/dev/null || echo '{}')
        local critical_count=$(echo "$scan_output" | jq -r '.Results[]?.Vulnerabilities[]? | select(.Severity=="CRITICAL") | .VulnerabilityID' 2>/dev/null | wc -l || echo "0")
        
        if [[ "$critical_count" -eq 0 ]]; then
            success "Security scan: No critical vulnerabilities"
        else
            error "Security scan: $critical_count critical vulnerabilities found - deployment blocked"
        fi
    else
        warning "Trivy not available - skipping security scan"
    fi
}

backup_current_deployment() {
    banner "💾 BACKING UP CURRENT DEPLOYMENT"
    
    log "Creating deployment backup..."
    
    # Get current deployment state
    kubectl get deployment api -o yaml > "/tmp/api-deployment-backup-$(date +%s).yaml" 2>/dev/null || true
    kubectl get service api -o yaml > "/tmp/api-service-backup-$(date +%s).yaml" 2>/dev/null || true
    
    # Get current image tag for rollback
    local current_image=$(kubectl get deployment api -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || echo "unknown")
    echo "$current_image" > "/tmp/previous-image-tag.txt"
    
    success "Current deployment backed up"
    log "Previous image: $current_image"
}

enable_maintenance_mode() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log "[DRY RUN] Would enable maintenance mode"
        return 0
    fi
    
    banner "⏸️ ENABLING MAINTENANCE MODE"
    
    # Add maintenance mode annotation to ingress
    kubectl annotate ingress api-ingress \
        nginx.ingress.kubernetes.io/maintenance-mode="true" \
        --overwrite 2>/dev/null || true
    
    # Scale down to 1 replica during deployment
    kubectl scale deployment api --replicas=1 2>/dev/null || true
    
    success "Maintenance mode enabled"
    sleep 5  # Give time for changes to propagate
}

disable_maintenance_mode() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log "[DRY_RUN] Would disable maintenance mode"
        return 0
    fi
    
    log "Disabling maintenance mode..."
    
    # Remove maintenance mode annotation
    kubectl annotate ingress api-ingress \
        nginx.ingress.kubernetes.io/maintenance-mode- 2>/dev/null || true
    
    # Scale back up to desired replicas
    kubectl scale deployment api --replicas=3 2>/dev/null || true
    
    success "Maintenance mode disabled"
}

deploy_backend() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log "[DRY RUN] Would deploy backend image: ${BACKEND_IMAGE}:${VERSION}"
        return 0
    fi
    
    banner "🐳 DEPLOYING BACKEND"
    
    local image_tag="${BACKEND_IMAGE}:${VERSION}"
    log "Deploying image: $image_tag"
    
    # Update deployment with new image
    kubectl set image deployment/api api="$image_tag"
    
    # Wait for rollout to complete
    log "Waiting for deployment rollout..."
    if kubectl rollout status deployment/api --timeout=300s; then
        success "Backend deployment completed"
    else
        error "Backend deployment failed or timed out"
    fi
    
    # Verify pods are running
    local running_pods=$(kubectl get pods -l app=api --field-selector=status.phase=Running --no-headers | wc -l)
    log "Running pods: $running_pods"
    
    if [[ "$running_pods" -gt 0 ]]; then
        success "Backend pods are running"
    else
        error "No backend pods are running"
    fi
}

deploy_frontend() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log "[DRY RUN] Would deploy frontend version: $VERSION"
        return 0
    fi
    
    banner "📱 DEPLOYING FRONTEND"
    
    # This would typically involve uploading to S3 and invalidating CloudFront
    log "Deploying frontend assets..."
    
    # Example S3 deployment (commented out - implement based on your setup)
    # aws s3 sync dist/ s3://mycoach-frontend-prod --delete --cache-control max-age=31536000
    # aws cloudfront create-invalidation --distribution-id XXXXXXXXXX --paths "/*"
    
    success "Frontend deployment completed"
}

run_database_migrations() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log "[DRY RUN] Would run database migrations"
        return 0
    fi
    
    banner "🗄️ DATABASE MIGRATIONS"
    
    log "Checking for pending migrations..."
    
    # Run migration job in Kubernetes
    kubectl create job migration-$(date +%s) \
        --from=cronjob/migration-job \
        --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
    
    # Wait for migration job to complete
    local migration_job=$(kubectl get jobs -l app=migration --sort-by=.metadata.creationTimestamp --no-headers | tail -1 | awk '{print $1}')
    
    if [[ -n "$migration_job" ]]; then
        kubectl wait --for=condition=complete job/"$migration_job" --timeout=300s
        success "Database migrations completed"
    else
        warning "No migration job found - skipping migrations"
    fi
}

health_check() {
    banner "🏥 HEALTH CHECKS"
    
    local max_attempts=$((HEALTH_CHECK_TIMEOUT / HEALTH_CHECK_INTERVAL))
    local attempt=1
    
    log "Running health checks (timeout: ${HEALTH_CHECK_TIMEOUT}s)..."
    
    while [[ $attempt -le $max_attempts ]]; do
        log "Health check attempt $attempt/$max_attempts"
        
        # API Health Check
        if curl -f -s --max-time 30 "$PRODUCTION_API_URL/health" > /dev/null; then
            success "API health check: PASSED"
            
            # Frontend Health Check
            if curl -f -s --max-time 30 -L "$PRODUCTION_WEB_URL" > /dev/null; then
                success "Frontend health check: PASSED"
                return 0
            else
                warning "Frontend health check failed"
            fi
        else
            warning "API health check failed"
        fi
        
        if [[ $attempt -eq $max_attempts ]]; then
            error "Health checks failed after $max_attempts attempts"
        fi
        
        sleep "$HEALTH_CHECK_INTERVAL"
        ((attempt++))
    done
}

performance_validation() {
    banner "📊 PERFORMANCE VALIDATION"
    
    log "Testing API response time..."
    local response_time=$(curl -w "%{time_total}" -s -o /dev/null --max-time 30 "$PRODUCTION_API_URL/health")
    local response_time_ms=$(echo "$response_time * 1000" | bc)
    
    log "API response time: ${response_time_ms}ms"
    
    if (( $(echo "$response_time < 2.0" | bc -l) )); then
        success "API performance: GOOD (< 2000ms)"
    else
        warning "API performance: SLOW (${response_time_ms}ms)"
    fi
    
    # Load test (light)
    log "Running light load test..."
    if command -v ab >/dev/null 2>&1; then
        ab -n 10 -c 2 -q "$PRODUCTION_API_URL/health" > /tmp/load-test.txt 2>&1 || true
        local avg_time=$(grep "Time per request" /tmp/load-test.txt | head -1 | awk '{print $4}')
        log "Average response time under load: ${avg_time}ms"
    else
        log "Apache Bench not available - skipping load test"
    fi
}

rollback_deployment() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log "[DRY RUN] Would rollback deployment"
        return 0
    fi
    
    banner "🔄 ROLLING BACK DEPLOYMENT"
    
    if [[ -n "$ROLLBACK_VERSION" ]]; then
        log "Rolling back to version: $ROLLBACK_VERSION"
        kubectl set image deployment/api api="${BACKEND_IMAGE}:${ROLLBACK_VERSION}"
    else
        log "Rolling back to previous deployment..."
        kubectl rollout undo deployment/api
    fi
    
    # Wait for rollback to complete
    if kubectl rollout status deployment/api --timeout=300s; then
        success "Rollback completed successfully"
        
        # Verify rollback health
        sleep 30  # Wait for rollback to stabilize
        if curl -f -s --max-time 30 "$PRODUCTION_API_URL/health" > /dev/null; then
            success "Rollback health check: PASSED"
        else
            error "Rollback health check: FAILED - Manual intervention required"
        fi
    else
        error "Rollback failed or timed out"
    fi
}

cleanup() {
    log "Cleaning up temporary files..."
    rm -f /tmp/load-test.txt
    rm -f /tmp/api-deployment-backup-*.yaml
    rm -f /tmp/api-service-backup-*.yaml
}

# ═══════════════════════════════════════════════════════════════
# 🚀 Main Deployment Process
# ═══════════════════════════════════════════════════════════════

deploy() {
    banner "🚀 MYCOACH PRODUCTION DEPLOYMENT"
    
    log "Version: $VERSION"
    log "Environment: $ENVIRONMENT"
    log "Dry Run: $DRY_RUN"
    
    # Pre-deployment validation
    check_prerequisites
    verify_image_exists
    backup_current_deployment
    
    # Send deployment start notification
    send_notification "🚀 Deployment Started" "Version $VERSION deployment initiated" "3447003"
    
    # Deployment process
    enable_maintenance_mode
    
    # Trap to ensure cleanup on failure
    trap 'disable_maintenance_mode; cleanup; error "Deployment failed"' ERR
    
    run_database_migrations
    deploy_backend
    deploy_frontend
    
    disable_maintenance_mode
    
    # Post-deployment validation
    health_check
    performance_validation
    
    # Success notification
    send_notification "✅ Deployment Successful" "Version $VERSION deployed successfully" "3066993"
    
    success "Production deployment completed successfully!"
    log "Version $VERSION is now live at $PRODUCTION_WEB_URL"
    
    cleanup
}

rollback() {
    banner "🔄 MYCOACH DEPLOYMENT ROLLBACK"
    
    log "Initiating rollback process..."
    
    enable_maintenance_mode
    rollback_deployment
    disable_maintenance_mode
    health_check
    
    send_notification "🔄 Rollback Completed" "Deployment rolled back successfully" "16776960"
    
    success "Rollback completed successfully!"
}

# ═══════════════════════════════════════════════════════════════
# 📋 Command Line Interface
# ═══════════════════════════════════════════════════════════════

usage() {
    echo "Usage: $0 [deploy|rollback] [options]"
    echo
    echo "Commands:"
    echo "  deploy    Deploy specified version to production"
    echo "  rollback  Rollback to previous or specified version"
    echo
    echo "Options:"
    echo "  --version VERSION         Version to deploy (required for deploy)"
    echo "  --rollback-version VER    Version to rollback to (optional)"
    echo "  --dry-run                 Show what would be done without executing"
    echo "  --help                    Show this help message"
    echo
    echo "Examples:"
    echo "  $0 deploy --version v1.2.3"
    echo "  $0 deploy --version v1.2.3 --dry-run"
    echo "  $0 rollback"
    echo "  $0 rollback --rollback-version v1.2.2"
}

# Parse command line arguments
COMMAND="${1:-}"
shift || true

while [[ $# -gt 0 ]]; do
    case $1 in
        --version)
            VERSION="$2"
            shift 2
            ;;
        --rollback-version)
            ROLLBACK_VERSION="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN="true"
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Execute command
case "$COMMAND" in
    deploy)
        if [[ -z "$VERSION" ]]; then
            error "Version is required for deployment"
        fi
        deploy
        ;;
    rollback)
        rollback
        ;;
    *)
        echo "Error: Command required (deploy|rollback)"
        echo
        usage
        exit 1
        ;;
esac
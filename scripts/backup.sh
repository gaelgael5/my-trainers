#!/bin/bash

# MyCoach PostgreSQL Backup Script
# Automated database backup with retention policy and monitoring

set -euo pipefail

# ═══════════════════════════════════════════════════════════════
# 📋 Configuration
# ═══════════════════════════════════════════════════════════════

# Database configuration
DB_HOST="${PGHOST:-database}"
DB_PORT="${PGPORT:-5432}"
DB_NAME="${PGDATABASE:-mycoach_db}"
DB_USER="${PGUSER:-mycoach_user}"
DB_PASSWORD="${PGPASSWORD:-}"

# Backup configuration
BACKUP_DIR="${BACKUP_DIR:-/backup}"
BACKUP_PREFIX="${BACKUP_PREFIX:-mycoach}"
RETENTION_DAYS="${RETENTION_DAYS:-30}"
COMPRESSION_LEVEL="${COMPRESSION_LEVEL:-6}"

# S3 configuration (optional)
S3_BUCKET="${S3_BUCKET:-}"
AWS_REGION="${AWS_REGION:-eu-west-1}"

# Notification configuration
DISCORD_WEBHOOK="${DISCORD_WEBHOOK:-}"
SLACK_WEBHOOK="${SLACK_WEBHOOK:-}"

# ═══════════════════════════════════════════════════════════════
# 🛠️ Functions
# ═══════════════════════════════════════════════════════════════

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$BACKUP_DIR/backup.log"
}

error() {
    log "ERROR: $1"
    send_notification "❌ Backup Failed" "$1" "15158332"
    exit 1
}

success() {
    log "SUCCESS: $1"
    send_notification "✅ Backup Completed" "$1" "3066993"
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
                        {\"name\": \"Database\", \"value\": \"$DB_NAME\", \"inline\": true},
                        {\"name\": \"Host\", \"value\": \"$DB_HOST\", \"inline\": true},
                        {\"name\": \"Timestamp\", \"value\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\", \"inline\": true}
                    ],
                    \"footer\": {\"text\": \"MyCoach Backup System\"}
                }]
            }" > /dev/null || true
    fi
}

check_dependencies() {
    log "Checking dependencies..."
    
    command -v pg_dump >/dev/null 2>&1 || error "pg_dump not found. Install PostgreSQL client."
    command -v gzip >/dev/null 2>&1 || error "gzip not found."
    
    if [[ -n "$S3_BUCKET" ]]; then
        command -v aws >/dev/null 2>&1 || error "AWS CLI not found but S3 upload requested."
    fi
    
    log "All dependencies available"
}

test_database_connection() {
    log "Testing database connection..."
    
    export PGPASSWORD="$DB_PASSWORD"
    
    if ! pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -t 30; then
        error "Database connection failed: $DB_HOST:$DB_PORT/$DB_NAME"
    fi
    
    log "Database connection successful"
}

create_backup() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="${BACKUP_DIR}/${BACKUP_PREFIX}_${timestamp}.sql"
    local compressed_file="${backup_file}.gz"
    
    log "Creating backup: $backup_file"
    
    # Create backup directory if it doesn't exist
    mkdir -p "$BACKUP_DIR"
    
    # Export password for pg_dump
    export PGPASSWORD="$DB_PASSWORD"
    
    # Create the backup
    if ! pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" \
        --no-owner --no-privileges --verbose --clean --if-exists \
        --format=plain > "$backup_file" 2>> "$BACKUP_DIR/backup.log"; then
        rm -f "$backup_file"
        error "pg_dump failed"
    fi
    
    # Check if backup file was created and has content
    if [[ ! -s "$backup_file" ]]; then
        rm -f "$backup_file"
        error "Backup file is empty or not created"
    fi
    
    local backup_size=$(du -h "$backup_file" | cut -f1)
    log "Backup created successfully: $backup_size"
    
    # Compress the backup
    log "Compressing backup..."
    if ! gzip -"$COMPRESSION_LEVEL" "$backup_file"; then
        error "Compression failed"
    fi
    
    local compressed_size=$(du -h "$compressed_file" | cut -f1)
    log "Backup compressed: $compressed_size"
    
    # Verify compressed file integrity
    if ! gzip -t "$compressed_file"; then
        rm -f "$compressed_file"
        error "Compressed backup file is corrupted"
    fi
    
    echo "$compressed_file"
}

upload_to_s3() {
    local backup_file="$1"
    
    if [[ -z "$S3_BUCKET" ]]; then
        log "S3 upload skipped (no bucket configured)"
        return 0
    fi
    
    log "Uploading to S3: s3://$S3_BUCKET/"
    
    local s3_path="s3://$S3_BUCKET/backups/$(date +%Y)/$(date +%m)/$(basename "$backup_file")"
    
    if aws s3 cp "$backup_file" "$s3_path" --region "$AWS_REGION" --storage-class STANDARD_IA; then
        log "Successfully uploaded to S3: $s3_path"
        
        # Verify upload
        if aws s3 ls "$s3_path" > /dev/null; then
            log "S3 upload verified"
        else
            error "S3 upload verification failed"
        fi
    else
        error "S3 upload failed"
    fi
}

cleanup_old_backups() {
    log "Cleaning up backups older than $RETENTION_DAYS days..."
    
    # Local cleanup
    local deleted_count=0
    while IFS= read -r -d '' backup; do
        rm -f "$backup"
        ((deleted_count++))
    done < <(find "$BACKUP_DIR" -name "${BACKUP_PREFIX}_*.sql.gz" -mtime +$RETENTION_DAYS -print0)
    
    if [[ $deleted_count -gt 0 ]]; then
        log "Deleted $deleted_count old local backups"
    else
        log "No old local backups to delete"
    fi
    
    # S3 cleanup (if configured)
    if [[ -n "$S3_BUCKET" ]]; then
        log "Cleaning up S3 backups..."
        local cutoff_date=$(date -d "$RETENTION_DAYS days ago" +%Y-%m-%d)
        
        aws s3api list-objects-v2 \
            --bucket "$S3_BUCKET" \
            --prefix "backups/" \
            --query "Contents[?LastModified<='$cutoff_date'].Key" \
            --output text 2>/dev/null | \
        while read -r key; do
            if [[ -n "$key" && "$key" != "None" ]]; then
                aws s3 rm "s3://$S3_BUCKET/$key"
                log "Deleted S3 backup: $key"
            fi
        done
    fi
}

generate_backup_report() {
    local backup_file="$1"
    local backup_size=$(du -h "$backup_file" | cut -f1)
    local backup_count=$(find "$BACKUP_DIR" -name "${BACKUP_PREFIX}_*.sql.gz" | wc -l)
    
    cat << EOF > "$BACKUP_DIR/backup_report.json"
{
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "database": "$DB_NAME",
    "host": "$DB_HOST",
    "backup_file": "$(basename "$backup_file")",
    "backup_size": "$backup_size",
    "compression": "gzip level $COMPRESSION_LEVEL",
    "local_backup_count": $backup_count,
    "retention_days": $RETENTION_DAYS,
    "s3_enabled": $([ -n "$S3_BUCKET" ] && echo "true" || echo "false"),
    "status": "success"
}
EOF

    log "Backup report generated: backup_report.json"
}

# ═══════════════════════════════════════════════════════════════
# 🚀 Main Execution
# ═══════════════════════════════════════════════════════════════

main() {
    log "Starting MyCoach database backup..."
    
    # Pre-flight checks
    check_dependencies
    test_database_connection
    
    # Create backup
    local backup_file
    backup_file=$(create_backup)
    
    # Upload to S3 (if configured)
    upload_to_s3 "$backup_file"
    
    # Cleanup old backups
    cleanup_old_backups
    
    # Generate report
    generate_backup_report "$backup_file"
    
    # Success notification
    local backup_size=$(du -h "$backup_file" | cut -f1)
    success "Database backup completed successfully ($backup_size)"
    
    log "Backup process completed"
}

# Handle script termination
trap 'error "Backup process interrupted"' INT TERM

# Execute main function
main "$@"
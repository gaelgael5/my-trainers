#!/bin/bash

# Health Check complet de l'infrastructure
echo "🏥 Health Check MyTrainer Infrastructure"
echo "==============================================="

# Fonction de test d'un service
check_service() {
    local service_name=$1
    local url=$2
    local expected_code=${3:-200}
    
    if curl -f -s -o /dev/null -w "%{http_code}" $url | grep -q $expected_code; then
        echo "✅ $service_name: OK"
        return 0
    else
        echo "❌ $service_name: FAIL"
        return 1
    fi
}

# Vérification des containers
echo "📦 Containers Status:"
docker-compose -f infrastructure/docker/docker-compose.yml ps

echo ""
echo "🌐 Services Health:"

# Tests des services
check_service "Backend API" "http://localhost:8000/health"
check_service "Database" "http://localhost:5432" "000"  # Connection test
check_service "Redis" "http://localhost:6379" "000"     # Connection test  
check_service "Prometheus" "http://localhost:9090"
check_service "Grafana" "http://localhost:3000"

echo ""
echo "💾 Storage Status:"
df -h | grep -E "(database|backup)"

echo ""
echo "📊 Memory Usage:"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"

echo ""
echo "🕐 Derniers logs (erreurs):"
docker-compose -f infrastructure/docker/docker-compose.yml logs --tail=10 | grep -i error || echo "Aucune erreur récente"

echo ""
echo "==============================================="
echo "Health Check terminé - $(date)"

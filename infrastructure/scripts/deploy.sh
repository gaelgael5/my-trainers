#!/bin/bash

# Script de déploiement MyTrainer
# Usage: ./deploy.sh [dev|prod]

ENV=${1:-dev}
echo "🚀 Déploiement MyTrainer - Environnement: $ENV"

# Vérifications pré-déploiement
if ! command -v docker &> /dev/null; then
    echo "❌ Docker non installé"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose non installé"  
    exit 1
fi

# Variables d'environnement
case $ENV in
    "dev")
        export DOMAIN="dev.mytrainer.local"
        export DB_PASSWORD="dev_password"
        ;;
    "prod") 
        export DOMAIN="mytrainer.app"
        export DB_PASSWORD="${DB_PASSWORD:-$(openssl rand -base64 32)}"
        ;;
    *)
        echo "❌ Environnement invalide: $ENV (dev|prod)"
        exit 1
        ;;
esac

echo "📋 Configuration:"
echo "  - Environnement: $ENV"
echo "  - Domaine: $DOMAIN"
echo "  - DB Password: [MASKED]"

# Backup avant déploiement (en prod)
if [ "$ENV" = "prod" ]; then
    echo "💾 Backup avant déploiement..."
    ./backup/backup-db.sh
fi

# Arrêt des services existants
echo "🔄 Arrêt des services existants..."
cd infrastructure/docker
docker-compose down

# Build et démarrage
echo "🏗️ Build et démarrage des services..."
docker-compose up -d --build

# Vérifications post-déploiement
echo "🔍 Vérification des services..."
sleep 10

if curl -f http://localhost:8000/health > /dev/null 2>&1; then
    echo "✅ Backend opérationnel"
else
    echo "❌ Backend non accessible"
    exit 1
fi

if curl -f http://localhost:3000 > /dev/null 2>&1; then
    echo "✅ Grafana opérationnel"
else
    echo "⚠️ Grafana non accessible"
fi

echo "✅ Déploiement terminé avec succès!"
echo "🌐 Services disponibles:"
echo "  - API: http://localhost:8000"
echo "  - Docs: http://localhost:8000/docs"
echo "  - Monitoring: http://localhost:3000"

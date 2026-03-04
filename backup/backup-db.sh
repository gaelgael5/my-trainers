#!/bin/bash

# Script de backup automatique PostgreSQL
# Usage: ./backup-db.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup"
CONTAINER_NAME="mytrainer_db"

echo "🗄️ Démarrage backup database - $DATE"

# Créer le répertoire si nécessaire
mkdir -p $BACKUP_DIR

# Backup complet
docker exec $CONTAINER_NAME pg_dump -U postgres mytrainer > $BACKUP_DIR/mytrainer_backup_$DATE.sql

# Compression
gzip $BACKUP_DIR/mytrainer_backup_$DATE.sql

# Cleanup des anciens backups (garder 7 jours)
find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete

echo "✅ Backup terminé: mytrainer_backup_$DATE.sql.gz"

# Optionnel: upload vers S3/cloud storage
# aws s3 cp $BACKUP_DIR/mytrainer_backup_$DATE.sql.gz s3://my-bucket/backups/

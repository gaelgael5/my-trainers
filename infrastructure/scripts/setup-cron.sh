#!/bin/bash

# Configuration des tâches automatiques
echo "⏰ Configuration des tâches cron..."

# Backup quotidien à 2h du matin
(crontab -l 2>/dev/null; echo "0 2 * * * /root/.openclaw/workspace-shared/backup/backup-db.sh") | crontab -

# Health check toutes les heures
(crontab -l 2>/dev/null; echo "0 * * * * /root/.openclaw/workspace-shared/infrastructure/scripts/health-check.sh >> /var/log/mytrainer-health.log") | crontab -

# Cleanup des logs toutes les semaines
(crontab -l 2>/dev/null; echo "0 0 * * 0 find /var/log -name '*mytrainer*' -mtime +30 -delete") | crontab -

echo "✅ Tâches cron configurées:"
crontab -l | grep mytrainer

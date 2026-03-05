#!/bin/bash

# Test de scan de sécurité Trivy (comme dans les workflows)
# Author: Agent sysadmin
# Date: 2026-03-05

echo "🔒 TEST SCAN SÉCURITÉ TRIVY"
echo "==========================="

# Configuration couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Vérifier que Trivy est installé
if ! command -v trivy >/dev/null 2>&1; then
    echo "${YELLOW}⚠️  Trivy non installé. Installation...${NC}"
    
    # Installation rapide de Trivy
    if command -v apt-get >/dev/null 2>&1; then
        echo "📦 Installation via apt..."
        sudo apt-get update && sudo apt-get install -y wget apt-transport-https gnupg lsb-release
        wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
        echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
        sudo apt-get update && sudo apt-get install -y trivy
    else
        echo "${RED}❌ Impossible d'installer Trivy automatiquement${NC}"
        echo "Installation manuelle requise: https://aquasecurity.github.io/trivy/"
        exit 1
    fi
fi

echo "${BLUE}🔍 Scan filesystem vulnerabilities (CRITICAL + HIGH)${NC}"
echo "------------------------------------------------------"

# Scan du filesystem comme dans le workflow GitHub
trivy fs . \
    --severity CRITICAL,HIGH \
    --format table \
    --exit-code 1 \
    --quiet

TRIVY_EXIT_CODE=$?

if [[ $TRIVY_EXIT_CODE -eq 0 ]]; then
    echo "${GREEN}✅ TRIVY SCAN PASSED - Aucune vulnérabilité critique détectée${NC}"
    echo
    echo "🎯 Le workflow GitHub Actions devrait passer le security-scan"
else
    echo "${RED}❌ TRIVY SCAN FAILED - Vulnérabilités critiques détectées${NC}"
    echo
    echo "${YELLOW}🚨 ATTENTION: Les workflows GitHub seront BLOQUÉS${NC}"
    echo "📋 Actions requises:"
    echo "   1. Corriger les vulnérabilités listées ci-dessus"
    echo "   2. OU ajuster le niveau de sévérité dans les workflows"
    echo "   3. OU ajouter des exceptions pour vulnérabilités acceptées"
    echo
    echo "🔧 Pour ajuster le workflow (si vulnérabilités acceptables):"
    echo "   Modifier severity: 'CRITICAL,HIGH' → 'CRITICAL' dans:"
    echo "   - .github/workflows/ci-cd-complete.yml"
fi

echo
echo "${BLUE}📊 Scan détaillé (tous niveaux)${NC}"
echo "--------------------------------"

# Scan plus détaillé pour information
trivy fs . \
    --format table \
    --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL \
    --quiet

echo
echo "${BLUE}🔗 Informations contextuelles${NC}"
echo "------------------------------"
echo "📁 Repository: $(pwd)"
echo "🌿 Branche: $(git branch --show-current)"
echo "📝 Dernier commit: $(git log -1 --oneline)"
echo "🔒 Trivy version: $(trivy version | grep Version || echo "N/A")"

echo
echo "${GREEN}✨ Test de sécurité terminé${NC}"

exit $TRIVY_EXIT_CODE
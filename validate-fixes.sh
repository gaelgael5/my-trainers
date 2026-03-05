#!/bin/bash

# Script de validation des corrections GitHub Actions
# Author: Agent sysadmin
# Date: 2026-03-05

echo "🔍 VALIDATION DES CORRECTIONS GITHUB ACTIONS"
echo "=============================================="

# Configuration couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Compteurs
ERRORS=0
WARNINGS=0
FIXES_APPLIED=0

echo
echo "${BLUE}📋 PHASE 1: Vérification corrections Firebase Action${NC}"
echo "--------------------------------------------------------"

# Vérification mise à jour version action Firebase
echo "🔍 Vérification version Firebase Action..."

CI_CD_VERSION=$(grep "Firebase-Distribution-Github-Action" .github/workflows/ci-cd-complete.yml | grep -o "@v[0-9.]*")
FLUTTER_CI_VERSIONS=$(grep "Firebase-Distribution-Github-Action" .github/workflows/flutter-ci.yml | grep -o "@v[0-9.]*")

if [[ "$CI_CD_VERSION" == "@v1.7.0" ]]; then
    echo "${GREEN}✅ ci-cd-complete.yml: Firebase Action mise à jour vers v1.7.0${NC}"
    ((FIXES_APPLIED++))
else
    echo "${RED}❌ ci-cd-complete.yml: Firebase Action toujours en $CI_CD_VERSION${NC}"
    ((ERRORS++))
fi

# Vérification flutter-ci.yml (2 occurrences attendues)
V1_7_COUNT=$(echo "$FLUTTER_CI_VERSIONS" | grep "@v1.7.0" | wc -l)
if [[ $V1_7_COUNT -eq 2 ]]; then
    echo "${GREEN}✅ flutter-ci.yml: 2 Firebase Actions mises à jour vers v1.7.0${NC}"
    ((FIXES_APPLIED++))
else
    echo "${RED}❌ flutter-ci.yml: Firebase Actions non mises à jour (trouvé $V1_7_COUNT/2)${NC}"
    echo "   Versions trouvées: $FLUTTER_CI_VERSIONS"
    ((ERRORS++))
fi

echo
echo "${BLUE}📋 PHASE 2: Vérification secrets Firebase${NC}"
echo "----------------------------------------------"

# Vérification cohérence secrets
SECRET_CI_CD=$(grep "FIREBASE_SERVICE_ACCOUNT" .github/workflows/ci-cd-complete.yml | head -1)
SECRET_FLUTTER=$(grep "FIREBASE_SERVICE_ACCOUNT" .github/workflows/flutter-ci.yml | head -1)

echo "🔍 Secrets utilisés:"
echo "   ci-cd-complete.yml: $(echo "$SECRET_CI_CD" | grep -o "FIREBASE_SERVICE_ACCOUNT[_A-Z]*")"
echo "   flutter-ci.yml: $(echo "$SECRET_FLUTTER" | grep -o "FIREBASE_SERVICE_ACCOUNT[_A-Z]*")"

if echo "$SECRET_CI_CD" | grep -q "FIREBASE_SERVICE_ACCOUNT_KEY"; then
    echo "${GREEN}✅ Secret corrigé vers FIREBASE_SERVICE_ACCOUNT_KEY${NC}"
    ((FIXES_APPLIED++))
elif echo "$SECRET_CI_CD" | grep -q "FIREBASE_SERVICE_ACCOUNT\b"; then
    echo "${YELLOW}⚠️  Secret toujours FIREBASE_SERVICE_ACCOUNT (peut nécessiter correction)${NC}"
    ((WARNINGS++))
fi

echo
echo "${BLUE}📋 PHASE 3: Vérification structure workflows${NC}"
echo "----------------------------------------------"

# Vérification que les fichiers de backup existent
if [[ -f ".github/workflows/ci-cd-complete.yml.backup" ]]; then
    echo "${GREEN}✅ Backup ci-cd-complete.yml créé${NC}"
else
    echo "${YELLOW}⚠️  Backup ci-cd-complete.yml manquant${NC}"
    ((WARNINGS++))
fi

if [[ -f ".github/workflows/flutter-ci.yml.backup" ]]; then
    echo "${GREEN}✅ Backup flutter-ci.yml créé${NC}"
else
    echo "${YELLOW}⚠️  Backup flutter-ci.yml manquant${NC}"
    ((WARNINGS++))
fi

# Vérification que les workflows sont valides (syntaxe basique)
echo "🔍 Validation syntaxe YAML..."
if command -v yamllint >/dev/null 2>&1; then
    for workflow in .github/workflows/*.yml; do
        if ! yamllint "$workflow" >/dev/null 2>&1; then
            echo "${RED}❌ Syntaxe invalide: $workflow${NC}"
            ((ERRORS++))
        fi
    done
    echo "${GREEN}✅ Syntaxe YAML valide${NC}"
else
    echo "${YELLOW}⚠️  yamllint non installé - validation syntaxe ignorée${NC}"
fi

echo
echo "${BLUE}📋 PHASE 4: Vérification configurations Firebase${NC}"
echo "---------------------------------------------------"

# Vérification google-services.json
if [[ -f "flutter/android/app/google-services.json" ]]; then
    PROJECT_ID=$(cat flutter/android/app/google-services.json | grep -o '"project_id":"[^"]*"' | cut -d'"' -f4)
    APP_ID=$(cat flutter/android/app/google-services.json | grep -o '"mobilesdk_app_id":"[^"]*"' | cut -d'"' -f4)
    echo "${GREEN}✅ google-services.json présent${NC}"
    echo "   Project ID: $PROJECT_ID"
    echo "   App ID: $APP_ID"
else
    echo "${RED}❌ google-services.json manquant${NC}"
    ((ERRORS++))
fi

# Vérification cohérence App ID dans workflows
WORKFLOW_APP_ID=$(grep '"1:' .github/workflows/flutter-ci.yml | grep -o '"[^"]*"' | head -1 | tr -d '"')
echo "🔍 App ID dans workflows: $WORKFLOW_APP_ID"

echo
echo "${BLUE}📋 PHASE 5: Recommandations post-correction${NC}"
echo "-----------------------------------------------"

echo "🎯 Prochaines étapes recommandées:"
echo "   1. Commit et push des corrections"
echo "   2. Vérifier secrets GitHub Actions (FIREBASE_SERVICE_ACCOUNT vs FIREBASE_SERVICE_ACCOUNT_KEY)"
echo "   3. Surveiller prochains builds sur: https://github.com/gaelgael5/my-trainers/actions"
echo "   4. Si échec persiste → appliquer Phase 2 (régénération service account)"

if [[ $WARNINGS -gt 0 ]]; then
    echo
    echo "${YELLOW}⚠️  Vérifications recommandées:${NC}"
    echo "   • Vérifier nom exact du secret GitHub"
    echo "   • Tester upload Firebase CLI en local"
    echo "   • Valider permissions service account"
fi

echo
echo "═══════════════════════════════════════════════════════"
echo "${BLUE}📊 RÉSUMÉ VALIDATION${NC}"
echo "═══════════════════════════════════════════════════════"
echo "${GREEN}✅ Corrections appliquées: $FIXES_APPLIED${NC}"
echo "${YELLOW}⚠️  Avertissements: $WARNINGS${NC}"
echo "${RED}❌ Erreurs: $ERRORS${NC}"

if [[ $ERRORS -eq 0 ]]; then
    echo
    echo "${GREEN}🎉 VALIDATION RÉUSSIE - Prêt pour commit${NC}"
    exit 0
else
    echo
    echo "${RED}🚨 ERREURS DÉTECTÉES - Correction requise${NC}"
    exit 1
fi
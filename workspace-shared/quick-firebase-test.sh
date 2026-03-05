#!/bin/bash
# 🚀 Script de Test Rapide Firebase Configuration
# Usage: ./quick-firebase-test.sh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

success() { echo -e "${GREEN}✅ $1${NC}"; }
warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; }
info() { echo -e "${BLUE}ℹ️  $1${NC}"; }

echo -e "${BLUE}🔥 Test Rapide Configuration Firebase${NC}"
echo "======================================="

cd flutter 2>/dev/null || { error "Dossier flutter/ non trouvé !"; exit 1; }

echo ""
info "1. Vérification Package Names"

# Extract package name from pubspec.yaml
pubspec_name=$(grep "^name:" pubspec.yaml | cut -d' ' -f2)
echo "   pubspec.yaml: $pubspec_name"

# Extract applicationId from build.gradle
app_id=$(grep "applicationId" android/app/build.gradle | sed 's/.*applicationId "\(.*\)".*/\1/')
echo "   applicationId: $app_id"

# Extract namespace from build.gradle  
namespace=$(grep "namespace" android/app/build.gradle | sed 's/.*namespace "\(.*\)".*/\1/')
echo "   namespace: $namespace"

# Check consistency
if [[ "$app_id" == "$namespace" ]]; then
    success "Package names cohérents !"
else
    error "Package names incohérents !"
fi

echo ""
info "2. Vérification google-services.json"

if [[ -f "android/app/google-services.json" ]]; then
    success "google-services.json présent"
    
    # Check package name in google-services.json
    if command -v jq &> /dev/null; then
        gs_package=$(jq -r '.client[0].client_info.android_client_info.package_name' android/app/google-services.json 2>/dev/null || echo "N/A")
        echo "   Package dans google-services.json: $gs_package"
        
        if [[ "$gs_package" == "$app_id" ]]; then
            success "Package name cohérent avec google-services.json !"
        else
            error "Package name différent dans google-services.json !"
        fi
    else
        warning "jq non installé - impossible de vérifier le package name"
    fi
else
    error "google-services.json MANQUANT dans android/app/"
    echo ""
    echo "   📥 Pour le récupérer :"
    echo "   1. Aller sur https://console.firebase.google.com/"
    echo "   2. Sélectionner le projet"  
    echo "   3. Paramètres → Vos applications → Android app"
    echo "   4. Télécharger google-services.json"
    echo "   5. Placer dans flutter/android/app/"
fi

echo ""
info "3. Test Build Flutter (si Flutter installé)"

if command -v flutter &> /dev/null; then
    success "Flutter trouvé !"
    
    info "Nettoyage projet..."
    flutter clean > /dev/null 2>&1
    
    info "Installation dépendances..."
    flutter pub get > /dev/null 2>&1
    
    info "Test build APK debug..."
    if flutter build apk --debug > /dev/null 2>&1; then
        success "Build APK debug réussi !"
        apk_path="build/app/outputs/flutter-apk/app-debug.apk"
        if [[ -f "$apk_path" ]]; then
            apk_size=$(du -h "$apk_path" | cut -f1)
            echo "   Taille APK: $apk_size"
        fi
    else
        error "Build APK debug échoué !"
    fi
else
    warning "Flutter non installé/trouvé"
    echo "   Pour installer: sudo snap install flutter --classic"
fi

echo ""
echo -e "${BLUE}📊 Résumé${NC}"
echo "=========="

if [[ -f "android/app/google-services.json" ]] && [[ "$app_id" == "$namespace" ]]; then
    success "Configuration semble correcte ! 🎉"
else
    warning "Configuration incomplète - voir messages ci-dessus"
fi

echo ""
echo -e "${BLUE}📖 Documentation complète: workspace-shared/test-firebase-config.md${NC}"
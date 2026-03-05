#!/bin/bash
# 🔍 Script de Validation Configuration Firebase + GitHub Actions
# Utilisation: ./validate-firebase-setup.sh

set -e

echo "🔥 Validation Configuration Firebase App Distribution"
echo "=================================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
success() { echo -e "${GREEN}✅ $1${NC}"; }
warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; }
info() { echo -e "ℹ️  $1"; }

echo ""
echo "1. 📱 Vérification Configuration Flutter"
echo "----------------------------------------"

# Check Flutter installation
if command -v flutter &> /dev/null; then
    success "Flutter est installé"
    flutter --version | head -1
else
    error "Flutter n'est pas installé ou pas dans PATH"
    exit 1
fi

# Check Flutter doctor
echo ""
info "Exécution de flutter doctor..."
if flutter doctor --machine &> /dev/null; then
    success "Flutter doctor OK"
else
    warning "Flutter doctor signale des problèmes - vérifiez avec 'flutter doctor'"
fi

echo ""
echo "2. 📁 Vérification Structure Projet"
echo "-----------------------------------"

# Check if we're in a Flutter project
if [ -f "pubspec.yaml" ]; then
    success "Fichier pubspec.yaml trouvé"
else
    error "pubspec.yaml non trouvé - êtes-vous dans un projet Flutter ?"
    exit 1
fi

# Check Android configuration
if [ -d "android" ]; then
    success "Dossier android/ existe"
else
    error "Dossier android/ non trouvé"
    exit 1
fi

# Check google-services.json
if [ -f "android/app/google-services.json" ]; then
    success "google-services.json présent"
    
    # Extract and show project info
    if command -v jq &> /dev/null; then
        project_id=$(jq -r '.project_info.project_id' android/app/google-services.json 2>/dev/null || echo "N/A")
        package_name=$(jq -r '.client[0].client_info.android_client_info.package_name' android/app/google-services.json 2>/dev/null || echo "N/A")
        info "Project ID: $project_id"
        info "Package Name: $package_name"
    fi
else
    warning "google-services.json non trouvé dans android/app/"
    info "Téléchargez-le depuis Firebase Console > Paramètres projet > Vos applications"
fi

echo ""
echo "3. 🏗️  Test Build APK"
echo "---------------------"

info "Nettoyage du projet..."
flutter clean > /dev/null 2>&1

info "Installation des dépendances..."
flutter pub get > /dev/null 2>&1

info "Construction APK Release..."
if flutter build apk --release > /dev/null 2>&1; then
    success "Build APK réussi"
    
    apk_path="build/app/outputs/flutter-apk/app-release.apk"
    if [ -f "$apk_path" ]; then
        success "APK trouvé: $apk_path"
        apk_size=$(du -h "$apk_path" | cut -f1)
        info "Taille APK: $apk_size"
    else
        error "APK non trouvé au chemin attendu: $apk_path"
    fi
else
    error "Échec du build APK"
    exit 1
fi

echo ""
echo "4. ⚙️  Vérification Configuration GitHub Actions"
echo "------------------------------------------------"

# Check if .github/workflows directory exists
if [ -d ".github/workflows" ]; then
    success "Dossier .github/workflows/ existe"
    
    # Count workflow files
    workflow_count=$(find .github/workflows -name "*.yml" -o -name "*.yaml" | wc -l)
    info "Workflows trouvés: $workflow_count"
    
    # Check for Firebase-related workflows
    if find .github/workflows -name "*.yml" -o -name "*.yaml" | xargs grep -l "firebase" > /dev/null 2>&1; then
        success "Workflow Firebase détecté"
    else
        warning "Aucun workflow Firebase trouvé"
        info "Créez un workflow avec Firebase App Distribution action"
    fi
else
    warning "Dossier .github/workflows/ non trouvé"
    info "Créez le dossier et ajoutez un workflow de déploiement"
fi

echo ""
echo "5. 🔑 Vérification Secrets GitHub (Manuel)"
echo "-------------------------------------------"

info "Vérifiez manuellement dans GitHub Repository Settings:"
echo "   ➤ Settings > Secrets and variables > Actions"
echo ""
echo "   Secrets requis:"
echo "   • FIREBASE_SERVICE_ACCOUNT_KEY (JSON complet du service account)"
echo "   • FIREBASE_APP_ID (Format: 1:123456789:android:abcdef123456)"  
echo "   • FIREBASE_PROJECT_ID (nom-du-projet-firebase)"
echo ""

echo ""
echo "6. 🧪 Tests Firebase CLI (Optionnel)"
echo "------------------------------------"

if command -v firebase &> /dev/null; then
    success "Firebase CLI installé"
    firebase --version | head -1
    
    info "Pour tester manuellement:"
    echo "   firebase login"
    echo "   firebase appdistribution:distribute $apk_path --app YOUR_APP_ID --groups 'testeurs'"
else
    warning "Firebase CLI non installé"
    info "Pour installer: npm install -g firebase-tools"
fi

echo ""
echo "7. 📋 Récapitulatif"
echo "------------------"

echo "✅ Actions à vérifier manuellement:"
echo "   □ Secrets GitHub configurés"
echo "   □ Service Account créé avec bons rôles (Firebase App Distribution Admin)"
echo "   □ App Android ajoutée dans Firebase Console"
echo "   □ Firebase App Distribution activé"
echo "   □ Testeurs/groupes configurés (optionnel)"
echo ""

echo "🚀 Test Final:"
echo "   1. Pusher du code sur la branche principale"
echo "   2. Vérifier dans GitHub Actions que le workflow se lance"
echo "   3. Vérifier dans Firebase App Distribution qu'une nouvelle version apparaît"
echo ""

echo "🔗 URLs utiles:"
echo "   • Firebase Console: https://console.firebase.google.com/"
echo "   • GitHub Actions: https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\([^.]*\).*/\1/')/actions"
echo ""

echo "🎉 Configuration validée ! Votre pipeline de déploiement devrait être opérationnel."
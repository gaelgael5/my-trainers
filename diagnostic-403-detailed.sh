#!/bin/bash
# 🔍 Diagnostic approfondi erreur 403 Firebase - Identification cause exacte

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

echo "🔍 DIAGNOSTIC APPROFONDI ERREUR 403 FIREBASE"
echo "============================================"

# Vérification prérequis
if ! command -v jq &> /dev/null; then
    error "jq requis pour ce diagnostic"
    echo "Installation : sudo apt-get install jq"
    exit 1
fi

if ! command -v gcloud &> /dev/null; then
    warning "gcloud CLI non trouvé - certains tests seront limités"
    echo "Installation : https://cloud.google.com/sdk/docs/install"
fi

# Variables globales pour le rapport
ISSUES_FOUND=()
SOLUTIONS=()

add_issue() {
    ISSUES_FOUND+=("$1")
}

add_solution() {
    SOLUTIONS+=("$1")
}

echo ""
echo "📋 PHASE 1: ANALYSE CONFIGURATION LOCALE"
echo "========================================="

# 1. Vérifier google-services.json
info "1.1 Vérification google-services.json..."
if [[ -f "flutter/android/app/google-services.json" ]]; then
    success "google-services.json présent"
    
    PROJECT_ID=$(jq -r '.project_info.project_id' flutter/android/app/google-services.json 2>/dev/null)
    PACKAGE_NAME=$(jq -r '.client[0].client_info.android_client_info.package_name' flutter/android/app/google-services.json 2>/dev/null)
    
    echo "   Project ID: $PROJECT_ID"
    echo "   Package Name: $PACKAGE_NAME"
else
    error "google-services.json MANQUANT"
    add_issue "google-services.json manquant dans flutter/android/app/"
    add_solution "Télécharger google-services.json depuis Firebase Console"
fi

# 2. Vérifier cohérence package names
info "1.2 Vérification cohérence package names..."
if [[ -f "flutter/android/app/build.gradle" ]]; then
    APP_ID=$(grep "applicationId" flutter/android/app/build.gradle | sed 's/.*applicationId "\(.*\)".*/\1/')
    echo "   applicationId build.gradle: $APP_ID"
    
    if [[ "$PACKAGE_NAME" != "$APP_ID" ]]; then
        error "Package name incohérent !"
        add_issue "Package name différent entre google-services.json ($PACKAGE_NAME) et build.gradle ($APP_ID)"
        add_solution "Synchroniser les package names ou regénérer google-services.json"
    else
        success "Package names cohérents"
    fi
fi

# 3. Vérifier workflow GitHub
info "1.3 Analyse workflow GitHub Actions..."
if [[ -f ".github/workflows/flutter-ci.yml" ]]; then
    success "Workflow trouvé"
    
    # Vérifier le nom du secret utilisé
    SECRET_NAME=$(grep "serviceCredentialsFileContent" .github/workflows/flutter-ci.yml | sed 's/.*secrets\.\([^}]*\).*/\1/' | head -1)
    echo "   Secret utilisé: $SECRET_NAME"
    
    if [[ "$SECRET_NAME" != "FIREBASE_SERVICE_ACCOUNT_KEY" ]]; then
        warning "Secret name non standard : $SECRET_NAME"
        add_issue "Nom du secret '$SECRET_NAME' peut ne pas correspondre aux guides"
        add_solution "Vérifier que le secret GitHub existe avec ce nom exact"
    fi
    
    # Vérifier version de l'action
    ACTION_VERSION=$(grep "wzieba/Firebase-Distribution-Github-Action" .github/workflows/flutter-ci.yml | sed 's/.*@\(.*\)/\1/')
    echo "   Version action: $ACTION_VERSION"
    
    if [[ "$ACTION_VERSION" == "v1" ]]; then
        warning "Action version v1 obsolète"
        add_issue "Version v1 de l'action Firebase peut être obsolète"
        add_solution "Mettre à jour vers wzieba/Firebase-Distribution-Github-Action@v1.7.0"
    fi
else
    error "Workflow GitHub Actions non trouvé"
fi

echo ""
echo "🔑 PHASE 2: TEST PERMISSIONS FIREBASE (si gcloud disponible)"
echo "============================================================"

if command -v gcloud &> /dev/null; then
    # Vérifier la connection gcloud
    info "2.1 Vérification connection gcloud..."
    
    if gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q "@"; then
        CURRENT_ACCOUNT=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
        success "Connecté avec: $CURRENT_ACCOUNT"
        
        CURRENT_PROJECT=$(gcloud config get-value project 2>/dev/null || echo "non-défini")
        echo "   Projet actuel: $CURRENT_PROJECT"
        
        if [[ "$CURRENT_PROJECT" != "$PROJECT_ID" ]]; then
            warning "Projet gcloud différent du projet Firebase"
            echo "   Exécuter: gcloud config set project $PROJECT_ID"
        fi
    else
        warning "Non connecté à gcloud"
        echo "   Exécuter: gcloud auth login"
    fi
    
    # Test API Firebase App Distribution
    info "2.2 Test API Firebase App Distribution..."
    
    if gcloud auth application-default print-access-token &>/dev/null; then
        TOKEN=$(gcloud auth application-default print-access-token 2>/dev/null)
        
        # Test API call
        API_RESPONSE=$(curl -s -w "\n%{http_code}" -X GET \
            "https://firebaseappdistribution.googleapis.com/v1/projects/$PROJECT_ID/apps" \
            -H "Authorization: Bearer $TOKEN" 2>/dev/null)
        
        HTTP_CODE=$(echo "$API_RESPONSE" | tail -n1)
        API_BODY=$(echo "$API_RESPONSE" | sed '$d')
        
        echo "   Status API: $HTTP_CODE"
        
        case $HTTP_CODE in
            200)
                success "API Firebase accessible"
                APP_COUNT=$(echo "$API_BODY" | jq '.apps | length' 2>/dev/null || echo "0")
                echo "   Apps trouvées: $APP_COUNT"
                ;;
            403)
                error "Erreur 403 - Permissions insuffisantes"
                add_issue "L'utilisateur actuel n'a pas les permissions Firebase requises"
                add_solution "Ajouter les rôles Firebase à votre compte utilisateur pour tester"
                ;;
            401)
                error "Erreur 401 - Non authentifié"
                add_issue "Problème d'authentification gcloud"
                add_solution "Reconnecter avec gcloud auth login"
                ;;
            *)
                warning "Réponse API inattendue: $HTTP_CODE"
                ;;
        esac
    else
        warning "Impossible d'obtenir un token d'accès"
        add_solution "Exécuter: gcloud auth application-default login"
    fi
else
    warning "gcloud CLI non disponible - tests d'API limités"
fi

echo ""
echo "🎯 PHASE 3: TESTS AVEC CLÉS SERVICE ACCOUNT"
echo "==========================================="

info "3.1 Recherche des clés service account locales..."

# Chercher des fichiers de clés dans le workspace
KEY_FILES=($(find . -name "*service*account*" -o -name "*firebase*key*" -name "*.json" 2>/dev/null | head -5))

if [[ ${#KEY_FILES[@]} -eq 0 ]]; then
    warning "Aucune clé service account trouvée localement"
    echo ""
    info "Pour tester avec une clé service account :"
    echo "   1. Télécharger la clé depuis Google Cloud Console"
    echo "   2. Placer dans ce workspace"
    echo "   3. Relancer ce script"
else
    success "Clés potentielles trouvées: ${#KEY_FILES[@]}"
    
    for key_file in "${KEY_FILES[@]}"; do
        echo ""
        info "Test avec $key_file..."
        
        if jq -e '.private_key and .client_email' "$key_file" &>/dev/null; then
            CLIENT_EMAIL=$(jq -r '.client_email' "$key_file")
            KEY_PROJECT=$(jq -r '.project_id' "$key_file")
            
            echo "   Service account: $CLIENT_EMAIL"
            echo "   Projet: $KEY_PROJECT"
            
            if [[ "$KEY_PROJECT" != "$PROJECT_ID" ]]; then
                error "Projet de la clé ($KEY_PROJECT) différent du projet Firebase ($PROJECT_ID)"
                add_issue "Clé service account pour mauvais projet"
                add_solution "Utiliser une clé du projet $PROJECT_ID"
                continue
            fi
            
            # Test avec cette clé (nécessite gcloud)
            if command -v gcloud &> /dev/null; then
                export GOOGLE_APPLICATION_CREDENTIALS="$key_file"
                
                if TOKEN=$(gcloud auth application-default print-access-token 2>/dev/null); then
                    API_RESPONSE=$(curl -s -w "\n%{http_code}" -X GET \
                        "https://firebaseappdistribution.googleapis.com/v1/projects/$PROJECT_ID/apps" \
                        -H "Authorization: Bearer $TOKEN" 2>/dev/null)
                    
                    HTTP_CODE=$(echo "$API_RESPONSE" | tail -n1)
                    
                    case $HTTP_CODE in
                        200)
                            success "Service account fonctionne ! ✨"
                            echo "   Cette clé peut être utilisée dans GitHub Actions"
                            ;;
                        403)
                            error "Service account sans permissions"
                            add_issue "Service account $CLIENT_EMAIL manque de permissions"
                            add_solution "Ajouter rôles Firebase à ce service account"
                            ;;
                        *)
                            warning "Test avec service account - code $HTTP_CODE"
                            ;;
                    esac
                else
                    warning "Impossible de tester avec cette clé"
                fi
                
                unset GOOGLE_APPLICATION_CREDENTIALS
            fi
        else
            warning "$key_file ne semble pas être une clé service account valide"
        fi
    done
fi

echo ""
echo "📊 PHASE 4: RAPPORT DE DIAGNOSTIC"
echo "================================="

echo ""
if [[ ${#ISSUES_FOUND[@]} -eq 0 ]]; then
    success "Aucun problème majeur détecté !"
    echo ""
    echo "🤔 Si l'erreur 403 persiste, causes possibles :"
    echo "   • Délai de propagation des permissions (attendre 30 min)"
    echo "   • Service account différent utilisé dans GitHub Actions"
    echo "   • Problème avec l'action GitHub elle-même"
else
    error "Problèmes détectés:"
    echo ""
    for i in "${!ISSUES_FOUND[@]}"; do
        echo "   $((i+1)). ${ISSUES_FOUND[i]}"
    done
fi

echo ""
if [[ ${#SOLUTIONS[@]} -gt 0 ]]; then
    info "Solutions recommandées:"
    echo ""
    for i in "${!SOLUTIONS[@]}"; do
        echo "   $((i+1)). ${SOLUTIONS[i]}"
    done
fi

echo ""
echo "🎯 ÉTAPES SUIVANTES PRIORITAIRES:"
echo "================================="
echo "1. ✅ Corriger les problèmes détectés ci-dessus"
echo "2. 🔄 Si pas de problèmes → Exécuter fix-403-immediate.sh"
echo "3. ⏰ Attendre 10-15 minutes après chaque changement"
echo "4. 🧪 Tester avec une action GitHub simple"
echo "5. 📞 Si toujours 403 → Utiliser les alternatives (Firebase CLI direct)"

echo ""
echo "🔗 FICHIERS DE DEBUG CRÉÉS:"
echo "   • Logs détaillés dans ce terminal"
echo "   • Utiliser fix-403-immediate.sh pour corrections rapides"
echo "   • Consulter alternatives-403.sh si problème persiste"

echo ""
echo "✨ DIAGNOSTIC TERMINÉ"
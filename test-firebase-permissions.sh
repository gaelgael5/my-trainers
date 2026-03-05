#!/bin/bash
# 🧪 Test des permissions Firebase CLI - Validation service account

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

success() { echo -e "${GREEN}✅ $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; }
warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
info() { echo -e "${BLUE}ℹ️  $1${NC}"; }

echo "🧪 TEST PERMISSIONS FIREBASE CLI"
echo "================================"

echo ""
info "Ce script va tester les permissions Firebase avec votre service account"
echo ""

# Vérifier les prérequis
echo "🔍 Vérification des prérequis..."

if ! command -v firebase &> /dev/null; then
    error "Firebase CLI non installé"
    echo ""
    echo "📥 Installation Firebase CLI :"
    echo "   npm install -g firebase-tools"
    echo "   # ou"
    echo "   curl -sL https://firebase.tools | bash"
    exit 1
else
    success "Firebase CLI installé"
    firebase --version
fi

if ! command -v jq &> /dev/null; then
    error "jq requis pour ce script"
    echo "Installation : sudo apt-get install jq"
    exit 1
fi

# Chercher un fichier de clé service account
echo ""
info "🔑 Recherche d'une clé service account..."

KEY_FILE=""

# Chercher dans les emplacements communs
POSSIBLE_KEYS=(
    "./firebase-service-account.json"
    "./service-account.json"
    "./firebase-key.json"
    "$(find . -name "*service*account*.json" 2>/dev/null | head -1)"
    "$(find . -name "*firebase*key*.json" 2>/dev/null | head -1)"
)

for key in "${POSSIBLE_KEYS[@]}"; do
    if [[ -n "$key" && -f "$key" ]]; then
        if jq -e '.private_key and .client_email and .project_id' "$key" &>/dev/null; then
            KEY_FILE="$key"
            success "Clé service account trouvée : $KEY_FILE"
            break
        fi
    fi
done

if [[ -z "$KEY_FILE" ]]; then
    error "Aucune clé service account trouvée"
    echo ""
    echo "📥 Pour obtenir une clé service account :"
    echo "1. Google Cloud Console → IAM & Admin → Service Accounts"
    echo "2. Sélectionner votre service account Firebase"
    echo "3. Actions → Manage keys → Add key → Create new key → JSON"
    echo "4. Télécharger et placer dans ce dossier"
    echo "5. Relancer ce script"
    echo ""
    read -p "Avez-vous une clé service account à spécifier ? (chemin/vers/cle.json ou 'non'): " USER_KEY
    
    if [[ "$USER_KEY" != "non" && -f "$USER_KEY" ]]; then
        KEY_FILE="$USER_KEY"
        info "Utilisation de la clé : $KEY_FILE"
    else
        echo "❌ Test annulé - clé service account requise"
        exit 1
    fi
fi

# Extraire les informations de la clé
PROJECT_ID=$(jq -r '.project_id' "$KEY_FILE")
CLIENT_EMAIL=$(jq -r '.client_email' "$KEY_FILE")
PRIVATE_KEY_ID=$(jq -r '.private_key_id' "$KEY_FILE")

echo ""
echo "📋 Informations service account :"
echo "   Project ID    : $PROJECT_ID"
echo "   Client Email  : $CLIENT_EMAIL"
echo "   Private Key ID: $PRIVATE_KEY_ID"

# Authentification Firebase CLI
echo ""
info "🔐 Authentification Firebase CLI..."

export GOOGLE_APPLICATION_CREDENTIALS="$KEY_FILE"

# Test 1: Firebase login status
echo ""
echo "TEST 1: Statut authentification Firebase"
echo "----------------------------------------"

if firebase projects:list --json &>/dev/null; then
    success "Authentification Firebase réussie"
    
    # Lister les projets accessibles
    PROJECTS=$(firebase projects:list --json 2>/dev/null)
    PROJECT_COUNT=$(echo "$PROJECTS" | jq '. | length')
    
    echo "   Projets accessibles: $PROJECT_COUNT"
    
    # Vérifier si notre projet est dans la liste
    if echo "$PROJECTS" | jq -r '.[].id' | grep -q "^$PROJECT_ID$"; then
        success "Projet $PROJECT_ID accessible"
    else
        error "Projet $PROJECT_ID non accessible via Firebase CLI"
        echo ""
        echo "   Projets disponibles:"
        echo "$PROJECTS" | jq -r '.[] | "   - \(.id) (\(.displayName))"'
        echo ""
        warning "Le service account n'a peut-être pas accès au bon projet"
    fi
else
    error "Échec authentification Firebase CLI"
    echo ""
    echo "💡 Essayez :"
    echo "   firebase login"
    echo "   firebase use $PROJECT_ID"
    exit 1
fi

# Test 2: Firebase App List
echo ""
echo "TEST 2: Listage des applications Firebase"
echo "-----------------------------------------"

if firebase apps:list --project="$PROJECT_ID" --json &>/dev/null; then
    success "Accès aux applications Firebase"
    
    APPS=$(firebase apps:list --project="$PROJECT_ID" --json 2>/dev/null)
    ANDROID_APPS=$(echo "$APPS" | jq '[.[] | select(.platform == "ANDROID")]')
    ANDROID_COUNT=$(echo "$ANDROID_APPS" | jq '. | length')
    
    echo "   Applications Android: $ANDROID_COUNT"
    
    if [[ "$ANDROID_COUNT" -gt 0 ]]; then
        echo ""
        echo "   Applications trouvées:"
        echo "$ANDROID_APPS" | jq -r '.[] | "   - \(.appId) (\(.packageName))"'
        
        # Extraire le premier App ID pour les tests
        FIREBASE_APP_ID=$(echo "$ANDROID_APPS" | jq -r '.[0].appId')
        echo ""
        info "App ID pour tests: $FIREBASE_APP_ID"
    else
        warning "Aucune application Android trouvée"
        echo "   Ajoutez une application Android dans Firebase Console"
    fi
else
    error "Impossible de lister les applications"
    echo ""
    echo "🔧 Causes possibles:"
    echo "   • Service account sans rôle 'Firebase Admin'"
    echo "   • Projet Firebase non configuré"
    echo "   • Problème de permissions IAM"
fi

# Test 3: Firebase App Distribution
echo ""
echo "TEST 3: Accès Firebase App Distribution"
echo "---------------------------------------"

if [[ -n "$FIREBASE_APP_ID" ]]; then
    # Chercher un APK de test
    TEST_APK=""
    
    if [[ -f "flutter/build/app/outputs/flutter-apk/app-release.apk" ]]; then
        TEST_APK="flutter/build/app/outputs/flutter-apk/app-release.apk"
    elif [[ -f "flutter/build/app/outputs/flutter-apk/app-debug.apk" ]]; then
        TEST_APK="flutter/build/app/outputs/flutter-apk/app-debug.apk"
    else
        warning "Aucun APK trouvé pour test"
        echo "   Construisez un APK avec : flutter build apk"
        
        # Créer un APK de test factice pour validation des permissions
        echo ""
        info "Création d'un APK de test factice..."
        mkdir -p /tmp/test-apk
        echo "Test APK" > /tmp/test-apk/test.txt
        
        if command -v zip &>/dev/null; then
            cd /tmp/test-apk
            zip -q ../test-app.apk test.txt
            TEST_APK="/tmp/test-app.apk"
            cd - >/dev/null
            info "APK de test créé: $TEST_APK"
        fi
    fi
    
    if [[ -n "$TEST_APK" && -f "$TEST_APK" ]]; then
        echo ""
        info "Test upload vers Firebase App Distribution..."
        echo "   APK: $TEST_APK"
        echo "   App ID: $FIREBASE_APP_ID"
        
        # Test upload (dry-run d'abord)
        if firebase appdistribution:distribute "$TEST_APK" \
           --app "$FIREBASE_APP_ID" \
           --release-notes "Test permissions depuis CLI" \
           --project "$PROJECT_ID" \
           2>/tmp/firebase-error.log; then
            
            success "🎉 Upload Firebase App Distribution RÉUSSI !"
            echo ""
            echo "✨ EXCELLENT ! Votre service account fonctionne parfaitement."
            echo ""
            echo "🔧 Votre problème vient probablement de :"
            echo "   1. Nom incorrect du secret GitHub"
            echo "   2. Service account différent dans GitHub Actions"
            echo "   3. Problème avec l'action wzieba elle-même"
            
        else
            error "Échec upload Firebase App Distribution"
            echo ""
            echo "📄 Détails de l'erreur :"
            if [[ -f "/tmp/firebase-error.log" ]]; then
                cat /tmp/firebase-error.log
            fi
            echo ""
            
            # Analyser l'erreur
            if grep -q "403" /tmp/firebase-error.log; then
                error "Erreur 403 - Permissions insuffisantes"
                echo ""
                echo "🔧 Rôles requis pour le service account :"
                echo "   • Firebase App Distribution Admin"
                echo "   • Firebase Quality Admin"
                echo "   • Firebase Admin (si les autres ne suffisent pas)"
                echo ""
                echo "📝 Commandes pour ajouter les rôles :"
                echo ""
                echo "gcloud projects add-iam-policy-binding $PROJECT_ID \\"
                echo "  --member=\"serviceAccount:$CLIENT_EMAIL\" \\"
                echo "  --role=\"roles/firebase.developmentAdmin\""
                echo ""
                echo "gcloud projects add-iam-policy-binding $PROJECT_ID \\"
                echo "  --member=\"serviceAccount:$CLIENT_EMAIL\" \\"
                echo "  --role=\"roles/firebase.qualityAdmin\""
            elif grep -q "404" /tmp/firebase-error.log; then
                error "App ID introuvable"
                echo "   Vérifiez que l'App ID est correct dans Firebase Console"
            else
                warning "Erreur inconnue - voir logs ci-dessus"
            fi
        fi
        
        # Nettoyage
        [[ "$TEST_APK" == "/tmp/test-app.apk" ]] && rm -f /tmp/test-app.apk /tmp/test-apk/test.txt 2>/dev/null
        
    else
        warning "Impossible de tester l'upload sans APK"
        echo "   Construisez un APK et relancez ce script"
    fi
else
    warning "Impossible de tester App Distribution sans App ID"
fi

# Test 4: Validation des rôles IAM
echo ""
echo "TEST 4: Vérification des rôles IAM"
echo "----------------------------------"

if command -v gcloud &>/dev/null; then
    info "Test avec gcloud CLI..."
    
    # Authentifier gcloud avec le service account
    if gcloud auth activate-service-account "$CLIENT_EMAIL" --key-file="$KEY_FILE" --project="$PROJECT_ID" &>/dev/null; then
        success "gcloud authentifié avec service account"
        
        # Lister les rôles du service account
        echo ""
        info "Rôles IAM du service account:"
        
        POLICY=$(gcloud projects get-iam-policy "$PROJECT_ID" --format=json 2>/dev/null || echo '{"bindings":[]}')
        
        USER_ROLES=$(echo "$POLICY" | jq -r ".bindings[] | select(.members[]? | contains(\"$CLIENT_EMAIL\")) | .role" 2>/dev/null || echo "")
        
        if [[ -n "$USER_ROLES" ]]; then
            echo "$USER_ROLES" | while read -r role; do
                if [[ -n "$role" ]]; then
                    echo "   ✅ $role"
                fi
            done
            
            # Vérifier les rôles critiques
            echo ""
            echo "🔍 Vérification rôles critiques:"
            
            CRITICAL_ROLES=(
                "roles/firebase.developmentAdmin"
                "roles/firebase.qualityAdmin"
                "roles/firebase.admin"
            )
            
            MISSING_ROLES=()
            
            for critical_role in "${CRITICAL_ROLES[@]}"; do
                if echo "$USER_ROLES" | grep -q "$critical_role"; then
                    success "$critical_role"
                else
                    error "$critical_role (MANQUANT)"
                    MISSING_ROLES+=("$critical_role")
                fi
            done
            
            if [[ ${#MISSING_ROLES[@]} -gt 0 ]]; then
                echo ""
                warning "Rôles manquants détectés !"
                echo ""
                echo "📝 Commandes pour ajouter les rôles manquants :"
                for missing_role in "${MISSING_ROLES[@]}"; do
                    echo ""
                    echo "gcloud projects add-iam-policy-binding $PROJECT_ID \\"
                    echo "  --member=\"serviceAccount:$CLIENT_EMAIL\" \\"
                    echo "  --role=\"$missing_role\""
                done
            else
                success "Tous les rôles critiques sont présents !"
            fi
        else
            error "Aucun rôle trouvé pour ce service account"
            echo ""
            echo "🔧 Le service account n'a peut-être aucune permission sur ce projet"
            echo "   Ajoutez au minimum le rôle 'Firebase Admin'"
        fi
    else
        error "Échec authentification gcloud"
        warning "Tests IAM limités"
    fi
else
    warning "gcloud CLI non disponible - tests IAM ignorés"
    echo "   Installez gcloud pour des tests plus approfondis"
fi

# Résumé final
echo ""
echo "📊 RÉSUMÉ DES TESTS"
echo "=================="

# Nettoyage
unset GOOGLE_APPLICATION_CREDENTIALS
rm -f /tmp/firebase-error.log 2>/dev/null

echo ""
echo "🎯 PROCHAINES ÉTAPES :"
echo ""
echo "1. 🔧 Si tests réussis → Problème dans GitHub Actions"
echo "   → Vérifier nom des secrets GitHub"
echo "   → Essayer les alternatives (alternatives-403.sh)"
echo ""
echo "2. ❌ Si tests échoués → Problème de permissions"
echo "   → Ajouter les rôles manquants montrés ci-dessus"
echo "   → Attendre 10 minutes et retester"
echo ""
echo "3. 🔄 Si toujours problèmes → Regénérer service account"
echo "   → Créer nouveau service account avec tous les rôles"
echo "   → Remplacer secret GitHub avec nouvelle clé"

echo ""
success "✨ Test terminé ! Consultez les résultats ci-dessus."
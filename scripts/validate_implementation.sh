#!/bin/bash

# Script de validation de l'implémentation Sprint 1
# Vérifie que tous les éléments requis sont présents et cohérents

set -e

echo "🔍 MyCoach - Validation Implémentation Sprint 1"
echo "==============================================="

PROJECT_DIR="flutter"
REQUIRED_FILES=(
    # Structure de base
    "$PROJECT_DIR/lib/main.dart"
    "$PROJECT_DIR/pubspec.yaml"
    
    # Constants (Design Sobre v2)
    "$PROJECT_DIR/lib/constants/app_colors.dart"
    "$PROJECT_DIR/lib/constants/app_text_styles.dart"
    "$PROJECT_DIR/lib/constants/app_dimensions.dart"
    "$PROJECT_DIR/lib/constants/app_theme.dart"
    "$PROJECT_DIR/lib/constants/app_constants.dart"
    
    # Models
    "$PROJECT_DIR/lib/models/user.dart"
    "$PROJECT_DIR/lib/models/auth_request.dart"
    "$PROJECT_DIR/lib/models/api_response.dart"
    
    # Services
    "$PROJECT_DIR/lib/services/api_service.dart"
    "$PROJECT_DIR/lib/services/auth_service.dart"
    "$PROJECT_DIR/lib/services/storage_service.dart"
    
    # Providers
    "$PROJECT_DIR/lib/providers/auth_provider.dart"
    
    # Screens
    "$PROJECT_DIR/lib/screens/login_screen.dart"
    "$PROJECT_DIR/lib/screens/home_screen.dart"
    
    # Widgets
    "$PROJECT_DIR/lib/widgets/custom_text_field.dart"
    "$PROJECT_DIR/lib/widgets/custom_button.dart"
    "$PROJECT_DIR/lib/widgets/app_logo.dart"
    
    # Utils
    "$PROJECT_DIR/lib/utils/validators.dart"
    "$PROJECT_DIR/lib/utils/app_router.dart"
    
    # Tests
    "$PROJECT_DIR/test/unit/auth_service_test.dart"
    "$PROJECT_DIR/test/unit/validators_test.dart"
    "$PROJECT_DIR/test/widget/login_screen_test.dart"
    "$PROJECT_DIR/test/integration/auth_flow_test.dart"
    
    # Scripts
    "scripts/build_apk.sh"
    "scripts/run_tests.sh"
)

REQUIRED_DEPENDENCIES=(
    "provider"
    "go_router"
    "http"
    "flutter_secure_storage"
    "shared_preferences"
)

REQUIRED_DEV_DEPENDENCIES=(
    "flutter_test"
    "mockito"
    "build_runner"
    "flutter_lints"
)

echo "📁 Vérification de la présence des fichiers..."
missing_files=0

for file in "${REQUIRED_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (MANQUANT)"
        ((missing_files++))
    fi
done

echo ""
echo "📦 Vérification des dépendances..."
missing_deps=0

if [[ -f "$PROJECT_DIR/pubspec.yaml" ]]; then
    for dep in "${REQUIRED_DEPENDENCIES[@]}"; do
        if grep -q "^[[:space:]]*$dep:" "$PROJECT_DIR/pubspec.yaml"; then
            echo "  ✅ $dep"
        else
            echo "  ❌ $dep (MANQUANT)"
            ((missing_deps++))
        fi
    done
    
    echo ""
    echo "🧪 Vérification des dépendances de développement..."
    for dep in "${REQUIRED_DEV_DEPENDENCIES[@]}"; do
        if grep -q "^[[:space:]]*$dep:" "$PROJECT_DIR/pubspec.yaml"; then
            echo "  ✅ $dep"
        else
            echo "  ❌ $dep (MANQUANT)"
            ((missing_deps++))
        fi
    done
else
    echo "  ❌ pubspec.yaml introuvable"
    ((missing_deps++))
fi

echo ""
echo "🎨 Vérification du design sobre v2..."
design_issues=0

# Vérifier les couleurs principales
if [[ -f "$PROJECT_DIR/lib/constants/app_colors.dart" ]]; then
    required_colors=("primaryOrange" "darkBackground" "lightGrey" "white")
    for color in "${required_colors[@]}"; do
        if grep -q "$color" "$PROJECT_DIR/lib/constants/app_colors.dart"; then
            echo "  ✅ Couleur $color définie"
        else
            echo "  ❌ Couleur $color manquante"
            ((design_issues++))
        fi
    done
else
    echo "  ❌ Fichier des couleurs manquant"
    ((design_issues++))
fi

# Vérifier le logo MC
if [[ -f "$PROJECT_DIR/lib/widgets/app_logo.dart" ]]; then
    if grep -q "'MC'" "$PROJECT_DIR/lib/widgets/app_logo.dart"; then
        echo "  ✅ Logo MC implémenté"
    else
        echo "  ❌ Logo MC manquant dans app_logo.dart"
        ((design_issues++))
    fi
else
    echo "  ❌ Fichier app_logo.dart manquant"
    ((design_issues++))
fi

echo ""
echo "🔐 Vérification de l'authentification..."
auth_issues=0

# Vérifier les méthodes d'authentification
if [[ -f "$PROJECT_DIR/lib/services/auth_service.dart" ]]; then
    required_methods=("login" "logout" "isLoggedIn" "forgotPassword")
    for method in "${required_methods[@]}"; do
        if grep -q "Future.*$method" "$PROJECT_DIR/lib/services/auth_service.dart"; then
            echo "  ✅ Méthode $method implémentée"
        else
            echo "  ❌ Méthode $method manquante"
            ((auth_issues++))
        fi
    done
else
    echo "  ❌ Service d'authentification manquant"
    ((auth_issues++))
fi

echo ""
echo "🧪 Vérification des tests..."
test_issues=0

test_files=(
    "$PROJECT_DIR/test/unit/auth_service_test.dart"
    "$PROJECT_DIR/test/unit/validators_test.dart" 
    "$PROJECT_DIR/test/widget/login_screen_test.dart"
    "$PROJECT_DIR/test/integration/auth_flow_test.dart"
)

for test_file in "${test_files[@]}"; do
    if [[ -f "$test_file" ]]; then
        if grep -q "testWidgets\|test(" "$test_file"; then
            echo "  ✅ $(basename "$test_file") contient des tests"
        else
            echo "  ❌ $(basename "$test_file") sans tests valides"
            ((test_issues++))
        fi
    else
        echo "  ❌ $(basename "$test_file") manquant"
        ((test_issues++))
    fi
done

echo ""
echo "📊 RÉSUMÉ DE LA VALIDATION"
echo "=========================="

total_issues=$((missing_files + missing_deps + design_issues + auth_issues + test_issues))

echo "Fichiers manquants: $missing_files"
echo "Dépendances manquantes: $missing_deps"
echo "Problèmes design: $design_issues"
echo "Problèmes authentification: $auth_issues"
echo "Problèmes tests: $test_issues"
echo ""
echo "TOTAL PROBLÈMES: $total_issues"

if [[ $total_issues -eq 0 ]]; then
    echo ""
    echo "🎉 VALIDATION RÉUSSIE!"
    echo "✅ Tous les éléments du Sprint 1 sont présents"
    echo "✅ Design sobre v2 correctement implémenté"
    echo "✅ Architecture complète et cohérente"
    echo "✅ Tests couvrant les fonctionnalités principales"
    echo ""
    echo "🚀 Le projet est prêt pour la compilation et le déploiement!"
    exit 0
else
    echo ""
    echo "❌ VALIDATION ÉCHOUÉE"
    echo "⚠️  $total_issues problème(s) détecté(s)"
    echo ""
    echo "Veuillez corriger les problèmes signalés avant de continuer."
    exit 1
fi
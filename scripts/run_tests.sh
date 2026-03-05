#!/bin/bash

# Script de test complet pour MyCoach - Design Sobre v2
# Utilisation: ./scripts/run_tests.sh [unit|widget|integration|all]

set -e

# Configuration
PROJECT_DIR="flutter"
TEST_TYPE="${1:-all}"
COVERAGE_DIR="coverage"

echo "🧪 MyCoach - Tests (Design Sobre v2)"
echo "===================================="

# Vérification de l'environnement
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter n'est pas installé ou pas dans le PATH"
    exit 1
fi

# Naviguer vers le répertoire du projet
cd "$PROJECT_DIR"

echo "📦 Nettoyage et préparation..."
flutter clean
flutter pub get

echo "🧬 Génération des mocks..."
dart run build_runner build --delete-conflicting-outputs

# Fonction pour exécuter les tests unitaires
run_unit_tests() {
    echo "🔬 Exécution des tests unitaires..."
    flutter test test/unit/ --reporter expanded
}

# Fonction pour exécuter les tests de widgets
run_widget_tests() {
    echo "🎨 Exécution des tests de widgets..."
    flutter test test/widget/ --reporter expanded
}

# Fonction pour exécuter les tests d'intégration
run_integration_tests() {
    echo "🚀 Exécution des tests d'intégration..."
    flutter test test/integration/ --reporter expanded
}

# Fonction pour exécuter tous les tests avec couverture
run_all_tests() {
    echo "📊 Exécution de tous les tests avec couverture..."
    flutter test --coverage --reporter expanded
    
    echo "📈 Génération du rapport de couverture..."
    # Installer lcov si nécessaire: sudo apt-get install lcov
    if command -v lcov &> /dev/null; then
        lcov --remove coverage/lcov.info \
            'lib/generated_plugin_registrant.dart' \
            'lib/main.dart' \
            'lib/**/*.g.dart' \
            'lib/**/*.freezed.dart' \
            -o coverage/lcov_cleaned.info
        
        genhtml coverage/lcov_cleaned.info -o coverage/html
        echo "🌐 Rapport de couverture généré: coverage/html/index.html"
    else
        echo "⚠️  lcov non installé - rapport HTML non généré"
        echo "Installer avec: sudo apt-get install lcov"
    fi
}

# Exécution selon le type demandé
case $TEST_TYPE in
    unit)
        run_unit_tests
        ;;
    widget)
        run_widget_tests
        ;;
    integration)
        run_integration_tests
        ;;
    all)
        run_all_tests
        ;;
    *)
        echo "❌ Type de test invalide: $TEST_TYPE"
        echo "Types disponibles: unit, widget, integration, all"
        exit 1
        ;;
esac

echo ""
echo "✅ Tests terminés avec succès!"

# Analyse du code
echo ""
echo "🔍 Analyse statique du code..."
flutter analyze

# Vérification du formatage
echo ""
echo "📝 Vérification du formatage..."
dart format --set-exit-if-changed lib/ test/

echo ""
echo "🎉 Toutes les vérifications passées!"
echo ""
echo "📋 Résumé:"
echo "  ✅ Tests exécutés"
echo "  ✅ Code analysé"
echo "  ✅ Formatage vérifié"

if [ "$TEST_TYPE" = "all" ] && command -v lcov &> /dev/null; then
    echo "  📊 Couverture disponible: coverage/html/index.html"
fi

echo ""
echo "🚀 Le code est prêt pour le déploiement!"
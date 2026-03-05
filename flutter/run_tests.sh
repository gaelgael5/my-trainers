#!/bin/bash

# Script pour exécuter les tests Flutter de manière robuste
set -e  # Arrêter en cas d'erreur

echo "🧪 Exécution des tests Flutter..."

# Vérifier que nous sommes dans le bon répertoire
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Erreur: pubspec.yaml non trouvé. Exécutez ce script depuis le répertoire flutter/"
    exit 1
fi

# Nettoyer l'environnement
echo "🧹 Nettoyage de l'environnement..."
flutter clean

# Installer les dépendances
echo "📦 Installation des dépendances..."
flutter pub get

# Vérifier l'analyse statique
echo "🔍 Analyse statique du code..."
flutter analyze --no-fatal-infos

# Générer les mocks si nécessaire
echo "🔨 Génération des mocks..."
dart run build_runner build --delete-conflicting-outputs

# Lister les fichiers de test disponibles
echo "📋 Fichiers de test disponibles:"
find test -name "*.dart" ! -name "*.mocks.dart" ! -name "test_helper.dart"

# Exécuter les tests
echo "🧪 Exécution des tests..."
flutter test \
    --dart-define=ENV=test \
    --dart-define=API_BASE_URL=http://localhost:8000 \
    --timeout=30s \
    --concurrency=1 \
    --verbose \
    --reporter=expanded

echo "✅ Tests terminés avec succès!"
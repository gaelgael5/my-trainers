#!/bin/bash

# Script de build APK optimisée pour MyCoach - Design Sobre v2
# Utilisation: ./scripts/build_apk.sh [debug|profile|release]

set -e

# Configuration
PROJECT_DIR="flutter"
BUILD_TYPE="${1:-release}"
OUTPUT_DIR="build/outputs"

echo "🚀 MyCoach - Build APK (Design Sobre v2)"
echo "========================================="

# Vérification de l'environnement
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter n'est pas installé ou pas dans le PATH"
    echo "Veuillez installer Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Naviguer vers le répertoire du projet
cd "$PROJECT_DIR"

echo "📦 Nettoyage du projet..."
flutter clean

echo "📥 Installation des dépendances..."
flutter pub get

echo "🧬 Génération des mocks pour les tests..."
dart run build_runner build --delete-conflicting-outputs

echo "🧪 Exécution des tests..."
flutter test

echo "🔍 Analyse du code..."
flutter analyze

case $BUILD_TYPE in
    debug)
        echo "🐛 Build APK Debug..."
        flutter build apk --debug
        ;;
    profile)
        echo "⚡ Build APK Profile..."
        flutter build apk --profile
        ;;
    release)
        echo "🚀 Build APK Release (optimisée)..."
        flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/debug-info
        ;;
    *)
        echo "❌ Type de build invalide: $BUILD_TYPE"
        echo "Types disponibles: debug, profile, release"
        exit 1
        ;;
esac

# Créer le répertoire de sortie
mkdir -p "../$OUTPUT_DIR"

# Copier les APK
echo "📁 Copie des APK vers $OUTPUT_DIR..."
if [ "$BUILD_TYPE" = "release" ]; then
    cp build/app/outputs/flutter-apk/app-*-release.apk "../$OUTPUT_DIR/"
    echo "✅ APK Release générées:"
    ls -la "../$OUTPUT_DIR/"app-*-release.apk
else
    cp build/app/outputs/flutter-apk/app-$BUILD_TYPE.apk "../$OUTPUT_DIR/"
    echo "✅ APK $BUILD_TYPE générée: $OUTPUT_DIR/app-$BUILD_TYPE.apk"
fi

# Informations sur la taille
echo ""
echo "📊 Taille des APK:"
ls -lah "../$OUTPUT_DIR/"app-*.apk

echo ""
echo "✨ Build terminé avec succès!"
echo "📱 APK disponibles dans: $OUTPUT_DIR/"

# Instructions d'installation
echo ""
echo "💡 Pour installer sur un appareil:"
echo "   adb install $OUTPUT_DIR/app-arm64-v8a-release.apk"
echo ""
echo "🔗 Pour tester sur téléphone via USB:"
echo "   1. Activer le mode développeur sur l'appareil"
echo "   2. Activer le débogage USB"
echo "   3. Connecter l'appareil et autoriser l'ordinateur"
echo "   4. Exécuter: flutter install"
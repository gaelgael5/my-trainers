#!/bin/bash

# Script pour régénérer tous les mocks Flutter
echo "🔨 Régénération des mocks Flutter..."

# Nettoyer les anciens mocks
echo "🧹 Nettoyage des anciens fichiers..."
find test -name "*.mocks.dart" -delete

# Nettoyer le cache
echo "🔄 Nettoyage du cache Dart..."
dart pub cache repair

# Installer les dépendances
echo "📦 Installation des dépendances..."
flutter pub get

# Générer les nouveaux mocks
echo "🔨 Génération des nouveaux mocks..."
dart run build_runner build --delete-conflicting-outputs

echo "✅ Régénération des mocks terminée!"
#!/bin/bash
# 🚨 EMERGENCY FIX - Build #22667785460 Recovery

echo "🚨 CORRECTION URGENTE EN COURS..."

# OPTION 1: Clean dependency overrides
echo "1️⃣ Suppression dependency_overrides problématiques..."
cp pubspec.yaml pubspec.yaml.backup
sed -i '/^# Dependency overrides to resolve version conflicts/,/^flutter:/{ /^flutter:/!d; }' pubspec.yaml

# OPTION 2: Flutter version downgrade (si nécessaire)
echo "2️⃣ Alternative: Flutter 3.19.6 (stable)..."
echo "# Modifier .github/workflows/flutter-ci.yml:"
echo "# FLUTTER_VERSION: '3.19.6'"

# OPTION 3: Force fresh pubspec.lock
echo "3️⃣ Force regeneration pubspec.lock..."
rm -f pubspec.lock
rm -rf .dart_tool

echo ""
echo "✅ CORRECTIONS APPLIQUÉES"
echo "🚀 COMMANDES SUIVANTES:"
echo "   git add pubspec.yaml"
echo "   git commit -m '🚨 EMERGENCY: Remove dependency_overrides conflicts'"
echo "   git push origin dev"
echo ""
echo "📊 VALIDATION:"
echo "   - Si FLUTTER disponible: flutter pub get"
echo "   - Si échec: utiliser Flutter 3.19.6 dans CI"
echo "   - Alternative: build local + upload manuel"
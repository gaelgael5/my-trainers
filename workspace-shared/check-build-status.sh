#!/bin/bash
# Script de vérification du statut de la build Flutter GitHub Actions

echo "🔍 VÉRIFICATION BUILD FLUTTER GITHUB ACTIONS"
echo "============================================"
echo ""

# Vérifier commit actuel
echo "📋 Commit actuel:"
git log --oneline -1
echo ""

# Vérifier la branch
echo "🌿 Branche courante: $(git branch --show-current)"
echo ""

# Vérifier les changements Flutter
echo "🔧 Changements workflow Flutter:"
if git show --name-only HEAD | grep -q "flutter-ci.yml"; then
  echo "  ✅ Workflow Flutter modifié dans ce commit"
else
  echo "  ⚠️  Workflow Flutter non modifié dans ce commit"
fi

if [ -f "flutter/.flutter-version" ]; then
  echo "  ✅ Version Flutter documentée: $(cat flutter/.flutter-version)"
else
  echo "  ⚠️  Fichier .flutter-version manquant"
fi

echo ""
echo "🚀 Pour vérifier le statut de la build:"
echo "   1. Aller sur: https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]\([^.]*\).*/\1/')/actions"
echo "   2. Chercher le workflow 'Flutter Android Build'"
echo "   3. Vérifier le build pour commit: $(git rev-parse --short HEAD)"
echo ""

echo "✅ SUCCÈS ATTENDU:"
echo "   - Build complète sans erreurs"
echo "   - APK générée et uploadée en artifacts"  
echo "   - Pas d'erreurs de version Flutter"
echo "   - Firebase App Distribution réussie"
echo ""
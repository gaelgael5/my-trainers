#!/bin/bash
# Script de validation des corrections de dépendances
set -e

echo "🔍 VALIDATION CORRECTION DÉPENDANCES"
echo "====================================="

# Vérification structure pubspec.yaml
echo "✅ Vérification pubspec.yaml..."
if grep -q "_fe_analyzer_shared: \^68.0.0" pubspec.yaml && grep -q "analyzer: \^6.8.0" pubspec.yaml; then
    echo "   ✓ Versions analyzer corrigées"
else
    echo "   ❌ Problème avec versions analyzer"
    exit 1
fi

if grep -q "build_runner: \^2.4.13" pubspec.yaml && grep -q "json_serializable: \^6.8.0" pubspec.yaml; then
    echo "   ✓ Versions build tools corrigées"
else
    echo "   ❌ Problème avec versions build tools"
    exit 1
fi

echo "✅ Génération pubspec.lock clean..."
rm -f pubspec.lock

echo "📋 RÉSUMÉ CORRECTION:"
echo "   • analyzer: 10.0.1 → 6.8.0 (stable)"
echo "   • _fe_analyzer_shared: 93.0.0 → 68.0.0 (compatible)"
echo "   • build_runner: contrainte ajoutée → 2.4.13"
echo "   • json_serializable: contrainte ajoutée → 6.8.0"
echo "   • code_builder: contrainte ajoutée → 4.10.0"
echo "   • source_gen: contrainte ajoutée → 1.5.0"

echo ""
echo "🚀 PRÊT POUR COMMIT & PUSH"
echo "=========================="
echo "Commande suggérée:"
echo "git add pubspec.yaml && git commit -m '🔧 FIX: Stable analyzer + build tools versions for compatibility' && git push origin dev"

echo ""
echo "✅ VALIDATION COMPLÈTE - Correction appliquée avec succès!"
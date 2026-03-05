#!/bin/bash
# 🚀 Script de démarrage - Debug erreur 403 Firebase

set -e

echo "🚀 DEBUG ERREUR 403 FIREBASE - ASSISTANT DE RÉSOLUTION"
echo "======================================================"

echo ""
echo "Vous avez une erreur 403 persistante avec Firebase App Distribution ?"
echo "Ce guide vous aide à la résoudre définitivement."
echo ""

echo "📋 FICHIERS CRÉÉS POUR VOUS :"
echo "   • fix-403-immediate.sh      - Corrections rapides (5 min)"
echo "   • diagnostic-403-detailed.sh - Diagnostic complet (10 min)"  
echo "   • test-firebase-permissions.sh - Test permissions CLI"
echo "   • alternatives-403.sh       - Solutions de contournement"
echo "   • DIAGNOSTIC_FINAL_403.md   - Guide complet"
echo ""

echo "🎯 PLAN DE RÉSOLUTION RECOMMANDÉ :"
echo "================================="
echo ""
echo "1. 🔥 CORRECTION IMMÉDIATE (commencez ici !) :"
echo "   ./fix-403-immediate.sh"
echo ""
echo "2. 🔍 Si toujours problème, diagnostic complet :"
echo "   ./diagnostic-403-detailed.sh"  
echo ""
echo "3. 🧪 Test de vos permissions Firebase :"
echo "   ./test-firebase-permissions.sh"
echo ""
echo "4. 🔄 Si rien ne marche, solutions alternatives :"
echo "   ./alternatives-403.sh"
echo ""

echo "📖 DOCUMENTATION COMPLÈTE :"
echo "   Lisez DIAGNOSTIC_FINAL_403.md pour comprendre le problème"
echo ""

read -p "Voulez-vous commencer par la correction immédiate ? (o/N): " START_NOW

if [[ "$START_NOW" =~ ^[Oo]$ ]]; then
    echo ""
    echo "🚀 Lancement de la correction immédiate..."
    ./fix-403-immediate.sh
else
    echo ""
    echo "✅ Parfait ! Exécutez les scripts dans l'ordre quand vous êtes prêt."
    echo ""
    echo "💡 CONSEIL : Commencez toujours par fix-403-immediate.sh"
    echo "   C'est la solution la plus probable (70% de chances de succès)"
fi

echo ""
echo "🎉 Bonne résolution ! Ces outils vont résoudre votre problème 403."
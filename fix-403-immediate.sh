#!/bin/bash
# 🔧 Correction immédiate erreur 403 Firebase - Étapes prioritaires

set -e

echo "🚨 CORRECTION IMMÉDIATE ERREUR 403 FIREBASE"
echo "=========================================="

echo ""
echo "1. 🔍 VÉRIFICATION SECRET GITHUB ACTIONS"
echo "-----------------------------------------"
echo "❗ PROBLÈME DÉTECTÉ dans votre workflow :"
echo ""
echo "   Votre fichier utilise :"
echo "   serviceCredentialsFileContent: \${{ secrets.FIREBASE_SERVICE_ACCOUNT }}"
echo ""
echo "   Mais vos guides mentionnent :"
echo "   FIREBASE_SERVICE_ACCOUNT_KEY"
echo ""
echo "✅ ACTION REQUISE :"
echo "   1. Aller dans GitHub → Settings → Secrets and variables → Actions"
echo "   2. Vérifier le nom EXACT du secret contenant votre clé JSON"
echo "   3. Si le secret s'appelle FIREBASE_SERVICE_ACCOUNT_KEY, modifier le workflow :"
echo ""
echo "   CHANGER :"
echo "   serviceCredentialsFileContent: \${{ secrets.FIREBASE_SERVICE_ACCOUNT }}"
echo ""
echo "   EN :"
echo "   serviceCredentialsFileContent: \${{ secrets.FIREBASE_SERVICE_ACCOUNT_KEY }}"

echo ""
echo "2. 🔑 RÉGÉNÉRATION SERVICE ACCOUNT (CRITIQUE)"
echo "---------------------------------------------"
echo "Si l'erreur persiste après #1, regénérer IMMÉDIATEMENT la clé :"
echo ""
echo "✅ ÉTAPES :"
echo "   1. Google Cloud Console → IAM → Service Accounts"
echo "   2. Trouver votre service account Firebase"
echo "   3. Actions → Manage Keys → Add Key → Create New Key → JSON"
echo "   4. Télécharger la NOUVELLE clé JSON"
echo "   5. Remplacer complètement le secret GitHub avec le nouveau JSON"
echo "   6. Attendre 5 minutes AVANT de retester"

echo ""
echo "3. 🎯 AJOUT RÔLES MANQUANTS CRITIQUES"
echo "-------------------------------------"
echo "Ajouter CES RÔLES en plus des rôles existants :"
echo ""
echo "✅ RÔLES REQUIS (ajoutez TOUS) :"
echo "   • Firebase Admin SDK Administrator Service Agent"
echo "   • Storage Object Admin" 
echo "   • Storage Admin"
echo "   • Firebase Service Management Service Agent"
echo "   • Service Account Token Creator"
echo ""
echo "COMMANDES CLI (remplacer PROJECT_ID et SERVICE_ACCOUNT_EMAIL) :"
echo ""
echo 'gcloud projects add-iam-policy-binding PROJECT_ID \'
echo '  --member="serviceAccount:SERVICE_ACCOUNT_EMAIL" \'
echo '  --role="roles/firebase.sdkAdminServiceAgent"'
echo ""
echo 'gcloud projects add-iam-policy-binding PROJECT_ID \'
echo '  --member="serviceAccount:SERVICE_ACCOUNT_EMAIL" \'
echo '  --role="roles/storage.objectAdmin"'
echo ""
echo 'gcloud projects add-iam-policy-binding PROJECT_ID \'
echo '  --member="serviceAccount:SERVICE_ACCOUNT_EMAIL" \'
echo '  --role="roles/storage.admin"'

echo ""
echo "4. 🔄 MISE À JOUR ACTION GITHUB"
echo "-------------------------------"
echo "Remplacer l'action par la version la plus récente :"
echo ""
echo "CHANGER :"
echo "uses: wzieba/Firebase-Distribution-Github-Action@v1"
echo ""
echo "EN :"
echo "uses: wzieba/Firebase-Distribution-Github-Action@v1.7.0"

echo ""
echo "5. ⏰ DÉLAI PROPAGATION"
echo "-----------------------"
echo "Après CHAQUE modification :"
echo "   • Attendre 5-10 minutes avant de retester"
echo "   • Les permissions IAM prennent du temps à se propager"
echo "   • NE PAS tester immédiatement"

echo ""
echo "🎯 ORDRE D'EXÉCUTION PRIORITAIRE :"
echo "================================="
echo "1. Corriger le nom du secret (#1) → TESTER"
echo "2. Si échec → Regénérer clé (#2) → ATTENDRE 5 min → TESTER"
echo "3. Si échec → Ajouter rôles (#3) → ATTENDRE 10 min → TESTER"
echo "4. Si échec → Mise à jour action (#4) → TESTER"
echo ""
echo "📞 Si TOUJOURS 403 après ça → Solutions alternatives ci-dessous"
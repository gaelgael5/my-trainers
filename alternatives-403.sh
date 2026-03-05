#!/bin/bash
# 🔄 Solutions alternatives si erreur 403 Firebase persiste

set -e

echo "🔄 SOLUTIONS ALTERNATIVES - ERREUR 403 PERSISTANTE"
echo "=================================================="

echo ""
echo "Si l'erreur 403 persiste après toutes les corrections, voici 5 alternatives :"

echo ""
echo "🚀 ALTERNATIVE 1: Firebase CLI Direct dans GitHub Actions"
echo "=========================================================="
echo ""
echo "Remplacer l'action wzieba par Firebase CLI direct :"
echo ""

cat << 'EOF'
# Dans votre workflow .github/workflows/flutter-ci.yml
# REMPLACER la section Firebase App Distribution par :

      - name: Install Firebase CLI
        run: npm install -g firebase-tools

      - name: Authenticate Firebase
        env:
          FIREBASE_SERVICE_ACCOUNT: ${{ secrets.FIREBASE_SERVICE_ACCOUNT_KEY }}
        run: |
          echo "$FIREBASE_SERVICE_ACCOUNT" > /tmp/firebase-key.json
          export GOOGLE_APPLICATION_CREDENTIALS=/tmp/firebase-key.json
          firebase --version

      - name: Upload to Firebase App Distribution  
        env:
          FIREBASE_SERVICE_ACCOUNT: ${{ secrets.FIREBASE_SERVICE_ACCOUNT_KEY }}
        run: |
          echo "$FIREBASE_SERVICE_ACCOUNT" > /tmp/firebase-key.json
          export GOOGLE_APPLICATION_CREDENTIALS=/tmp/firebase-key.json
          
          firebase appdistribution:distribute \
            flutter/build/app/outputs/flutter-apk/app-*.apk \
            --app "1:782316914398:android:5085370e3927209e23244f" \
            --groups "testers" \
            --release-notes "Build #${{ github.run_number }} - ${{ github.event.head_commit.message }}"
          
          rm /tmp/firebase-key.json
EOF

echo ""
echo "✅ AVANTAGES :"
echo "   • Contrôle total sur l'authentification"
echo "   • Meilleure gestion des erreurs"
echo "   • Logs plus détaillés"

echo ""
echo "📱 ALTERNATIVE 2: Fastlane + Firebase"
echo "====================================="
echo ""
echo "Utiliser Fastlane pour la distribution :"
echo ""

cat << 'EOF'
# 1. Installer Fastlane dans votre projet Flutter
cd flutter/android
bundle init
echo 'gem "fastlane"' >> Gemfile
bundle install

# 2. Initialiser Fastlane
bundle exec fastlane init

# 3. Configurer fastlane/Fastfile :
default_platform(:android)

platform :android do
  desc "Deploy to Firebase App Distribution"
  lane :firebase_distribution do
    firebase_app_distribution(
      service_credentials_file: ENV["FIREBASE_SERVICE_CREDENTIALS_FILE"],
      app: "1:782316914398:android:5085370e3927209e23244f",
      groups: "testers",
      release_notes: ENV["RELEASE_NOTES"] || "New build from CI",
      apk_path: "../build/app/outputs/flutter-apk/app-release.apk"
    )
  end
end

# 4. Dans GitHub Actions :
      - name: Deploy with Fastlane
        working-directory: flutter/android
        env:
          FIREBASE_SERVICE_CREDENTIALS_FILE: /tmp/firebase-key.json
          RELEASE_NOTES: "Build #${{ github.run_number }}"
        run: |
          echo "${{ secrets.FIREBASE_SERVICE_ACCOUNT_KEY }}" > /tmp/firebase-key.json
          bundle install
          bundle exec fastlane firebase_distribution
          rm /tmp/firebase-key.json
EOF

echo ""
echo "💾 ALTERNATIVE 3: Upload vers Storage + Distribution manuelle"
echo "=============================================================="
echo ""
echo "Si Firebase App Distribution bloque, utiliser Google Cloud Storage :"
echo ""

cat << 'EOF'
# Dans GitHub Actions :
      - name: Upload to Google Cloud Storage
        env:
          GOOGLE_SERVICE_ACCOUNT: ${{ secrets.FIREBASE_SERVICE_ACCOUNT_KEY }}
        run: |
          echo "$GOOGLE_SERVICE_ACCOUNT" > /tmp/gcs-key.json
          gcloud auth activate-service-account --key-file=/tmp/gcs-key.json
          
          # Créer un bucket pour les APKs (une seule fois)
          gsutil mb gs://your-app-builds-bucket || true
          
          # Upload APK avec timestamp
          TIMESTAMP=$(date +%Y%m%d-%H%M%S)
          APK_NAME="my-trainers-${GITHUB_REF_NAME}-${TIMESTAMP}-build${GITHUB_RUN_NUMBER}.apk"
          
          gsutil cp flutter/build/app/outputs/flutter-apk/app-*.apk \
            "gs://your-app-builds-bucket/${APK_NAME}"
          
          # Générer URL de téléchargement
          gsutil signurl /tmp/gcs-key.json \
            "gs://your-app-builds-bucket/${APK_NAME}" \
            -d 7d > download-url.txt
          
          echo "📱 APK disponible pour téléchargement :"
          cat download-url.txt
          
          rm /tmp/gcs-key.json
EOF

echo ""
echo "🔄 ALTERNATIVE 4: Action GitHub Alternative"
echo "==========================================="
echo ""
echo "Utiliser une action Firebase différente :"
echo ""

cat << 'EOF'
# Option A: Action officielle Google
      - name: Upload to Firebase App Distribution
        uses: google-github-actions/firebase-tools-action@v0.0.5
        with:
          args: appdistribution:distribute flutter/build/app/outputs/flutter-apk/app-*.apk --app 1:782316914398:android:5085370e3927209e23244f --groups testers
        env:
          FIREBASE_SERVICE_ACCOUNT: ${{ secrets.FIREBASE_SERVICE_ACCOUNT_KEY }}

# Option B: Action alternative
      - name: Firebase App Distribution
        uses: yellowme/firebase-app-distribution-action@v1.0.0
        with:
          appId: "1:782316914398:android:5085370e3927209e23244f"
          serviceCredentialsFileContent: ${{ secrets.FIREBASE_SERVICE_ACCOUNT_KEY }}
          groups: testers
          file: flutter/build/app/outputs/flutter-apk/app-release.apk
          releaseNotes: "Build from GitHub Actions"
EOF

echo ""
echo "📧 ALTERNATIVE 5: Distribution par Email/Slack"
echo "==============================================="
echo ""
echo "Notifier les testeurs directement avec lien de téléchargement :"
echo ""

cat << 'EOF'
      - name: Upload APK as Artifact
        uses: actions/upload-artifact@v4
        with:
          name: my-trainers-apk-${{ github.run_number }}
          path: flutter/build/app/outputs/flutter-apk/app-*.apk
          retention-days: 30

      - name: Notify Testers
        env:
          SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK }}
        run: |
          APK_URL="https://github.com/${{ github.repository }}/actions/runs/${{ github.run_id }}"
          
          curl -X POST -H 'Content-type: application/json' \
            --data "{
              \"text\":\"🚀 Nouvelle version disponible !\n📱 Build #${{ github.run_number }}\n🔗 Télécharger: ${APK_URL}\n📝 Notes: ${{ github.event.head_commit.message }}\"
            }" \
            $SLACK_WEBHOOK
EOF

echo ""
echo "🔧 DEBUGGING AVANCÉ"
echo "==================="
echo ""
echo "Si TOUTES les alternatives échouent, diagnostic approfondi :"
echo ""

cat << 'EOF'
# Étape debug dans GitHub Actions :
      - name: Debug Firebase Setup
        env:
          FIREBASE_SERVICE_ACCOUNT: ${{ secrets.FIREBASE_SERVICE_ACCOUNT_KEY }}
        run: |
          echo "=== DEBUG FIREBASE SETUP ==="
          
          # 1. Vérifier le secret
          echo "Secret length: ${#FIREBASE_SERVICE_ACCOUNT}"
          
          # 2. Valider JSON
          echo "$FIREBASE_SERVICE_ACCOUNT" | jq . > /dev/null && echo "✅ JSON valide" || echo "❌ JSON invalide"
          
          # 3. Extraire infos du service account
          echo "$FIREBASE_SERVICE_ACCOUNT" > /tmp/firebase-key.json
          echo "Project ID: $(jq -r '.project_id' /tmp/firebase-key.json)"
          echo "Client Email: $(jq -r '.client_email' /tmp/firebase-key.json)"
          echo "Private Key ID: $(jq -r '.private_key_id' /tmp/firebase-key.json)"
          
          # 4. Test authentification
          export GOOGLE_APPLICATION_CREDENTIALS=/tmp/firebase-key.json
          gcloud auth activate-service-account --key-file=/tmp/firebase-key.json
          gcloud auth list
          
          # 5. Test API Firebase
          TOKEN=$(gcloud auth application-default print-access-token)
          curl -v -X GET \
            "https://firebaseappdistribution.googleapis.com/v1/projects/$(jq -r '.project_id' /tmp/firebase-key.json)/apps" \
            -H "Authorization: Bearer $TOKEN"
          
          rm /tmp/firebase-key.json
EOF

echo ""
echo "🎯 RECOMMANDATIONS PAR ORDRE DE PRIORITÉ"
echo "========================================"
echo ""
echo "1. 🥇 ESSAYEZ D'ABORD : Alternative 1 (Firebase CLI Direct)"
echo "   → Plus de contrôle, meilleur debugging"
echo ""
echo "2. 🥈 SI ÉCHEC : Alternative 4 (Action GitHub différente)"
echo "   → Solution rapide sans refonte"
echo ""
echo "3. 🥉 SI TOUJOURS ÉCHEC : Alternative 3 (Google Cloud Storage)"
echo "   → Workaround garanti qui fonctionne"
echo ""
echo "4. 🔧 EN DERNIER RECOURS : Alternative 5 (Distribution manuelle)"
echo "   → Solution temporaire pendant investigation"

echo ""
echo "📞 SUPPORT ESCALATION"
echo "====================="
echo ""
echo "Si AUCUNE solution ne fonctionne :"
echo ""
echo "1. 📧 Créer un ticket support Google Cloud :"
echo "   https://cloud.google.com/support"
echo ""
echo "2. 🐛 Signaler le bug à l'action wzieba :"
echo "   https://github.com/wzieba/Firebase-Distribution-Github-Action/issues"
echo ""
echo "3. 💬 Demander de l'aide sur Discord Firebase :"
echo "   https://discord.gg/firebase"
echo ""
echo "4. 📚 Stack Overflow avec tags :"
echo "   firebase, firebase-app-distribution, github-actions"

echo ""
echo "✨ FIN DES ALTERNATIVES"
echo ""
echo "📝 NOTE: Sauvegardez votre configuration actuelle avant d'essayer ces alternatives !"
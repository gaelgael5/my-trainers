# 🔥 Firebase Setup Guide - MyCoach

## 1. Créer le Projet Firebase

### Console Firebase
1. Va sur [Firebase Console](https://console.firebase.google.com/)
2. Clique "Ajouter un projet"
3. Nom: **MyCoach** (ou mycoach-app)
4. Activer Google Analytics (recommandé)
5. Créer le projet

### Configuration du projet
```bash
# Note l'ID du projet (ex: mycoach-123456)
PROJECT_ID="mycoach-123456"
```

## 2. Configurer App Distribution (Tests Humains)

### Dans Firebase Console
1. Menu → **App Distribution**
2. Cliquer "Commencer"
3. Ajouter des testeurs :
   - Emails des testeurs
   - Ou groupes de testeurs

### Configuration locale
```bash
# Installer Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Obtenir le token CI/CD
firebase login:ci
# ⚠️ Copie le token affiché - c'est FIREBASE_TOKEN
```

## 3. Configurer l'App Flutter

### Dans Firebase Console
1. Cliquer **"Ajouter une app"** → **Android**
2. Package Android : `com.mycoach.app`
3. Nom app : `M-Trainers`
4. Télécharger `google-services.json`
4. **NE PAS COMMITER ce fichier** (déjà dans .gitignore)

### Configuration Flutter
```bash
cd flutter/
# Installer FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurer Firebase
flutterfire configure --project=$PROJECT_ID
```

## 4. Configurer Firebase Hosting (Web App)

### Dans Firebase Console
1. Menu → **Hosting**
2. Cliquer "Commencer"
3. Domaine: `mycoach-123456.web.app`

### Configuration locale
```bash
cd flutter/
# Créer firebase.json
cat > firebase.json << EOF
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
EOF
```

## 5. Configuration GitHub Secrets

### Dans GitHub Repository
1. Va sur **Settings** → **Secrets and variables** → **Actions**
2. Ajoute ces secrets :

```bash
# 🔑 SECRETS OBLIGATOIRES
FIREBASE_TOKEN          # Token de firebase login:ci
FIREBASE_PROJECT_ID     # ID projet (ex: mycoach-123456)
FIREBASE_APP_ID         # ID app Android depuis Firebase Console
```

### Récupérer FIREBASE_APP_ID
1. Firebase Console → **Paramètres projet** (roue dentée)
2. Onglet **"Vos applications"**
3. Copie l'**ID de l'application** (format: `1:123456789:android:abc123def456`)

## 6. Test du Pipeline

### Push pour déclencher
```bash
# Sur branche dev
git checkout dev
echo "# Test" >> flutter/README.md
git add .
git commit -m "test: trigger Firebase workflow"
git push origin dev
```

### Vérification
1. GitHub → **Actions** → Vérifier le workflow Flutter
2. Firebase Console → **App Distribution** → Voir la nouvelle version
3. Les testeurs reçoivent une notification email

## 7. Configuration Avancée (Optionnel)

### Variables d'environnement
```bash
# Dans GitHub Secrets (optionnel)
FIREBASE_WEB_API_KEY    # Pour config web
FIREBASE_AUTH_DOMAIN    # Pour authentification
FIREBASE_STORAGE_BUCKET # Pour storage
```

### Notifications Slack/Discord
```bash
# Ajouter dans GitHub Secrets
DISCORD_WEBHOOK_URL     # Pour notifications build
```

## 🚀 Résultat Final

**Quand tu push du code Flutter sur `dev` :**
1. ✅ Tests automatiques
2. ✅ Build APK Android 
3. ✅ Upload vers Firebase App Distribution
4. ✅ Build web + deploy Firebase Hosting
5. ✅ Testeurs reçoivent notification email
6. ✅ APK téléchargeable via lien Firebase

**URLs importantes :**
- **Tests APK** : Firebase App Distribution (email aux testeurs)
- **Web app** : `https://mycoach-123456.web.app`
- **Admin** : `https://console.firebase.google.com/`

## ⚠️ Sécurité

- ❌ Ne jamais commiter `google-services.json`
- ✅ Utiliser GitHub Secrets pour tokens
- ✅ Limiter les testeurs Firebase
- ✅ Activer les règles de sécurité Firestore (si database)

**🎯 Configuration terminée ! Tests humains opérationnels via Firebase.**
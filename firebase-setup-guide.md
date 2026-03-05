# 🔥 Guide Configuration Firebase App Distribution + GitHub Actions

## Vue d'ensemble

Ce guide vous accompagne pour configurer le déploiement automatique de votre APK Flutter vers Firebase App Distribution via GitHub Actions.

## 📋 Prérequis

- Un compte Google/Firebase
- Un projet Flutter Android fonctionnel
- Un repository GitHub avec GitHub Actions activé
- APK build fonctionnel en local

---

## 🔧 PARTIE 1 : Configuration Firebase Console

### Étape 1 : Création/Configuration du projet Firebase

1. **Accéder à Firebase Console**
   - URL : https://console.firebase.google.com/
   - Se connecter avec votre compte Google

2. **Créer un nouveau projet (si nécessaire)**
   - Cliquer sur "Ajouter un projet"
   - Nom du projet : `[votre-nom-app]`
   - Accepter les conditions
   - Activer/Désactiver Google Analytics selon vos besoins

3. **Accéder au projet existant**
   - Sélectionner votre projet dans la liste

### Étape 2 : Activation de Firebase App Distribution

1. **Dans la console Firebase, navigation:**
   ```
   Menu latéral → Version et tests → App Distribution
   ```

2. **Première activation :**
   - Cliquer sur "Commencer"
   - Accepter les conditions de service

### Étape 3 : Ajout de l'application Android

1. **Ajouter une app Android :**
   ```
   Paramètres du projet (roue dentée) → Vos applications → Ajouter une app → Android
   ```

2. **Configuration requise :**
   - **Nom du package Android** : `com.example.votre_app` (trouvez-le dans `android/app/build.gradle`)
   - **Surnom de l'app** : Nom lisible de votre app
   - **Certificat de signature SHA-1** : Optionnel pour App Distribution

3. **Télécharger google-services.json :**
   - Télécharger le fichier `google-services.json`
   - Le placer dans `android/app/google-services.json`

### Étape 4 : Configuration App Distribution

1. **Accéder à App Distribution :**
   ```
   Version et tests → App Distribution
   ```

2. **Sélectionner votre app Android** dans la liste

3. **Noter l'App ID :**
   - Format : `1:123456789:android:abcdef123456`
   - Visible dans les paramètres de l'app

### Étape 5 : Création du Service Account

1. **Accéder à IAM et administration :**
   - URL : https://console.cloud.google.com/iam-admin/serviceaccounts
   - Sélectionner votre projet Firebase

2. **Créer un compte de service :**
   ```
   + CRÉER UN COMPTE DE SERVICE
   ```

3. **Configuration du compte :**
   - **Nom** : `firebase-app-distribution`
   - **ID** : `firebase-app-distribution` (auto-généré)
   - **Description** : "Service account for GitHub Actions Firebase App Distribution"

4. **Attribution des rôles :**
   ```
   Rôle 1: Firebase App Distribution Admin
   Rôle 2: Firebase Admin SDK Administrator Service Agent
   ```

5. **Création de la clé JSON :**
   ```
   Actions → Gérer les clés → Ajouter une clé → Créer une clé → JSON
   ```
   - Télécharger le fichier JSON (gardez-le sécurisé !)

### Étape 6 : Configuration des testeurs (optionnel)

1. **Dans App Distribution :**
   ```
   Testeurs et groupes → Ajouter des testeurs
   ```

2. **Ajouter des emails de testeurs ou créer des groupes**

---

## 🔑 PARTIE 2 : Configuration des GitHub Secrets

### Secrets requis

Accédez aux paramètres de votre repository GitHub :
```
Settings → Secrets and variables → Actions → New repository secret
```

#### Secret 1 : FIREBASE_SERVICE_ACCOUNT_KEY

- **Nom exact** : `FIREBASE_SERVICE_ACCOUNT_KEY`
- **Format** : Contenu complet du fichier JSON du service account
- **Source** : Fichier JSON téléchargé à l'étape 5.5
- **Valeur** : 
  ```json
  {
    "type": "service_account",
    "project_id": "votre-project-id",
    "private_key_id": "...",
    "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-app-distribution@votre-project.iam.gserviceaccount.com",
    "client_id": "...",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    ...
  }
  ```

#### Secret 2 : FIREBASE_APP_ID

- **Nom exact** : `FIREBASE_APP_ID`
- **Format** : ID de l'application Firebase
- **Source** : Console Firebase → Paramètres du projet → Vos applications
- **Valeur** : `1:123456789:android:abcdef123456789`

#### Secret 3 : FIREBASE_PROJECT_ID

- **Nom exact** : `FIREBASE_PROJECT_ID`
- **Format** : ID du projet Firebase
- **Source** : Console Firebase → Paramètres du projet → Informations générales
- **Valeur** : `votre-project-id`

### Variables optionnelles (pas des secrets)

Vous pouvez également configurer ces variables dans `Actions secrets and variables → Variables` :

#### FIREBASE_GROUPS

- **Nom** : `FIREBASE_GROUPS`
- **Valeur** : `testeurs,qa-team` (noms des groupes séparés par des virgules)

#### RELEASE_NOTES

- **Nom** : `RELEASE_NOTES`  
- **Valeur** : `"Nouvelle version automatique depuis GitHub Actions"`

---

## 🚀 PARTIE 3 : Configuration GitHub Actions Workflow

### Exemple de workflow complet

Créer `.github/workflows/deploy-firebase.yml` :

```yaml
name: Build and Deploy to Firebase App Distribution

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Setup Java
      uses: actions/setup-java@v4
      with:
        java-version: '17'
        distribution: 'temurin'
        
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.0'
        
    - name: Install dependencies
      run: flutter pub get
      
    - name: Build APK
      run: flutter build apk --release
      
    - name: Upload to Firebase App Distribution
      uses: wzieba/Firebase-Distribution-Github-Action@v1.7.0
      with:
        appId: ${{ secrets.FIREBASE_APP_ID }}
        serviceCredentialsFileContent: ${{ secrets.FIREBASE_SERVICE_ACCOUNT_KEY }}
        groups: ${{ vars.FIREBASE_GROUPS || 'testeurs' }}
        file: build/app/outputs/flutter-apk/app-release.apk
        releaseNotes: ${{ vars.RELEASE_NOTES || 'Automated build from GitHub Actions' }}
```

---

## ✅ PARTIE 4 : Tests et Validation

### Test 1 : Validation des secrets GitHub

```bash
# Dans GitHub Actions, ajouter cette step de debug temporaire :
- name: Validate Firebase Secrets
  run: |
    echo "Firebase Project ID: ${{ secrets.FIREBASE_PROJECT_ID }}"
    echo "Firebase App ID: ${{ secrets.FIREBASE_APP_ID }}"
    echo "Service Account configured: $([ -n "${{ secrets.FIREBASE_SERVICE_ACCOUNT_KEY }}" ] && echo "✅ Yes" || echo "❌ No")"
```

### Test 2 : Validation du build local

```bash
# Tester le build en local
flutter clean
flutter pub get
flutter build apk --release

# Vérifier que le fichier APK existe
ls -la build/app/outputs/flutter-apk/app-release.apk
```

### Test 3 : Test Firebase CLI (optionnel)

1. **Installer Firebase CLI :**
   ```bash
   npm install -g firebase-tools
   ```

2. **Se connecter :**
   ```bash
   firebase login
   ```

3. **Tester l'upload manuel :**
   ```bash
   firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
     --app YOUR_FIREBASE_APP_ID \
     --groups "testeurs"
   ```

### Test 4 : Validation du workflow GitHub

1. **Pusher du code sur la branche principale**

2. **Vérifier dans Actions :**
   - Aller sur https://github.com/[username]/[repo]/actions
   - Vérifier que le workflow se lance
   - Examiner les logs en cas d'erreur

3. **Vérifier dans Firebase :**
   - Console Firebase → App Distribution
   - Vérifier qu'une nouvelle version apparaît
   - Vérifier que les testeurs reçoivent la notification

---

## 🔧 URLs et Commandes de Référence

### URLs importantes

- **Firebase Console** : https://console.firebase.google.com/
- **Google Cloud Console (IAM)** : https://console.cloud.google.com/iam-admin/serviceaccounts
- **Firebase App Distribution** : https://console.firebase.google.com/project/[PROJECT_ID]/appdistribution

### Commandes utiles

```bash
# Vérifier la configuration Flutter
flutter doctor

# Builder APK de release
flutter build apk --release --verbose

# Vérifier le package name Android
grep "applicationId" android/app/build.gradle

# Lister les apps Firebase d'un projet
firebase apps:list --project PROJECT_ID

# Distribuer manuellement avec Firebase CLI
firebase appdistribution:distribute PATH_TO_APK --app APP_ID --groups "GROUP_NAME"
```

### Chemins importants

- **APK de sortie** : `build/app/outputs/flutter-apk/app-release.apk`
- **Google Services** : `android/app/google-services.json`
- **Build Gradle** : `android/app/build.gradle`
- **Workflow GitHub** : `.github/workflows/deploy-firebase.yml`

---

## 🛠️ Résolution de Problèmes

### Erreur : "App not found"

- Vérifier que `FIREBASE_APP_ID` correspond exactement à l'ID dans Firebase Console
- Format attendu : `1:123456789:android:abcdef123456789`

### Erreur : "Permission denied"

- Vérifier que le service account a les rôles `Firebase App Distribution Admin`
- Recréer une nouvelle clé JSON si nécessaire

### Erreur : "Invalid service account"

- Vérifier que le JSON du service account est complet et valide
- Éviter les caractères d'échappement supplémentaires

### APK non trouvé

- Vérifier le chemin : `build/app/outputs/flutter-apk/app-release.apk`
- S'assurer que `flutter build apk --release` s'exécute avant l'upload

---

## 📝 Récapitulatif des Actions

### ✅ Actions côté Firebase :
- [ ] Créer/sélectionner projet Firebase
- [ ] Activer App Distribution  
- [ ] Ajouter app Android
- [ ] Créer service account avec bons rôles
- [ ] Télécharger clé JSON
- [ ] Noter App ID et Project ID

### ✅ Actions côté GitHub :
- [ ] Configurer secret `FIREBASE_SERVICE_ACCOUNT_KEY`
- [ ] Configurer secret `FIREBASE_APP_ID`  
- [ ] Configurer secret `FIREBASE_PROJECT_ID`
- [ ] Créer workflow `.github/workflows/deploy-firebase.yml`
- [ ] Tester le déploiement

### ✅ Tests de validation :
- [ ] Build APK local fonctionne
- [ ] Workflow GitHub se lance sans erreur
- [ ] APK apparaît dans Firebase App Distribution
- [ ] Testeurs reçoivent les notifications

---

**🎉 Une fois tout configuré, chaque push sur votre branche principale déclenchera automatiquement la construction et le déploiement de votre APK sur Firebase App Distribution !**
# Procédure Auth Firebase + Secrets GitHub

## 1. Service Account Firebase

### Étapes Firebase Console
1. **Firebase Console** → Sélectionner votre projet
2. **Project Settings** (⚙️) → Onglet **Service Accounts**
3. **Generate new private key** → Télécharger le fichier JSON
4. **Rôles requis :**
   - Firebase App Distribution Admin
   - Firebase Admin SDK Administrator Service Agent

### Fichier généré
```json
{
  "type": "service_account",
  "project_id": "votre-project-id",
  "private_key_id": "...",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...",
  "client_email": "firebase-adminsdk-xxxxx@votre-project-id.iam.gserviceaccount.com",
  "client_id": "...",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token"
}
```

## 2. Secrets GitHub Actions

### Configuration Repository
**Repository** → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

### 3 Secrets requis :

#### 1. `FIREBASE_SERVICE_ACCOUNT_KEY`
```
Contenu complet du fichier JSON (format minifié, sans espaces)
```

#### 2. `FIREBASE_APP_ID`
```
1:123456789:android:abcdef123456789 
```
*(depuis Firebase Console → Project Settings → General → Vos apps)*

#### 3. `FIREBASE_PROJECT_ID` 
```
votre-project-id
```
*(même valeur que dans le JSON service account)*

## 3. Validation

### Test rapide
```yaml
# Dans .github/workflows/
- name: Test Firebase Auth
  run: |
    echo "${{ secrets.FIREBASE_SERVICE_ACCOUNT_KEY }}" | base64
    echo "Project: ${{ secrets.FIREBASE_PROJECT_ID }}"
    echo "App ID: ${{ secrets.FIREBASE_APP_ID }}"
```

### Vérification Firebase
- Service account actif dans **IAM & Admin** (Cloud Console)
- App Distribution accessible avec ce compte
- Clés valides et non expirées

---
**✅ FAIT** - Auth Firebase configurée + 3 secrets GitHub définis
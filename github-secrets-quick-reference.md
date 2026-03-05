# 🔑 Référence Rapide : Secrets GitHub pour Firebase App Distribution

## Secrets à Configurer

Aller dans `Settings → Secrets and variables → Actions → New repository secret`

### 1. FIREBASE_SERVICE_ACCOUNT_KEY
```
Nom: FIREBASE_SERVICE_ACCOUNT_KEY
Type: Secret
Source: Fichier JSON du service account téléchargé depuis Google Cloud Console
Format: JSON complet (copier-coller tout le contenu du fichier .json)
```

### 2. FIREBASE_APP_ID  
```
Nom: FIREBASE_APP_ID
Type: Secret
Source: Firebase Console → Paramètres projet → Vos applications → Android App
Format: 1:123456789:android:abcdef123456789
```

### 3. FIREBASE_PROJECT_ID
```
Nom: FIREBASE_PROJECT_ID  
Type: Secret
Source: Firebase Console → Paramètres projet → Informations générales
Format: nom-du-projet-firebase
```

## Variables Optionnelles

Aller dans `Settings → Secrets and variables → Actions → Variables → New repository variable`

### 4. FIREBASE_GROUPS (optionnel)
```
Nom: FIREBASE_GROUPS
Type: Variable (pas secret)
Format: testeurs,qa-team,beta-users
```

### 5. RELEASE_NOTES (optionnel)
```
Nom: RELEASE_NOTES
Type: Variable (pas secret) 
Format: "Build automatique depuis GitHub Actions"
```

## ⚡ Commandes de Test

```bash
# Vérifier que les secrets sont configurés (ajouter temporairement au workflow)
- name: Check Secrets
  run: |
    echo "Project ID: ${{ secrets.FIREBASE_PROJECT_ID }}"
    echo "App ID: ${{ secrets.FIREBASE_APP_ID }}" 
    echo "Service Account: $([ -n "${{ secrets.FIREBASE_SERVICE_ACCOUNT_KEY }}" ] && echo "✅" || echo "❌")"
```

## 🎯 Où Trouver Chaque Valeur

| Secret | Où le trouver | Chemin exact |
|--------|---------------|---------------|
| `FIREBASE_SERVICE_ACCOUNT_KEY` | Google Cloud Console | IAM → Comptes de service → Actions → Gérer les clés |
| `FIREBASE_APP_ID` | Firebase Console | Paramètres projet (⚙️) → Vos applications → Android |
| `FIREBASE_PROJECT_ID` | Firebase Console | Paramètres projet (⚙️) → Informations générales |

## 🔍 Validation Rapide

1. **Secrets configurés** : 3 secrets créés dans GitHub
2. **Format App ID** : Commence par `1:` et contient `android:`
3. **Service Account JSON** : Contient `private_key`, `client_email`, etc.
4. **Project ID** : Correspond au nom visible dans Firebase Console
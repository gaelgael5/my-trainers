# Guide de Correction des Permissions Firebase Service Account

## Contexte
Erreur 403 "The caller does not have permission" lors d'upload Firebase App Distribution - problème de rôles service account.

## Rôles Firebase Requis pour App Distribution

### Rôles Essentiels
1. **Firebase App Distribution Admin** (`roles/firebase.developmentAdmin`)
   - Permet de gérer les distributions d'applications
   - Requis pour upload et gestion des releases

2. **Firebase Quality Admin** (`roles/firebase.qualityAdmin`) 
   - Accès aux fonctionnalités de test et distribution
   - Nécessaire pour App Distribution

3. **Firebase Admin** (`roles/firebase.admin`)
   - Accès complet au projet Firebase
   - Alternative si permissions granulaires insuffisantes

### Rôles Complémentaires (selon besoins)
- **Storage Object Admin** (`roles/storage.objectAdmin`) - si stockage fichiers
- **Cloud Build Service Account** (`roles/cloudbuild.builds.builder`) - si CI/CD
- **Service Account User** (`roles/iam.serviceAccountUser`) - pour impersonation

## Steps Firebase Console - Ajout Permissions

### Étape 1: Accéder à IAM
1. Ouvrir [Firebase Console](https://console.firebase.google.com)
2. Sélectionner votre projet
3. Cliquer sur l'icône ⚙️ (Settings) → **Project settings**
4. Aller dans l'onglet **Service accounts**
5. Noter l'email du service account (format: `firebase-adminsdk-xxxxx@projet.iam.gserviceaccount.com`)

### Étape 2: Google Cloud Console IAM
1. Ouvrir [Google Cloud Console](https://console.cloud.google.com)
2. Sélectionner le même projet
3. Navigation: **IAM & Admin** → **IAM**

### Étape 3: Ajouter Rôles au Service Account
1. Rechercher votre service account dans la liste
2. Cliquer sur l'icône ✏️ (Edit) à droite de la ligne
3. Cliquer **+ ADD ANOTHER ROLE**
4. Ajouter les rôles suivants un par un:

```
Firebase App Distribution Admin
Firebase Quality Admin  
Firebase Admin (si les deux précédents insuffisants)
```

### Étape 4: Validation des Permissions
1. Cliquer **SAVE** après ajout de chaque rôle
2. Vérifier que les rôles apparaissent dans la colonne "Role"
3. Attendre 1-2 minutes pour propagation des permissions

## Vérification Service Account

### Vérifier les Rôles Actuels
```bash
# Lister les rôles du service account
gcloud projects get-iam-policy PROJECT_ID --format=json | jq '.bindings[] | select(.members[] | contains("SERVICE_ACCOUNT_EMAIL"))'
```

### Ajouter Rôles via CLI (Alternative)
```bash
# Firebase App Distribution Admin
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:SERVICE_ACCOUNT_EMAIL" \
  --role="roles/firebase.developmentAdmin"

# Firebase Quality Admin  
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:SERVICE_ACCOUNT_EMAIL" \
  --role="roles/firebase.qualityAdmin"

# Firebase Admin (si nécessaire)
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:SERVICE_ACCOUNT_EMAIL" \
  --role="roles/firebase.admin"
```

## Test de Validation des Permissions

### Test 1: Vérification API Firebase
```bash
# Test avec curl (remplacer TOKEN par access token du service account)
curl -X GET \
  "https://firebaseappdistribution.googleapis.com/v1/projects/PROJECT_ID/apps" \
  -H "Authorization: Bearer ACCESS_TOKEN"
```

### Test 2: Upload Test via Firebase CLI
```bash
# Authentification avec service account
export GOOGLE_APPLICATION_CREDENTIALS="path/to/service-account-key.json"

# Test upload (remplacer APP_ID par votre app ID)
firebase appdistribution:distribute path/to/app.apk \
  --app APP_ID \
  --groups "testers" \
  --release-notes "Test permissions"
```

### Test 3: Vérification Programmatique
```python
import firebase_admin
from firebase_admin import credentials, app_distribution

# Initialiser avec service account
cred = credentials.Certificate('path/to/service-account-key.json')
firebase_admin.initialize_app(cred)

try:
    # Test accès App Distribution
    client = app_distribution.Client()
    # Si pas d'exception, permissions OK
    print("✅ Permissions App Distribution valides")
except Exception as e:
    print(f"❌ Erreur permissions: {e}")
```

## Diagnostic Erreurs Courantes

### Erreur: "Permission denied" ou 403
**Solution**: Ajouter le rôle `Firebase Admin` en plus des rôles spécifiques

### Erreur: "Service account not found"  
**Solution**: Vérifier que le service account existe et est activé

### Erreur: "Invalid credentials"
**Solution**: Re-télécharger la clé du service account depuis Firebase Console

### Erreur: "Project not found"
**Solution**: Vérifier que le PROJECT_ID est correct et que le service account appartient au bon projet

## Checklist Final

- [ ] Service account existe dans Firebase Console
- [ ] Rôle `Firebase App Distribution Admin` assigné
- [ ] Rôle `Firebase Quality Admin` assigné  
- [ ] Permissions propagées (attendre 2 minutes)
- [ ] Test upload réussi
- [ ] Clé service account à jour et valide

## Commandes de Debug

```bash
# Vérifier identité du service account
gcloud auth list

# Vérifier projet actuel
gcloud config get-value project

# Tester authentification
gcloud auth application-default print-access-token

# Lister tous les rôles Firebase disponibles
gcloud iam roles list --filter="name:firebase"
```

---

**Note**: Les permissions peuvent prendre jusqu'à 5 minutes pour se propager complètement. Si l'erreur 403 persiste après ajout des rôles, attendre quelques minutes avant de retester.
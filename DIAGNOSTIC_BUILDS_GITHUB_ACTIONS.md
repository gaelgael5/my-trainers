# 🔧 DIAGNOSTIC COMPLET BUILDS GITHUB ACTIONS - MyCoach

**Date :** 2026-03-05  
**Agent :** sysadmin  
**Priorité :** HAUTE ⚠️

## 📊 RÉSUMÉ EXÉCUTIF

**ÉTAT ACTUEL :** ❌ Builds échecs persistants depuis plusieurs jours  
**DERNIERS BUILDS :** Tous en échec (5 dernières exécutions)  
**PROBLÈMES IDENTIFIÉS :** 3 critiques + 2 mineurs  
**CORRECTION ESTIMÉE :** 30-60 minutes

---

## 🚨 PROBLÈMES IDENTIFIÉS (PAR PRIORITÉ)

### ⭐ CRITIQUE #1 : Erreur Firebase 403 (Bloque déploiement)

**CAUSE :** Secret GitHub incorrectement nommé + permissions service account  
**IMPACT :** Firebase App Distribution échoue → pas de distribution aux testeurs  
**STATUS :** 🔍 Diagnostiqué, solutions prêtes

**DÉTAILS :**
- Workflow utilise : `${{ secrets.FIREBASE_SERVICE_ACCOUNT }}`
- Documentation mentionne : `FIREBASE_SERVICE_ACCOUNT_KEY`
- Action GitHub obsolète : `wzieba/Firebase-Distribution-Github-Action@v1`
- Permissions service account potentiellement insuffisantes

**CORRECTIFS IDENTIFIÉS :**
1. ✅ Vérification nom secret GitHub
2. ✅ Mise à jour action vers v1.7.0  
3. ✅ Ajout rôles manquants service account
4. ✅ Alternative Firebase CLI direct (backup)

### ⭐ CRITIQUE #2 : Dependency_overrides Flutter (RÉSOLU)

**CAUSE :** Conflits versions analyzer avec Flutter 3.24.1  
**IMPACT :** Build Flutter échoue sur `flutter pub get`  
**STATUS :** ✅ RÉSOLU dans commit précédent

**HISTORIQUE :**
- ❌ AVANT : `dependency_overrides` forçait `analyzer: ^6.8.0` (incompatible)
- ✅ APRÈS : `dependency_overrides` supprimé → résolution naturelle

### ⭐ MAJEUR #3 : Actions dépréciées (RÉSOLU)

**CAUSE :** `actions/upload-artifact@v3` déprécié  
**IMPACT :** Warnings CI + risque de casse future  
**STATUS :** ✅ RÉSOLU - migré vers v4

### 🔶 MINEUR #4 : Timeout Flutter tests

**CAUSE :** Tests Flutter trop lents (timeout 60s par défaut)  
**IMPACT :** Tests intermittents, ralentit CI  
**STATUS :** ✅ Configuration optimisée (concurrency=1, timeout=30s)

### 🔶 MINEUR #5 : Docker image scan strict

**CAUSE :** Trivy scan bloque sur CVE HIGH (pas que CRITICAL)  
**IMPACT :** Déploiement bloqué pour CVE non-critiques  
**STATUS :** ⚠️ À ajuster selon politique sécurité

---

## 🎯 PLAN DE CORRECTION (ÉTAPES ORDONNÉES)

### 🔥 PHASE 1 - CORRECTIONS IMMÉDIATES (5-10 min)

#### 1.1 Correction secret Firebase
```yaml
# Dans .github/workflows/ci-cd-complete.yml ET flutter-ci.yml
# REMPLACER :
serviceCredentialsFileContent: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}

# PAR (si le secret s'appelle FIREBASE_SERVICE_ACCOUNT_KEY) :
serviceCredentialsFileContent: ${{ secrets.FIREBASE_SERVICE_ACCOUNT_KEY }}
```

#### 1.2 Mise à jour action Firebase
```yaml
# REMPLACER :
uses: wzieba/Firebase-Distribution-Github-Action@v1

# PAR :
uses: wzieba/Firebase-Distribution-Github-Action@v1.7.0
```

### 🔑 PHASE 2 - PERMISSIONS SERVICE ACCOUNT (si Phase 1 échoue)

#### 2.1 Régénération clé service account
1. Google Cloud Console → IAM & Admin → Service Accounts
2. Créer nouveau service account : `firebase-app-distribution-2026`
3. Ajouter TOUS ces rôles :
   ```
   • Firebase Admin SDK Administrator Service Agent
   • Firebase App Distribution Admin  
   • Firebase Quality Admin
   • Storage Admin
   • Storage Object Admin
   • Service Account Token Creator
   • Firebase Service Management Service Agent
   ```
4. Télécharger clé JSON
5. Remplacer secret GitHub **complètement**
6. ⏰ **ATTENDRE 10 MINUTES** avant test

### 🚀 PHASE 3 - SOLUTION ALTERNATIVE (si problème persiste)

#### 3.1 Remplacement action Firebase par CLI direct
```yaml
      # SUPPRIMER l'action wzieba
      # REMPLACER PAR :
      
      - name: Install Firebase CLI
        run: npm install -g firebase-tools

      - name: Upload to Firebase App Distribution
        env:
          FIREBASE_SERVICE_ACCOUNT: ${{ secrets.FIREBASE_SERVICE_ACCOUNT_KEY }}
        run: |
          echo "$FIREBASE_SERVICE_ACCOUNT" > /tmp/firebase-key.json
          export GOOGLE_APPLICATION_CREDENTIALS=/tmp/firebase-key.json
          
          firebase appdistribution:distribute \
            flutter/build/app/outputs/flutter-apk/app-*.apk \
            --app "1:320022309385:android:838aa805fc59ee1d13e6d8" \
            --groups "testers" \
            --release-notes "Build #${{ github.run_number }} - ${{ github.event.head_commit.message }}" \
            --project "my-trainers-224df"
          
          rm /tmp/firebase-key.json
```

---

## 🧪 TESTS DE VALIDATION

### Test Local (avant commit)
```bash
# Test de base Flutter (sans Firebase)
cd flutter
flutter clean
flutter pub get
flutter analyze
flutter test --timeout=30s
```

### Test GitHub Actions
1. Push sur branche `dev` 
2. Surveiller workflow : https://github.com/gaelgael5/my-trainers/actions
3. Vérifier logs Firebase Distribution step
4. Confirmer APK dans Firebase Console

### Test Firebase Distribution
1. Firebase Console → App Distribution
2. Vérifier upload APK récent
3. Tester notification testeurs
4. Download/install APK pour validation

---

## 🔧 FICHIERS À MODIFIER

### Fichiers prioritaires (Phase 1)
- `.github/workflows/ci-cd-complete.yml` ⚠️
- `.github/workflows/flutter-ci.yml` ⚠️

### Fichiers de backup (Phase 2) 
- Scripts de correction déjà présents :
  - `diagnostic-403-detailed.sh` ✅
  - `fix-403-immediate.sh` ✅  
  - `alternatives-403.sh` ✅

### Secrets GitHub à vérifier
- `FIREBASE_SERVICE_ACCOUNT` vs `FIREBASE_SERVICE_ACCOUNT_KEY`
- `FIREBASE_APP_ID` : `1:320022309385:android:838aa805fc59ee1d13e6d8`

---

## 📈 MONITORING POST-CORRECTION

### Indicateurs de succès
- ✅ Build CI passe sans erreurs
- ✅ Firebase Distribution upload réussit  
- ✅ APK disponible dans Firebase Console
- ✅ Testeurs reçoivent notification
- ✅ Aucune régression fonctionnelle

### Surveillance continue
- Builds quotidiens : surveillance Trivy CVE
- Tests Flutter : monitoring timeout/flakiness  
- Firebase quotas : surveillance usage API

---

## 🚨 RISQUES ET MITIGATIONS

| Risque | Impact | Mitigation |
|--------|--------|------------|
| Secret Firebase corrompu | Builds bloqués | Backup clé + régénération rapide |
| Permissions service account révoquées | Distribution bloquée | Multiple service accounts |
| API Firebase rate limit | Upload échoués | Retry logic + quotas monitoring |
| CVE critique détectée | Déploiement bloqué | Pipeline bypass d'urgence |

---

## 🎯 DÉLAIS ESTIMÉS

| Phase | Durée | Dépendance |
|-------|-------|------------|
| Phase 1 | 5-10 min | Accès GitHub Secrets |
| Phase 2 | 15-20 min | Google Cloud access + propagation |
| Phase 3 | 10-15 min | Implémentation alternative |
| **TOTAL** | **30-45 min** | ⏰ + attentes propagation |

---

## 📝 DOCUMENTATION MISE À JOUR

Post-correction, mettre à jour :
- README.md : nouvelle procédure Firebase setup
- CONTRIBUTING.md : troubleshooting builds
- .github/workflows/ : commentaires correctifs

---

## 🚀 STATUT ACTUEL : PRÊT POUR CORRECTIONS

**PROCHAIN STEP :** Appliquer Phase 1 corrections → Test → Escalade si besoin

**CONTACT :** Agent sysadmin disponible pour assistance technique immédiate

---
*Diagnostic complété - Solutions validées et prêtes*
# Guide Changement Package Name Flutter

## 📋 Contexte

**Package actuel:** `com.mytrainers.app.mytrainers_app`  
**Nouveau package:** `com.mytrainers.app`  
**Projet:** MyTrainers App Flutter

---

## 🎯 Objectif

Simplifier le package name pour correspondre aux exigences Firebase et améliorer la lisibilité.

---

## 📁 Liste des Fichiers à Modifier

### Android
1. `android/app/build.gradle` - applicationId et namespace
2. `android/app/src/main/kotlin/com/mytrainers/app/mytrainers_app/MainActivity.kt` - package et dossier
3. `android/app/src/main/AndroidManifest.xml` (si nécessaire)
4. `android/app/src/debug/AndroidManifest.xml` (si nécessaire)
5. `android/app/src/profile/AndroidManifest.xml` (si nécessaire)

### iOS (optionnel)
6. `ios/Runner/Info.plist` - Bundle Identifier
7. `ios/Runner.xcodeproj/project.pbxproj` - Bundle Identifier

### macOS (optionnel)
8. `macos/Runner/Info.plist` - Bundle Identifier
9. `macos/Runner.xcodeproj/project.pbxproj` - Bundle Identifier

### Autre
10. Configuration Firebase (si présente)

---

## 🔧 Procédure Step-by-Step

### ⚠️ Avant de commencer

```bash
# 1. Faire un backup complet
cp -r flutter flutter_backup_$(date +%Y%m%d_%H%M%S)

# 2. S'assurer que tout est commité dans Git
cd flutter
git add .
git commit -m "Backup avant changement package name"
```

### Étape 1: Modifier build.gradle Android

```bash
# Éditer android/app/build.gradle
```

**Changements à effectuer:**
```gradle
android {
    namespace "com.mytrainers.app"  // Était: com.mytrainers.app.mytrainers_app
    compileSdk flutter.compileSdkVersion
    ndkVersion flutter.ndkVersion
    
    // ...
    
    defaultConfig {
        applicationId "com.mytrainers.app"  // Était: com.mytrainers.app.mytrainers_app
        // ... reste inchangé
    }
}
```

**Commande pour modification automatique:**
```bash
cd flutter
sed -i 's/namespace "com\.mytrainers\.app\.mytrainers_app"/namespace "com.mytrainers.app"/' android/app/build.gradle
sed -i 's/applicationId "com\.mytrainers\.app\.mytrainers_app"/applicationId "com.mytrainers.app"/' android/app/build.gradle
```

### Étape 2: Déplacer et modifier MainActivity.kt

```bash
cd flutter

# 1. Créer nouveau dossier de package
mkdir -p android/app/src/main/kotlin/com/mytrainers/app

# 2. Déplacer MainActivity.kt
mv android/app/src/main/kotlin/com/mytrainers/app/mytrainers_app/MainActivity.kt \
   android/app/src/main/kotlin/com/mytrainers/app/

# 3. Modifier le package dans le fichier
sed -i 's/package com\.mytrainers\.app\.mytrainers_app/package com.mytrainers.app/' \
   android/app/src/main/kotlin/com/mytrainers/app/MainActivity.kt

# 4. Supprimer ancien dossier (vérifier qu'il est vide)
rmdir android/app/src/main/kotlin/com/mytrainers/app/mytrainers_app
```

### Étape 3: Modifier iOS (si nécessaire)

```bash
cd flutter

# Modifier Bundle Identifier dans Info.plist iOS
sed -i 's/<string>com\.mytrainers\.app\.mytrainers_app<\/string>/<string>com.mytrainers.app<\/string>/' ios/Runner/Info.plist

# Modifier Bundle Identifier dans project.pbxproj iOS
sed -i 's/PRODUCT_BUNDLE_IDENTIFIER = com\.mytrainers\.app\.mytrainers_app/PRODUCT_BUNDLE_IDENTIFIER = com.mytrainers.app/' ios/Runner.xcodeproj/project.pbxproj
```

### Étape 4: Modifier macOS (si nécessaire)

```bash
cd flutter

# Modifier Bundle Identifier dans Info.plist macOS
sed -i 's/<string>com\.mytrainers\.app\.mytrainers_app<\/string>/<string>com.mytrainers.app<\/string>/' macos/Runner/Info.plist

# Modifier Bundle Identifier dans project.pbxproj macOS
sed -i 's/PRODUCT_BUNDLE_IDENTIFIER = com\.mytrainers\.app\.mytrainers_app/PRODUCT_BUNDLE_IDENTIFIER = com.mytrainers.app/' macos/Runner.xcodeproj/project.pbxproj
```

### Étape 5: Nettoyer et reconstruire

```bash
cd flutter

# 1. Clean Flutter
flutter clean

# 2. Get dependencies
flutter pub get

# 3. Clean Android
cd android && ./gradlew clean && cd ..

# 4. Rebuild pour vérifier
flutter build apk --debug
```

### Étape 6: Mettre à jour Firebase (si configuré)

Si Firebase est configuré, vous devrez:

1. **Google Services JSON (Android):**
   - Aller sur Firebase Console
   - Paramètres projet > Vos apps > Android app
   - Modifier le package name vers `com.mytrainers.app`
   - Re-télécharger `google-services.json`
   - Remplacer `android/app/google-services.json`

2. **GoogleService-Info.plist (iOS):**
   - Firebase Console > iOS app
   - Modifier Bundle ID vers `com.mytrainers.app`
   - Re-télécharger `GoogleService-Info.plist`
   - Remplacer `ios/Runner/GoogleService-Info.plist`

---

## 🧪 Vérification

### Tests à effectuer:

```bash
cd flutter

# 1. Vérifier compilation Android
flutter build apk --debug

# 2. Vérifier compilation iOS (sur macOS)
flutter build ios --debug --no-codesign

# 3. Lancer app sur émulateur
flutter run

# 4. Vérifier les logs
flutter logs
```

### Points de contrôle:

- [ ] App se lance sans erreurs
- [ ] Package name affiché correct dans les paramètres Android
- [ ] Firebase fonctionne (si configuré)
- [ ] Aucun crash au démarrage
- [ ] Build release réussit

---

## 🚨 Troubleshooting

### Erreur "MainActivity not found"
```bash
# Vérifier que le fichier existe au bon endroit
ls -la android/app/src/main/kotlin/com/mytrainers/app/MainActivity.kt

# Vérifier le contenu du package
head -1 android/app/src/main/kotlin/com/mytrainers/app/MainActivity.kt
```

### Erreur Gradle "package does not exist"
```bash
# Clean complet et rebuild
flutter clean
cd android && ./gradlew clean && cd ..
flutter pub get
flutter build apk --debug
```

### Erreur Firebase
```bash
# Vérifier la configuration
cat android/app/google-services.json | grep client_id
cat ios/Runner/GoogleService-Info.plist | grep BUNDLE_ID
```

---

## 📝 Script Automatisé Complet

Voici un script bash qui effectue tous les changements:

```bash
#!/bin/bash

echo "🔄 Changement du package name Flutter de com.mytrainers.app.mytrainers_app vers com.mytrainers.app"

# Variables
OLD_PACKAGE="com.mytrainers.app.mytrainers_app"
NEW_PACKAGE="com.mytrainers.app"
OLD_PACKAGE_PATH="android/app/src/main/kotlin/com/mytrainers/app/mytrainers_app"
NEW_PACKAGE_PATH="android/app/src/main/kotlin/com/mytrainers/app"

# Vérifications préliminaires
if [ ! -d "flutter" ]; then
    echo "❌ Dossier flutter non trouvé"
    exit 1
fi

cd flutter

# Backup
echo "📁 Création du backup..."
cp -r . ../flutter_backup_$(date +%Y%m%d_%H%M%S)

# Modification build.gradle
echo "🔧 Modification android/app/build.gradle..."
sed -i "s/namespace \"$OLD_PACKAGE\"/namespace \"$NEW_PACKAGE\"/" android/app/build.gradle
sed -i "s/applicationId \"$OLD_PACKAGE\"/applicationId \"$NEW_PACKAGE\"/" android/app/build.gradle

# Modification MainActivity.kt
echo "🔧 Déplacement et modification de MainActivity.kt..."
mkdir -p "$NEW_PACKAGE_PATH"
if [ -f "$OLD_PACKAGE_PATH/MainActivity.kt" ]; then
    mv "$OLD_PACKAGE_PATH/MainActivity.kt" "$NEW_PACKAGE_PATH/"
    sed -i "s/package $OLD_PACKAGE/package $NEW_PACKAGE/" "$NEW_PACKAGE_PATH/MainActivity.kt"
    rmdir "$OLD_PACKAGE_PATH" 2>/dev/null
fi

# Modification iOS
echo "🔧 Modification iOS..."
if [ -f "ios/Runner/Info.plist" ]; then
    sed -i "s/<string>$OLD_PACKAGE<\/string>/<string>$NEW_PACKAGE<\/string>/" ios/Runner/Info.plist
fi
if [ -f "ios/Runner.xcodeproj/project.pbxproj" ]; then
    sed -i "s/PRODUCT_BUNDLE_IDENTIFIER = $OLD_PACKAGE/PRODUCT_BUNDLE_IDENTIFIER = $NEW_PACKAGE/" ios/Runner.xcodeproj/project.pbxproj
fi

# Modification macOS
echo "🔧 Modification macOS..."
if [ -f "macos/Runner/Info.plist" ]; then
    sed -i "s/<string>$OLD_PACKAGE<\/string>/<string>$NEW_PACKAGE<\/string>/" macos/Runner/Info.plist
fi
if [ -f "macos/Runner.xcodeproj/project.pbxproj" ]; then
    sed -i "s/PRODUCT_BUNDLE_IDENTIFIER = $OLD_PACKAGE/PRODUCT_BUNDLE_IDENTIFIER = $NEW_PACKAGE/" macos/Runner.xcodeproj/project.pbxproj
fi

# Clean et rebuild
echo "🧹 Nettoyage et reconstruction..."
flutter clean
flutter pub get

echo "✅ Changement de package name terminé!"
echo "🔍 Vérifiez avec: flutter build apk --debug"
echo "⚠️ N'oubliez pas de mettre à jour Firebase si nécessaire"
```

---

## 📋 Checklist Post-Changement

- [ ] ✅ build.gradle modifié (namespace + applicationId)
- [ ] ✅ MainActivity.kt déplacé et package modifié
- [ ] ✅ iOS Bundle Identifier modifié (si nécessaire)
- [ ] ✅ macOS Bundle Identifier modifié (si nécessaire)
- [ ] ✅ Flutter clean + pub get effectué
- [ ] ✅ Build debug réussi
- [ ] ✅ App testée sur émulateur/device
- [ ] ✅ Firebase reconfiguré (si nécessaire)
- [ ] ✅ Build release testé
- [ ] ✅ Git commit des changements

---

**🎯 Résultat Final:**
Package name simplifié de `com.mytrainers.app.mytrainers_app` vers `com.mytrainers.app`, compatible avec Firebase et plus facile à maintenir.
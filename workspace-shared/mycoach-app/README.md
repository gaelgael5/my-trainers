# 📱 MyCoach Flutter MVP

Application mobile Flutter pour la plateforme MyCoach avec dual theme Coach/Client et composants glassmorphism.

## 🚀 Quick Start

```bash
# Installation des dépendances
flutter pub get

# Build APK debug
flutter build apk --debug

# Lancement sur device
flutter run
```

## 📱 Features

### ✅ Implémentées
- **Dual Theme** : Dark (Coach) / Light (Client)
- **Onboarding** : Sélection de rôle
- **Authentification** : Login / Register
- **Dashboards** : Coach et Client avec données mock
- **Navigation** : Adaptée au rôle utilisateur
- **Glassmorphism** : Composants avec transparence et blur
- **API Integration** : Client HTTP Dio configuré

### 🔄 En développement
- Chat temps réel
- Recherche de coachs
- Réservations
- Profils détaillés

## 🏗️ Architecture

```
lib/
├── core/                    # Configuration et services
│   ├── config/             # Variables app et API
│   ├── network/            # Client HTTP
│   ├── storage/            # Stockage local
│   ├── navigation/         # Router GoRouter
│   └── theme/              # Themes et couleurs
├── features/               # Fonctionnalités
│   ├── auth/              # Authentification
│   ├── dashboard/         # Dashboards Coach/Client
│   ├── navigation/        # Navigation principale
│   └── onboarding/        # Sélection de rôle
└── shared/                # Code partagé
    ├── models/            # Modèles de données
    └── widgets/           # Widgets réutilisables
```

## 🎨 Design System

### Couleurs Coach (Dark Theme)
- **Primary** : `#0A0E1A` (Fond sombre)
- **Secondary** : `#8B5CF6` (Violet)
- **Accent** : `#A855F7` (Violet clair)
- **Surface** : `#1E293B` (Surfaces)

### Couleurs Client (Light Theme)
- **Primary** : `#F0F4FF` (Fond clair)
- **Secondary** : `#06B6D4` (Cyan)
- **Accent** : `#0891B2` (Cyan foncé)
- **Surface** : `#FFFFFF` (Blanc)

### Composants Glassmorphism
```dart
GlassContainer(
  blur: 10.0,
  opacity: 0.2,
  child: YourWidget(),
)
```

## 🔌 API Backend

### Configuration
```dart
// lib/core/config/app_config.dart
static const String _devApiBaseUrl = 'http://10.0.2.2:8000/api';
```

### Endpoints disponibles
- `POST /auth/login` - Connexion
- `POST /auth/register` - Inscription
- `GET /auth/me` - Utilisateur courant
- `GET /coach/dashboard` - Dashboard coach
- `GET /client/dashboard` - Dashboard client

## 📋 Build Instructions

Voir [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md) pour les instructions complètes.

### Prérequis
- Flutter SDK 3.19+
- Android Studio + Android SDK
- Device Android ou émulateur

### Commands essentielles
```bash
flutter doctor          # Vérifier l'installation
flutter pub get         # Installer les dépendances
flutter analyze         # Analyser le code
flutter build apk       # Build APK
```

## 🧪 Tests

```bash
# Analyse statique
flutter analyze

# Tests unitaires (à implémenter)
flutter test

# Lancement avec hot reload
flutter run --debug
```

## 📦 Dépendances principales

- **flutter_bloc** : Gestion d'état
- **go_router** : Navigation
- **dio** : Client HTTP
- **shared_preferences** : Stockage local
- **google_fonts** : Typography (Inter)
- **injectable** : Injection de dépendances

## 🔧 Configuration

### Themes auto-switch
Le thème s'adapte automatiquement selon le rôle :
- Coach → Dark theme (Violet)
- Client → Light theme (Cyan)

### Backend API
Configurer l'URL dans `lib/core/config/app_config.dart` :
- Dev : `http://localhost:8000/api` (ou IP locale)
- Prod : URL de production

## 🚨 Troubleshooting

### "Flutter command not found"
```bash
export PATH="$PATH:/path/to/flutter/bin"
```

### "Android licenses not accepted"
```bash
flutter doctor --android-licenses
```

### API Connection refused
- Émulateur : utiliser `10.0.2.2` au lieu de `localhost`
- Device physique : utiliser l'IP du PC

## 🎯 MVP Roadmap

### Phase 1 (Actuelle) ✅
- [x] Structure de base
- [x] Dual themes
- [x] Onboarding et auth
- [x] Dashboards MVP
- [x] Navigation
- [x] API integration

### Phase 2 (Prochaine)
- [ ] Chat temps réel
- [ ] Recherche et filtres
- [ ] Réservations
- [ ] Notifications push
- [ ] Tests automatisés

### Phase 3 (Future)
- [ ] CI/CD Pipeline
- [ ] App Store deployment
- [ ] Analytics et monitoring
- [ ] Performance optimizations

## 🤝 Contributing

1. Suivre l'architecture par features
2. Utiliser les conventions de nommage Flutter
3. Tester sur émulateur ET device physique
4. Respecter les règles ESLint/Flutter Analyzer

## 📄 License

MyCoach Flutter MVP - Propriétaire

---

**Développé avec ❤️ en Flutter**
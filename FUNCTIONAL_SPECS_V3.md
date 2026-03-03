# MyCoach — Cahier des charges fonctionnel v1.0

> Application mobile de coaching sportif personnalisé.  
> Deux espaces distincts : **Coach** (interface sombre/tech) et **Client** (interface claire/dynamique).

---

## 🎯 Vision produit

MyCoach connecte des coachs sportifs indépendants avec leurs clients. L'application couvre l'ensemble du cycle de coaching : découverte, planification, entraînement, suivi des performances, paiement — avec une expérience mobile-first, haute technologie, et des fonctionnalités IA.

---

## 🎨 Design System

### Principes
- **High-tech** : UI sombre, effets glassmorphism, accents néon, typographie moderne (ex: Space Grotesk)
- **Deux identités visuelles distinctes** :

| | Espace Coach | Espace Client |
|--|--------------|---------------|
| Fond | `#0A0E1A` (noir profond) | `#F0F4FF` (blanc bleuté) |
| Accent | `#7B2FFF` (violet électrique) | `#00C2FF` (cyan dynamique) |
| Secondaire | `#FF6B2F` (orange énergie) | `#FF6B2F` (orange énergie) |
| Ambiance | Dashboard pro, analytics | App fitness moderne |

## 🌍 Internationalisation (i18n)

### Locales supportées (Phase 1)
| Code | Langue | Devise | Unité poids |
|------|--------|--------|-------------|
| `fr-FR` | Français (France) | EUR € | kg |
| `fr-BE` | Français (Belgique) | EUR € | kg |
| `fr-CH` | Français (Suisse) | CHF | kg |
| `en-US` | English (US) | USD $ | lb |
| `en-GB` | English (UK) | GBP £ | kg |
| `es-ES` | Español (España) | EUR € | kg |
| `pt-BR` | Português (Brasil) | BRL R$ | kg |
| `de-DE` | Deutsch | EUR € | kg |

## 🏋️ Salles de sport intégrées

| Chaîne | Pays | Clubs |
|--------|------|-------|
| Fitness Park | 🇫🇷 France, 🇬🇵 Guadeloupe, 🇲🇶 Martinique | ~400 |
| Basic-Fit | 🇫🇷 🇧🇪 🇳🇱 🇱🇺 🇩🇪 🇪🇸 🇲🇦 | ~1 200 |
| L'Orange Bleue | 🇫🇷 France | ~470 |
| Anytime Fitness | 🌍 International (50+ pays) | ~5 000 |

---

# Spécifications Fonctionnelles

**Document de cadrage — Version consolidée V3**

## Récapitulatif des écrans

**Total estimé : environ 60 écrans et composants**

| Groupe | Écrans | Estimation |
|--------|--------|------------|
| Onboarding | Connexion, Inscription, Type de profil, Profil, Questionnaire, Salle fréquentée | 6 écrans |
| Principal | Dashboard, Planning, Performances, Contacts, Messagerie | 5 écrans |
| Performance | Nouvelle perf (Course / Machine / Libre / Autre), Historique, Détail, Source connectée | 6 écrans |
| Planning | Calendrier, Recherche coach, Fiche coach, Réservation, Tunnel découverte | 5 écrans |
| Programmes | Catalogue, Détail programme, Suivi programme(s) en cours | 3 écrans |
| Séances solo | Génération programme, Mode guidé (écran par écran), Minuterie | 3 écrans |
| Coach — Profil | Fiche profil enrichie, Certifications, RIB | 2 écrans |
| Coach — Tarifs | Paramétrage forfaits, Options de paiement | 2 écrans |
| Coach — Clients | Liste clients, Fiche client, Notes privées, Crédits d'heures | 4 écrans |
| Coach — Programmes | Création/édition, Bibliothèque, Assignation, Suivi avancement | 4 écrans |

*Document complet avec 60+ écrans, internationalisation, gamification, vidéos IA, etc.*
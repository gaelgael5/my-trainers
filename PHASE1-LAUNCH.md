# PHASE 1 LAUNCH - MyCoach Infrastructure & Auth

## 🚀 DÉMARRAGE PHASE 1 (8 semaines)

### Équipes mobilisées :
- **dev-python** : Backend API + Auth + Database
- **dev-flutter** : App mobile base + UI design system  
- **sysadmin** : Infrastructure cloud + CI/CD

### Tâches prioritaires SEMAINE 1-2 :

#### dev-python (Backend)
- [ ] Architecture FastAPI + SQLAlchemy 
- [ ] Auth JWT (Coach vs Client profiles)
- [ ] Database schema (Users, Profiles, Gyms)
- [ ] APIs auth endpoints (/login, /register, /profile)

#### dev-flutter (Mobile)
- [ ] Architecture Flutter Clean + BLoC
- [ ] Design System (dark/light themes)
- [ ] Onboarding flow (coach vs client selection)
- [ ] Auth screens (login, register, profile setup)

#### sysadmin (Infrastructure)  
- [ ] Docker containers setup
- [ ] Database PostgreSQL setup
- [ ] CI/CD pipeline GitHub Actions
- [ ] Environment staging

### Objectif Semaine 2 :
**DEMO** : Auth complete + profils de base + app mobile connectée

### Livrables confirmés :
- Backend API fonctionnel (auth + profils)
- App Flutter installable avec onboarding
- Infrastructure déployable

## 🔗 CHAÎNAGE AUTOMATIQUE POST-PHASE 1 :

### Quand les 3 agents terminent → LANCER IMMÉDIATEMENT :

#### 1. **GitHub Builds Setup** (sysadmin)
- [ ] CI/CD Backend : GitHub Actions + tests + build Docker
- [ ] CI/CD Frontend : GitHub Actions + Flutter build + APK/IPA
- [ ] Integration tests pipeline
- [ ] Deploy automatique staging

#### 2. **Tests QA Strategy** (tester-flutter-qa) 
- [ ] Setup tests BDD/Gherkin pour auth flow
- [ ] Tests regression automatisés  
- [ ] Tests a11y + performance mobile
- [ ] Strategy QA continue (sprint/release)

**RÈGLE :** Dès que dev-python + dev-flutter + sysadmin passent à ✅ TERMINÉ 
→ Orchestrator lance automatiquement sysadmin (builds) + tester-flutter-qa (QA)

## Status : PHASE 1 LANCÉE - 06:30 (3 mars 2026)
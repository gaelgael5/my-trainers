# MyCoach - Stratégie de Branches Git

## 🌳 Structure des Branches

```
main (production) 
 ↳ uat (staging/testing)
    ↳ dev (développement)
```

## 📋 Rôles des Branches

### `main` - Production
- **Code stable en production**
- Protégée contre les push directs
- Mise à jour uniquement via merge depuis `uat`
- Tags de version (v1.0.0, v1.1.0...)

### `uat` - User Acceptance Testing
- **Code prêt pour tests utilisateurs**
- Environnement de staging/pré-production  
- Merge depuis `dev` quand features terminées
- Tests finaux avant production

### `dev` - Développement
- **Branche de travail principale**
- **TOUS LES AGENTS TRAVAILLENT ICI**
- Code en développement actif
- Feature branches mergées ici

## 🚀 Workflow de Développement

1. **Agents dev** → Travaillent sur branche `dev`
2. **Features terminées** → `dev` reste à jour
3. **Phase terminée** → Merge `dev` → `uat` 
4. **Tests validés** → Merge `uat` → `main`
5. **Tag release** → Version déployée

## ⚡ Règles pour les Agents

- ✅ **TOUJOURS** travailler sur branche `dev`
- ✅ **COMMIT** réguliers avec messages clairs
- ✅ **PUSH** vers `origin dev` après chaque livrable
- ❌ **JAMAIS** push direct sur `uat` ou `main`

## 📊 Status Actuel

- `main`: ✅ Structure projet de base
- `uat`: ✅ Identique à main (prêt pour staging)  
- `dev`: ✅ Branche active (développement en cours)

**🎯 AGENTS → Utilisez branche `dev` pour tous les développements !**
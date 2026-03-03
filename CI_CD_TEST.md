# Test Pipeline CI/CD MyCoach

Test timestamp: 2026-03-03 08:35 GMT+1

## Objectif
Tester le pipeline complet :
- ✅ Backend Docker build (tag: dev{build_id})
- ✅ Frontend Flutter APK build
- ✅ Firebase App Distribution
- ✅ Firebase Hosting deploy

## Configuration
- Firebase Project: my-trainers-e7c26
- GitHub Secrets: FIREBASE_TOKEN, FIREBASE_PROJECT_ID, FIREBASE_APP_ID
- Docker Registry: GitHub Container Registry

## Expected Results
1. GitHub Action triggered
2. Docker image built and tagged
3. Flutter APK built and uploaded to Firebase App Distribution
4. Web app deployed to my-trainers-e7c26.web.app
5. Testers receive notification emails

Let's go! 🚀
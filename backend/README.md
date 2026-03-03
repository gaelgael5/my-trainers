# MyCoach Backend API

FastAPI backend pour l'application MyCoach.

## Structure

```
backend/
├── app/
│   ├── models/      # Modèles Pydantic
│   ├── routes/      # Routes API
│   ├── services/    # Services métier
│   └── auth/        # Authentification JWT
├── tests/           # Tests unitaires
├── requirements.txt
├── Dockerfile
└── docker-compose.yml
```

## Installation

```bash
pip install -r requirements.txt
uvicorn app.main:app --reload
```

## Tests

```bash
pytest tests/
```
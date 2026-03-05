import os
import uuid

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Définir l'environnement de test AVANT d'importer l'app
os.environ["TESTING"] = "true"

# Configuration de test avec SQLite en mémoire
SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"
engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


# Override de la dépendance de base de données pour les tests
def override_get_db():
    try:
        db = TestingSessionLocal()
        yield db
    finally:
        db.close()


from app.database import Base, get_db
# Import APRÈS configuration de test
from app.main import app

# Appliquer l'override ET créer les tables
app.dependency_overrides[get_db] = override_get_db
Base.metadata.create_all(bind=engine)

client = TestClient(app)


def generate_unique_email(prefix="test"):
    """Génère un email unique pour éviter les conflits"""
    unique_id = str(uuid.uuid4())[:8]
    return f"{prefix}_{unique_id}@example.com"


def test_health_check():
    """Test du endpoint de santé"""
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


def test_api_v1_health():
    """Test du endpoint de santé API v1"""
    response = client.get("/api/v1/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


def test_register_user():
    """Test d'inscription d'un utilisateur client"""
    user_data = {
        "email": generate_unique_email("client"),
        "password": "testpassword123",
        "user_type": "CLIENT",
        "first_name": "Test",
        "last_name": "User",
        "phone": "+33123456789",
    }
    response = client.post("/api/v1/register", json=user_data)
    assert response.status_code == 201
    data = response.json()
    assert data["email"] == user_data["email"]
    assert data["user_type"] == "CLIENT"
    assert "id" in data
    # Vérifier que le profil est créé
    assert data["profile"] is not None
    assert data["profile"]["first_name"] == "Test"
    assert data["profile"]["last_name"] == "User"


def test_register_coach():
    """Test d'inscription d'un coach"""
    coach_data = {
        "email": generate_unique_email("coach"),
        "password": "coachpass123",
        "user_type": "COACH",
        "first_name": "Coach",
        "last_name": "Expert",
    }
    response = client.post("/api/v1/register", json=coach_data)
    assert response.status_code == 201
    data = response.json()
    assert data["user_type"] == "COACH"
    assert data["profile"]["first_name"] == "Coach"


def test_register_duplicate_email():
    """Test d'inscription avec un email déjà existant"""
    email = generate_unique_email("duplicate")
    user_data = {
        "email": email,
        "password": "testpassword123",
        "user_type": "CLIENT",
        "first_name": "First",
        "last_name": "User",
    }
    # Premier utilisateur
    response1 = client.post("/api/v1/register", json=user_data)
    assert response1.status_code == 201

    # Deuxième avec le même email - doit échouer
    response2 = client.post("/api/v1/register", json=user_data)
    assert response2.status_code == 400
    assert "already registered" in response2.json()["detail"].lower()


def test_login():
    """Test de connexion"""
    # D'abord créer un utilisateur
    email = generate_unique_email("login")
    user_data = {
        "email": email,
        "password": "loginpass123",
        "user_type": "CLIENT",
        "first_name": "Login",
        "last_name": "Test",
    }
    register_response = client.post("/api/v1/register", json=user_data)
    assert register_response.status_code == 201

    # Maintenant se connecter
    login_data = {"username": email, "password": "loginpass123"}
    response = client.post("/api/v1/login", data=login_data)
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert data["token_type"] == "bearer"


def test_login_wrong_password():
    """Test de connexion avec mauvais mot de passe"""
    login_data = {"username": "nonexistent@example.com", "password": "wrongpassword"}
    response = client.post("/api/v1/login", data=login_data)
    assert response.status_code == 401


def test_get_profile():
    """Test de récupération du profil utilisateur"""
    # Créer et connecter un utilisateur
    email = generate_unique_email("profile")
    user_data = {
        "email": email,
        "password": "profilepass123",
        "user_type": "COACH",
        "first_name": "Profile",
        "last_name": "Test",
    }
    register_response = client.post("/api/v1/register", json=user_data)
    assert register_response.status_code == 201

    # Se connecter
    login_response = client.post(
        "/api/v1/login",
        data={"username": email, "password": "profilepass123"},
    )
    token = login_response.json()["access_token"]

    # Récupérer le profil
    headers = {"Authorization": f"Bearer {token}"}
    response = client.get("/api/v1/profile", headers=headers)
    assert response.status_code == 200
    data = response.json()
    assert data["email"] == email
    assert data["user_type"] == "COACH"


def test_update_profile():
    """Test de mise à jour du profil"""
    # Créer et connecter un utilisateur
    email = generate_unique_email("update")
    user_data = {
        "email": email,
        "password": "updatepass123",
        "user_type": "COACH",
        "first_name": "Update",
        "last_name": "Test",
    }
    register_response = client.post("/api/v1/register", json=user_data)
    assert register_response.status_code == 201

    # Se connecter
    login_response = client.post(
        "/api/v1/login",
        data={"username": email, "password": "updatepass123"},
    )
    token = login_response.json()["access_token"]

    # Mettre à jour le profil
    headers = {"Authorization": f"Bearer {token}"}
    update_data = {
        "bio": "Coach sportif expérimenté",
        "city": "Paris",
        "experience_years": 5,
    }
    response = client.put("/api/v1/profile", json=update_data, headers=headers)
    assert response.status_code == 200
    data = response.json()
    assert data["bio"] == "Coach sportif expérimenté"
    assert data["city"] == "Paris"
    assert data["experience_years"] == 5


def test_unauthorized_profile():
    """Test de récupération de profil sans token"""
    response = client.get("/api/v1/profile")
    assert response.status_code == 401


def test_gyms_endpoints():
    """Test des endpoints de salles de sport"""
    # Test liste des salles (peut être vide)
    response = client.get("/api/v1/gyms")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

    # Test recherche par ville
    response = client.get("/api/v1/gyms/search/Paris")
    assert response.status_code == 200
    assert isinstance(response.json(), list)


# Nettoyage après les tests
def cleanup():
    if os.path.exists("./test.db"):
        os.remove("./test.db")


if __name__ == "__main__":
    pytest.main([__file__, "-v", "-s"])
    cleanup()
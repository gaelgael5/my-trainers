"""Tests simples sans dépendance DB pour validation CI/CD"""

import os

from fastapi.testclient import TestClient

# On définit une variable d'environnement pour indiquer qu'on est en test
os.environ["TESTING"] = "1"

from app.main import app

client = TestClient(app)


def test_read_root():
    """Test the root endpoint."""
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert "message" in data
    assert "MyCoach API v1.0.0" in data["message"]


def test_health_check():
    """Test the health check endpoint."""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert data["service"] == "MyCoach API"
    assert data["version"] == "1.0.0"


def test_docs_endpoint():
    """Test that docs endpoint is accessible."""
    response = client.get("/docs")
    # Should return HTML content for Swagger UI
    assert response.status_code == 200
    assert "text/html" in response.headers.get("content-type", "")


def test_redoc_endpoint():
    """Test that redoc endpoint is accessible."""
    response = client.get("/redoc")
    # Should return HTML content for ReDoc UI
    assert response.status_code == 200
    assert "text/html" in response.headers.get("content-type", "")


def test_app_creation():
    """Test que l'application FastAPI se lance correctement"""
    assert app.title == "MyCoach API"
    assert app.version == "1.0.0"
    assert "MyCoach - Phase 1" in app.description

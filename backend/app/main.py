import os

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# Import conditionnel pour éviter les erreurs si les modules n'existent pas encore
try:
    from .routes import router

    has_routes = True
except ImportError:
    has_routes = False

app = FastAPI(
    title="MyCoach API",
    description="API pour l'application de coaching sportif MyCoach - Phase 1",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

# Configuration CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # À restreindre en production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
async def startup_event():
    """Initialise la base de données au démarrage si pas en test"""
    if not os.getenv("TESTING"):
        try:
            from .database import Base, engine

            Base.metadata.create_all(bind=engine)
        except ImportError:
            # Database modules pas encore disponibles
            pass


# Inclusion des routes si disponibles
if has_routes:
    app.include_router(router, prefix="/api/v1")


@app.get("/")
async def root():
    return {
        "message": "MyCoach API v1.0.0 - Phase 1",
        "status": "Backend MVP fonctionnel",
        "features": [
            "Auth JWT (Coach/Client profiles)",
            "User registration & login",
            "Profile management",
            "Database SQLAlchemy + PostgreSQL",
            "FastAPI + Swagger docs",
        ],
        "endpoints": {
            "docs": "/docs",
            "health": "/api/v1/health",
            "register": "/api/v1/register",
            "login": "/api/v1/login",
            "profile": "/api/v1/profile",
        },
    }


@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "MyCoach API", "version": "1.0.0"}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000, reload=True)

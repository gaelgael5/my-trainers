from datetime import timedelta

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.orm import Session

from . import auth, models, schemas, services
from .database import get_db

router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


# Middleware pour récupérer l'utilisateur courant
async def get_current_user(
    token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)
):
    """Récupère l'utilisateur courant depuis le token JWT"""
    payload = auth.verify_token(token)
    email = payload.get("sub")
    user = services.UserService.get_user_by_email(db, email)
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return user


# Routes d'authentification
@router.post(
    "/register", response_model=schemas.User, status_code=status.HTTP_201_CREATED
)
async def register(user_data: schemas.UserRegister, db: Session = Depends(get_db)):
    """Inscription d'un nouvel utilisateur"""
    try:
        db_user = services.UserService.create_user(db, user_data)
        return db_user
    except HTTPException:
        # Re-lever les HTTPException sans modification
        raise
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))


@router.post("/login", response_model=schemas.Token)
async def login(
    form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)
):
    """Connexion utilisateur - retourne un token JWT"""
    user = services.UserService.authenticate_user(
        db, form_data.username, form_data.password
    )
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    access_token_expires = timedelta(minutes=auth.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = auth.create_access_token(
        data={"sub": user.email, "user_type": user.user_type.value},
        expires_delta=access_token_expires,
    )
    return {"access_token": access_token, "token_type": "bearer"}


@router.post("/token", response_model=schemas.Token)
async def login_for_access_token(
    form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)
):
    """Endpoint OAuth2 standard pour récupérer un token"""
    return await login(form_data, db)


# Routes de profil
@router.get("/profile", response_model=schemas.User)
async def get_my_profile(
    current_user: models.User = Depends(get_current_user), db: Session = Depends(get_db)
):
    """Récupère le profil de l'utilisateur courant"""
    return current_user


@router.put("/profile", response_model=schemas.Profile)
async def update_my_profile(
    profile_data: schemas.ProfileUpdate,
    current_user: models.User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Met à jour le profil de l'utilisateur courant"""
    updated_profile = services.ProfileService.update_profile(
        db, current_user.id, profile_data
    )
    return updated_profile


# Routes utilisateurs (pour les coachs qui veulent voir des profils clients, etc.)
@router.get("/users/me", response_model=schemas.User)
async def get_current_user_info(current_user: models.User = Depends(get_current_user)):
    """Récupère les informations de l'utilisateur courant"""
    return current_user


# Routes des salles de sport
@router.get("/gyms", response_model=list[schemas.Gym])
async def get_gyms(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    """Récupère la liste des salles de sport"""
    gyms = services.GymService.get_gyms(db, skip=skip, limit=limit)
    return gyms


@router.get("/gyms/{gym_id}", response_model=schemas.Gym)
async def get_gym(gym_id: int, db: Session = Depends(get_db)):
    """Récupère une salle de sport par ID"""
    gym = services.GymService.get_gym_by_id(db, gym_id)
    if gym is None:
        raise HTTPException(status_code=404, detail="Gym not found")
    return gym


@router.get("/gyms/search/{city}", response_model=list[schemas.Gym])
async def search_gyms_by_city(city: str, db: Session = Depends(get_db)):
    """Recherche des salles de sport par ville"""
    gyms = services.GymService.search_gyms_by_city(db, city)
    return gyms


# Route de santé
@router.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "service": "MyCoach API", "version": "1.0.0"}

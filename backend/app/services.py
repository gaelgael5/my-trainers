from typing import Optional

from fastapi import HTTPException, status
from sqlalchemy import and_
from sqlalchemy.orm import Session

from . import auth, models, schemas


class UserService:
    @staticmethod
    def create_user(db: Session, user_data: schemas.UserRegister) -> models.User:
        """Crée un nouveau utilisateur avec son profil"""

        # Vérifier si l'email existe déjà
        db_user = UserService.get_user_by_email(db, user_data.email)
        if db_user:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered",
            )

        # Créer l'utilisateur
        hashed_password = auth.get_password_hash(user_data.password)
        db_user = models.User(
            email=user_data.email,
            hashed_password=hashed_password,
            user_type=user_data.user_type,
        )
        db.add(db_user)
        db.commit()
        db.refresh(db_user)

        # Créer le profil associé
        db_profile = models.Profile(
            user_id=db_user.id,
            first_name=user_data.first_name,
            last_name=user_data.last_name,
            phone=user_data.phone,
        )
        db.add(db_profile)
        db.commit()
        db.refresh(db_profile)

        return db_user

    @staticmethod
    def get_user_by_email(db: Session, email: str) -> Optional[models.User]:
        """Récupère un utilisateur par email"""
        return db.query(models.User).filter(models.User.email == email).first()

    @staticmethod
    def get_user_by_id(db: Session, user_id: int) -> Optional[models.User]:
        """Récupère un utilisateur par ID"""
        return db.query(models.User).filter(models.User.id == user_id).first()

    @staticmethod
    def authenticate_user(
        db: Session, email: str, password: str
    ) -> Optional[models.User]:
        """Authentifie un utilisateur"""
        user = UserService.get_user_by_email(db, email)
        if not user:
            return None
        if not auth.verify_password(password, user.hashed_password):
            return None
        return user


class ProfileService:
    @staticmethod
    def get_profile_by_user_id(db: Session, user_id: int) -> Optional[models.Profile]:
        """Récupère le profil d'un utilisateur"""
        return (
            db.query(models.Profile).filter(models.Profile.user_id == user_id).first()
        )

    @staticmethod
    def update_profile(
        db: Session, user_id: int, profile_data: schemas.ProfileUpdate
    ) -> models.Profile:
        """Met à jour le profil d'un utilisateur"""
        db_profile = ProfileService.get_profile_by_user_id(db, user_id)
        if not db_profile:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND, detail="Profile not found"
            )

        # Mise à jour des champs non-None uniquement
        for field, value in profile_data.model_dump(exclude_unset=True).items():
            setattr(db_profile, field, value)

        db.commit()
        db.refresh(db_profile)
        return db_profile


class GymService:
    @staticmethod
    def get_gyms(db: Session, skip: int = 0, limit: int = 100) -> list[models.Gym]:
        """Récupère la liste des salles de sport"""
        return db.query(models.Gym).offset(skip).limit(limit).all()

    @staticmethod
    def get_gym_by_id(db: Session, gym_id: int) -> Optional[models.Gym]:
        """Récupère une salle de sport par ID"""
        return db.query(models.Gym).filter(models.Gym.id == gym_id).first()

    @staticmethod
    def search_gyms_by_city(db: Session, city: str) -> list[models.Gym]:
        """Recherche des salles de sport par ville"""
        return db.query(models.Gym).filter(models.Gym.city.ilike(f"%{city}%")).all()

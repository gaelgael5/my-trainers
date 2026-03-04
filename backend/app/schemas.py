from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List
from datetime import datetime
from enum import Enum

class UserType(str, Enum):
    CLIENT = "CLIENT"
    COACH = "COACH"

# Schémas de base pour l'auth
class UserRegister(BaseModel):
    email: EmailStr
    password: str = Field(..., min_length=6)
    user_type: UserType
    first_name: str = Field(..., min_length=1, max_length=100)
    last_name: str = Field(..., min_length=1, max_length=100)
    phone: Optional[str] = None

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str

# Schémas pour les profils
class ProfileBase(BaseModel):
    first_name: str
    last_name: str
    phone: Optional[str] = None
    bio: Optional[str] = None
    city: Optional[str] = None
    certifications: Optional[str] = None  # Sera JSON pour les coachs
    specializations: Optional[str] = None  # Sera JSON pour les coachs
    experience_years: Optional[int] = None

class ProfileUpdate(ProfileBase):
    first_name: Optional[str] = None
    last_name: Optional[str] = None

class Profile(ProfileBase):
    id: int
    user_id: int
    avatar_url: Optional[str] = None
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True

# Schémas pour les utilisateurs
class UserBase(BaseModel):
    email: EmailStr
    user_type: UserType
    is_active: bool = True

class User(UserBase):
    id: int
    created_at: datetime
    profile: Optional[Profile] = None

    class Config:
        from_attributes = True

# Schémas pour les salles de sport
class GymBase(BaseModel):
    name: str
    address: str
    city: str
    postal_code: Optional[str] = None
    latitude: Optional[str] = None
    longitude: Optional[str] = None
    description: Optional[str] = None
    website: Optional[str] = None
    phone: Optional[str] = None

class Gym(GymBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True

# Réponses API
class MessageResponse(BaseModel):
    message: str

class ErrorResponse(BaseModel):
    error: str
    detail: Optional[str] = None

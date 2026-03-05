import enum
from datetime import datetime

from sqlalchemy import (Boolean, Column, DateTime, Enum, Float, ForeignKey,
                        Integer, String, Table, Text)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from .database import Base


class UserType(enum.Enum):
    CLIENT = "CLIENT"
    COACH = "COACH"


class SessionStatus(enum.Enum):
    SCHEDULED = "SCHEDULED"
    CONFIRMED = "CONFIRMED"
    IN_PROGRESS = "IN_PROGRESS"
    COMPLETED = "COMPLETED"
    CANCELLED = "CANCELLED"


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(255), unique=True, index=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    is_active = Column(Boolean, default=True)
    user_type = Column(Enum(UserType), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relations
    profile = relationship("Profile", back_populates="user", uselist=False)
    # Sessions en tant que client
    client_sessions = relationship(
        "Session", foreign_keys="Session.client_id", back_populates="client"
    )
    # Sessions en tant que coach
    coach_sessions = relationship(
        "Session", foreign_keys="Session.coach_id", back_populates="coach"
    )


class Profile(Base):
    __tablename__ = "profiles"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    phone = Column(String(20))
    bio = Column(Text)
    avatar_url = Column(String(500))
    city = Column(String(100))

    # Spécifique aux coachs
    certifications = Column(Text)  # JSON ou texte avec certifications
    specializations = Column(Text)  # JSON ou texte avec spécialisations
    experience_years = Column(Integer)
    hourly_rate = Column(Float)  # Prix par heure

    # Métadonnées
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relations
    user = relationship("User", back_populates="profile")


class Gym(Base):
    __tablename__ = "gyms"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(200), nullable=False)
    address = Column(String(500), nullable=False)
    city = Column(String(100), nullable=False)
    postal_code = Column(String(10))
    latitude = Column(String(20))
    longitude = Column(String(20))
    description = Column(Text)
    website = Column(String(200))
    phone = Column(String(20))

    # Métadonnées
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relations
    sessions = relationship("Session", back_populates="gym")


class Session(Base):
    __tablename__ = "sessions"

    id = Column(Integer, primary_key=True, index=True)

    # Participants
    client_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    coach_id = Column(Integer, ForeignKey("users.id"), nullable=False)

    # Lieu
    gym_id = Column(
        Integer, ForeignKey("gyms.id"), nullable=True
    )  # Peut être null pour sessions domicile

    # Planning
    scheduled_at = Column(DateTime(timezone=True), nullable=False)
    duration_minutes = Column(Integer, default=60)

    # Statut et détails
    status = Column(Enum(SessionStatus), default=SessionStatus.SCHEDULED)
    title = Column(String(200), nullable=False)
    description = Column(Text)
    price = Column(Float)  # Prix de la session

    # Notes privées du coach
    coach_notes = Column(Text)  # Visible seulement par le coach

    # Métadonnées
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relations
    client = relationship(
        "User", foreign_keys=[client_id], back_populates="client_sessions"
    )
    coach = relationship(
        "User", foreign_keys=[coach_id], back_populates="coach_sessions"
    )
    gym = relationship("Gym", back_populates="sessions")

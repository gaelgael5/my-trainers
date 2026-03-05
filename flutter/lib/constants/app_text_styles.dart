import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Styles de texte pour le design sobre v2
class AppTextStyles {
  // Titre principal "Bienvenue"
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: -0.5,
  );
  
  // Sous-titre "Connectez-vous pour continuer"
  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.lightGrey,
    letterSpacing: 0.1,
  );
  
  // Labels des champs (Email, Mot de passe)
  static const TextStyle fieldLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
    letterSpacing: 0.1,
  );
  
  // Texte dans les champs de saisie
  static const TextStyle fieldText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.inputText,
  );
  
  // Placeholder dans les champs
  static const TextStyle fieldPlaceholder = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.inputPlaceholder,
  );
  
  // Bouton principal
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.2,
  );
  
  // Liens (Mot de passe oublié, S'inscrire)
  static const TextStyle link = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryOrange,
    letterSpacing: 0.1,
  );
  
  // Texte secondaire (Pas encore de compte ?)
  static const TextStyle secondaryText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.lightGrey,
    letterSpacing: 0.1,
  );
  
  // Séparateur "OU"
  static const TextStyle divider = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.lightGrey,
    letterSpacing: 0.5,
  );
  
  // Styles additionnels pour les nouveaux écrans
  
  // Titre d'écran
  static const TextStyle heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: -0.3,
  );
  
  // Titre principal
  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: -0.5,
  );
  
  // Texte de contenu
  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    letterSpacing: 0.1,
  );
  
  // Petit texte / légende
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.lightGrey,
    letterSpacing: 0.1,
  );
}
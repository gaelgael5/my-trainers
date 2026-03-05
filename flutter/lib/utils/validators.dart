/// Validateurs pour les formulaires
class Validators {
  /// Validation d'email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format d\'email invalide';
    }
    
    return null;
  }
  
  /// Validation de mot de passe
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    
    return null;
  }
  
  /// Validation de mot de passe fort
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    
    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    
    // Au moins une lettre minuscule
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une lettre minuscule';
    }
    
    // Au moins une lettre majuscule
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une lettre majuscule';
    }
    
    // Au moins un chiffre
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins un chiffre';
    }
    
    return null;
  }
  
  /// Confirmation de mot de passe
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'La confirmation du mot de passe est requise';
    }
    
    if (value != originalPassword) {
      return 'Les mots de passe ne correspondent pas';
    }
    
    return null;
  }
  
  /// Validation de nom
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est requis';
    }
    
    if (value.length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    
    if (value.length > 50) {
      return 'Le nom ne peut pas dépasser 50 caractères';
    }
    
    return null;
  }
  
  /// Validation de prénom
  static String? firstName(String? value) {
    return name(value);
  }
  
  /// Validation de nom de famille
  static String? lastName(String? value) {
    return name(value);
  }
  
  /// Validation de numéro de téléphone
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de téléphone est requis';
    }
    
    // Enlever les espaces et tirets
    final cleanNumber = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Vérifier format français
    if (!RegExp(r'^(\+33|0)[1-9](\d{8})$').hasMatch(cleanNumber)) {
      return 'Format de téléphone invalide';
    }
    
    return null;
  }
  
  /// Validation générique de champ requis
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Ce champ'} est requis';
    }
    return null;
  }
  
  /// Validation de longueur minimale
  static String? Function(String?) minLength(int minLength, [String? fieldName]) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return '${fieldName ?? 'Ce champ'} est requis';
      }
      
      if (value.length < minLength) {
        return '${fieldName ?? 'Ce champ'} doit contenir au moins $minLength caractères';
      }
      
      return null;
    };
  }
  
  /// Validation de longueur maximale
  static String? Function(String?) maxLength(int maxLength, [String? fieldName]) {
    return (String? value) {
      if (value != null && value.length > maxLength) {
        return '${fieldName ?? 'Ce champ'} ne peut pas dépasser $maxLength caractères';
      }
      
      return null;
    };
  }
  
  /// Combinateur de validateurs
  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }
}
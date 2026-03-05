import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_dimensions.dart';
import '../widgets/custom_text_field.dart';

import '../providers/auth_provider.dart';
import '../utils/validators.dart';
import '../utils/app_router.dart';

/// Écran d'inscription selon le design sobre v2
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;
  bool _isFirstNameValid = false;
  bool _isLastNameValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => context.goToLogin(),
        ),
        title: Text(
          'S\'inscrire',
          style: AppTextStyles.heading,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.marginHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.paddingL),
              
              // Logo plus petit pour la page d'inscription
              const Center(
                child: RegisterLogo(),
              ),
              
              const SizedBox(height: AppDimensions.paddingXL),
              
              // Formulaire
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Prénom et Nom sur la même ligne
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Prénom',
                            placeholder: 'John',
                            controller: _firstNameController,
                            validator: Validators.name,
                            onChanged: (value) {
                              setState(() {
                                _isFirstNameValid = Validators.name(value) == null;
                              });
                            },
                            autofocus: true,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.paddingM),
                        Expanded(
                          child: CustomTextField(
                            label: 'Nom',
                            placeholder: 'Doe',
                            controller: _lastNameController,
                            validator: Validators.name,
                            onChanged: (value) {
                              setState(() {
                                _isLastNameValid = Validators.name(value) == null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppDimensions.paddingL),
                    
                    // Champ Email
                    CustomTextField(
                      label: 'Email',
                      placeholder: 'votre@email.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                      onChanged: (value) {
                        setState(() {
                          _isEmailValid = Validators.email(value) == null;
                        });
                      },
                    ),
                    
                    const SizedBox(height: AppDimensions.paddingL),
                    
                    // Champ Mot de passe
                    CustomTextField(
                      label: 'Mot de passe',
                      controller: _passwordController,
                      isPassword: true,
                      validator: Validators.strongPassword,
                      onChanged: (value) {
                        setState(() {
                          _isPasswordValid = Validators.password(value) == null;
                          // Revalider la confirmation si elle était déjà saisie
                          if (_confirmPasswordController.text.isNotEmpty) {
                            _isConfirmPasswordValid = _confirmPasswordController.text == value;
                          }
                        });
                      },
                    ),
                    
                    const SizedBox(height: AppDimensions.paddingL),
                    
                    // Champ Confirmation mot de passe
                    CustomTextField(
                      label: 'Confirmer le mot de passe',
                      controller: _confirmPasswordController,
                      isPassword: true,
                      validator: (value) => _validateConfirmPassword(value),
                      onChanged: (value) {
                        setState(() {
                          _isConfirmPasswordValid = value == _passwordController.text;
                        });
                      },
                      onSubmitted: (value) {
                        if (_canSubmit()) {
                          _handleRegister();
                        }
                      },
                    ),
                    
                    const SizedBox(height: AppDimensions.paddingL),
                    
                    // Indication de sécurité du mot de passe
                    if (_passwordController.text.isNotEmpty)
                      _buildPasswordRequirements(),
                    
                    const SizedBox(height: AppDimensions.paddingXL),
                    
                    // Bouton d'inscription
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return RegisterButton(
                          onPressed: _canSubmit() ? _handleRegister : null,
                          isLoading: authProvider.isLoggingIn,
                        );
                      },
                    ),
                    
                    const SizedBox(height: AppDimensions.paddingL),
                    
                    // Lien vers la connexion
                    _buildLoginLink(),
                  ],
                ),
              ),
              
              const SizedBox(height: AppDimensions.paddingL),
              
              // Message d'erreur
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.hasError) {
                    return Container(
                      margin: const EdgeInsets.only(top: AppDimensions.paddingM),
                      padding: const EdgeInsets.all(AppDimensions.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        border: Border.all(
                          color: AppColors.error.withOpacity(0.3),
                          width: AppDimensions.borderWidth,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                          const SizedBox(width: AppDimensions.paddingS),
                          Expanded(
                            child: Text(
                              authProvider.error!,
                              style: AppTextStyles.secondaryText.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construire les exigences du mot de passe
  Widget _buildPasswordRequirements() {
    final password = _passwordController.text;
    
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.inputBackground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: AppColors.inputBorder.withOpacity(0.5),
          width: AppDimensions.borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Votre mot de passe doit contenir :',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppDimensions.paddingS),
          
          _buildRequirement('Au moins 8 caractères', password.length >= 8),
          _buildRequirement('Une majuscule', password.contains(RegExp(r'[A-Z]'))),
          _buildRequirement('Une minuscule', password.contains(RegExp(r'[a-z]'))),
          _buildRequirement('Un chiffre', password.contains(RegExp(r'[0-9]'))),
        ],
      ),
    );
  }

  /// Construire une exigence individuelle
  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isMet ? AppColors.success : AppColors.lightGrey,
          ),
          const SizedBox(width: AppDimensions.paddingS),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: isMet ? AppColors.success : AppColors.lightGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construire le lien vers la connexion
  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Déjà un compte ? ',
          style: AppTextStyles.secondaryText,
        ),
        TextButton(
          onPressed: () => context.goToLogin(),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryOrange,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Se connecter',
            style: AppTextStyles.link,
          ),
        ),
      ],
    );
  }

  /// Valider la confirmation du mot de passe
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }
    if (value != _passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  /// Vérifier si le formulaire peut être soumis
  bool _canSubmit() {
    return _isEmailValid && 
           _isPasswordValid && 
           _isConfirmPasswordValid &&
           _isFirstNameValid &&
           _isLastNameValid &&
           _emailController.text.isNotEmpty &&
           _passwordController.text.isNotEmpty &&
           _confirmPasswordController.text.isNotEmpty &&
           _firstNameController.text.isNotEmpty &&
           _lastNameController.text.isNotEmpty;
  }

  /// Gérer l'inscription
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
    );

    if (success && mounted) {
      // Navigation sera gérée par le router automatiquement
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inscription réussie ! Bienvenue 🎉'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}

/// Widget pour le logo de l'inscription (plus petit)
class RegisterLogo extends StatelessWidget {
  const RegisterLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryOrange,
            Color(0xFFFF8E53),
          ],
        ),
      ),
      child: const Center(
        child: Text(
          'MC',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }
}

/// Bouton d'inscription personnalisé
class RegisterButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const RegisterButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          disabledBackgroundColor: AppColors.inputBorder,
          foregroundColor: Colors.white,
          disabledForegroundColor: AppColors.lightGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'S\'inscrire',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
      ),
    );
  }
}
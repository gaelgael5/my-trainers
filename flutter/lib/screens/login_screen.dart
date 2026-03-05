import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_dimensions.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/app_logo.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';
import '../utils/app_router.dart';

/// Écran de connexion selon le design sobre v2
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.marginHorizontal),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                         MediaQuery.of(context).padding.top - 
                         MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.paddingXXL),
                
                // Logo et titre
                const LoginLogo(),
                
                const SizedBox(height: AppDimensions.paddingXXL),
                
                // Formulaire
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                        autofocus: true,
                      ),
                      
                      const SizedBox(height: AppDimensions.paddingL),
                      
                      // Champ Mot de passe
                      CustomTextField(
                        label: 'Mot de passe',
                        controller: _passwordController,
                        isPassword: true,
                        validator: Validators.password,
                        onChanged: (value) {
                          setState(() {
                            _isPasswordValid = Validators.password(value) == null;
                          });
                        },
                        onSubmitted: (value) {
                          if (_canSubmit()) {
                            _handleLogin();
                          }
                        },
                      ),
                      
                      const SizedBox(height: AppDimensions.paddingM),
                      
                      // Mot de passe oublié
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _handleForgotPassword,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primaryOrange,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingS,
                              vertical: AppDimensions.paddingS,
                            ),
                          ),
                          child: const Text(
                            'Mot de passe oublié ?',
                            style: AppTextStyles.link,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: AppDimensions.paddingL),
                      
                      // Bouton de connexion
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return LoginButton(
                            onPressed: _canSubmit() ? _handleLogin : null,
                            isLoading: authProvider.isLoggingIn,
                          );
                        },
                      ),
                      
                      const SizedBox(height: AppDimensions.paddingXL),
                      
                      // Séparateur "OU"
                      _buildDivider(),
                      
                      const SizedBox(height: AppDimensions.paddingL),
                      
                      // Lien d'inscription
                      _buildSignUpLink(),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppDimensions.paddingXL),
                
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
      ),
    );
  }

  /// Construire le séparateur "OU"
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: AppDimensions.borderWidth,
            color: AppColors.inputBorder,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
          child: Text(
            'OU',
            style: AppTextStyles.divider,
          ),
        ),
        Expanded(
          child: Container(
            height: AppDimensions.borderWidth,
            color: AppColors.inputBorder,
          ),
        ),
      ],
    );
  }

  /// Construire le lien d'inscription
  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Pas encore de compte ? ',
          style: AppTextStyles.secondaryText,
        ),
        TextButton(
          onPressed: _handleSignUp,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryOrange,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'S\'inscrire',
            style: AppTextStyles.link,
          ),
        ),
      ],
    );
  }

  /// Vérifier si le formulaire peut être soumis
  bool _canSubmit() {
    return _isEmailValid && 
           _isPasswordValid && 
           _emailController.text.isNotEmpty &&
           _passwordController.text.isNotEmpty;
  }

  /// Gérer la connexion
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      // Navigation vers l'écran principal sera gérée par le router
    }
  }

  /// Gérer le mot de passe oublié
  void _handleForgotPassword() {
    context.goToForgotPassword();
  }

  /// Gérer l'inscription
  void _handleSignUp() {
    context.goToRegister();
  }
}
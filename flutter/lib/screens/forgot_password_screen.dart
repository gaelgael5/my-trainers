import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_dimensions.dart';
import '../widgets/custom_text_field.dart';

import '../providers/auth_provider.dart';
import '../utils/validators.dart';
import '../utils/app_router.dart';

/// Écran de récupération de mot de passe
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isEmailValid = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
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
          'Mot de passe oublié',
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
              const SizedBox(height: AppDimensions.paddingXXL),
              
              // Icône d'illustration
              const Center(
                child: ForgotPasswordIcon(),
              ),
              
              const SizedBox(height: AppDimensions.paddingXL),
              
              // Titre et description
              if (!_emailSent) ...[
                Center(
                  child: Text(
                    'Récupérer votre mot de passe',
                    style: AppTextStyles.title,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingM),
                Center(
                  child: Text(
                    'Entrez votre adresse email et nous vous\nenverrons un lien pour réinitialiser\nvotre mot de passe.',
                    style: AppTextStyles.secondaryText,
                    textAlign: TextAlign.center,
                  ),
                ),
                
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
                        onSubmitted: (value) {
                          if (_canSubmit()) {
                            _handleSendResetEmail();
                          }
                        },
                        autofocus: true,
                      ),
                      
                      const SizedBox(height: AppDimensions.paddingXXL),
                      
                      // Bouton d'envoi
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return SendResetButton(
                            onPressed: _canSubmit() ? _handleSendResetEmail : null,
                            isLoading: authProvider.isLoading,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // État "Email envoyé"
                const SuccessIcon(),
                const SizedBox(height: AppDimensions.paddingXL),
                
                Center(
                  child: Text(
                    'Email envoyé !',
                    style: AppTextStyles.title,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingM),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTextStyles.secondaryText,
                      children: [
                        const TextSpan(text: 'Nous avons envoyé un lien de\nréinitialisation à '),
                        TextSpan(
                          text: _emailController.text,
                          style: AppTextStyles.secondaryText.copyWith(
                            color: AppColors.primaryOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingL),
                
                const Center(
                  child: Text(
                    'Vérifiez votre boîte de réception\net suivez les instructions.',
                    style: AppTextStyles.secondaryText,
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: AppDimensions.paddingXXL),
                
                // Actions
                Column(
                  children: [
                    // Bouton retour à la connexion
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => context.goToLogin(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Retour à la connexion',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppDimensions.paddingM),
                    
                    // Lien pour renvoyer l'email
                    TextButton(
                      onPressed: _handleResendEmail,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryOrange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingM,
                          vertical: AppDimensions.paddingS,
                        ),
                      ),
                      child: const Text(
                        'Vous n\'avez pas reçu l\'email ? Renvoyer',
                        style: AppTextStyles.link,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: AppDimensions.paddingXL),
              
              // Message d'erreur
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.hasError && !_emailSent) {
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

  /// Vérifier si le formulaire peut être soumis
  bool _canSubmit() {
    return _isEmailValid && _emailController.text.isNotEmpty;
  }

  /// Gérer l'envoi de l'email de réinitialisation
  Future<void> _handleSendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.forgotPassword(
      email: _emailController.text.trim(),
    );

    if (success && mounted) {
      setState(() {
        _emailSent = true;
      });
    }
  }

  /// Gérer le renvoi de l'email
  Future<void> _handleResendEmail() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.forgotPassword(
      email: _emailController.text.trim(),
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email renvoyé'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}

/// Icône pour l'écran de mot de passe oublié
class ForgotPasswordIcon extends StatelessWidget {
  const ForgotPasswordIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryOrange.withOpacity(0.1),
        border: Border.all(
          color: AppColors.primaryOrange.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.lock_reset,
        size: 60,
        color: AppColors.primaryOrange,
      ),
    );
  }
}

/// Icône de succès
class SuccessIcon extends StatelessWidget {
  const SuccessIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.success.withOpacity(0.1),
          border: Border.all(
            color: AppColors.success.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.mark_email_read,
          size: 60,
          color: AppColors.success,
        ),
      ),
    );
  }
}

/// Bouton d'envoi personnalisé
class SendResetButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const SendResetButton({
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
                'Envoyer le lien',
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
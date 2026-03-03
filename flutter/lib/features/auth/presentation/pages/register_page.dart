import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';

class RegisterPage extends StatefulWidget {
  final String? role;
  
  const RegisterPage({
    super.key,
    this.role,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _acceptTerms = false;
  String? _errorMessage;
  PasswordStrength _passwordStrength = PasswordStrength.weak;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _onPasswordChanged(String password) {
    setState(() {
      _passwordStrength = _getPasswordStrength(password);
    });
  }

  PasswordStrength _getPasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;
    
    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;
    
    if (score <= 1) return PasswordStrength.weak;
    if (score <= 2) return PasswordStrength.medium;
    if (score <= 3) return PasswordStrength.strong;
    return PasswordStrength.excellent;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      setState(() {
        _errorMessage = 'Vous devez accepter les conditions d\'utilisation';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // TODO: Implement registration logic
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        // Navigate to appropriate onboarding based on role
        if (widget.role == 'coach') {
          context.go(AppRoutes.coachOnboarding);
        } else {
          context.go(AppRoutes.clientDashboard);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erreur lors de la création du compte';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _registerWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // TODO: Implement Google Sign-Up
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        if (widget.role == 'coach') {
          context.go(AppRoutes.coachOnboarding);
        } else {
          context.go(AppRoutes.clientDashboard);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erreur lors de l\'inscription avec Google';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value.length < 8) {
      return AppStrings.passwordTooShort;
    }
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9])').hasMatch(value)) {
      return AppStrings.passwordMustContain;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: AppDimensions.iconBase,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  AppStrings.createAccount,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: AppDimensions.sm),

                Text(
                  AppStrings.createAccountSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: AppDimensions.xxl),

                // First Name
                TextFormField(
                  controller: _firstNameController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                  decoration: InputDecoration(
                    hintText: AppStrings.firstNameHint,
                    prefixIcon: const Icon(
                      Icons.person_outlined,
                      size: AppDimensions.iconBase,
                    ),
                  ),
                ),

                const SizedBox(height: AppDimensions.base),

                // Last Name
                TextFormField(
                  controller: _lastNameController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                  decoration: InputDecoration(
                    hintText: AppStrings.lastNameHint,
                    prefixIcon: const Icon(
                      Icons.person_outlined,
                      size: AppDimensions.iconBase,
                    ),
                  ),
                ),

                const SizedBox(height: AppDimensions.base),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                  decoration: InputDecoration(
                    hintText: AppStrings.emailHint,
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      size: AppDimensions.iconBase,
                    ),
                  ),
                ),

                const SizedBox(height: AppDimensions.base),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  validator: _validatePassword,
                  onChanged: _onPasswordChanged,
                  decoration: InputDecoration(
                    hintText: AppStrings.passwordHint,
                    prefixIcon: const Icon(
                      Icons.lock_outlined,
                      size: AppDimensions.iconBase,
                    ),
                    suffixIcon: IconButton(
                      onPressed: _togglePasswordVisibility,
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: AppDimensions.iconBase,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppDimensions.sm),

                // Password Strength Indicator
                _PasswordStrengthIndicator(strength: _passwordStrength),

                const SizedBox(height: AppDimensions.base),

                // Terms Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.xs),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _acceptTerms = !_acceptTerms;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: AppDimensions.md),
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              children: [
                                const TextSpan(text: AppStrings.acceptTerms),
                                TextSpan(
                                  text: ' ${AppStrings.termsAndConditions}',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.xl),

                // Error Message
                if (_errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimensions.md),
                    margin: const EdgeInsets.only(bottom: AppDimensions.base),
                    decoration: BoxDecoration(
                      color: AppColors.errorContainer,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: AppDimensions.iconBase,
                        ),
                        const SizedBox(width: AppDimensions.sm),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading
                        ? const SizedBox(
                            width: AppDimensions.iconBase,
                            height: AppDimensions.iconBase,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.onPrimary,
                              ),
                            ),
                          )
                        : const Text(AppStrings.register),
                  ),
                ),

                const SizedBox(height: AppDimensions.base),

                // Google Sign Up
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _registerWithGoogle,
                    icon: Image.asset(
                      'assets/icons/google.png',
                      width: AppDimensions.iconBase,
                      height: AppDimensions.iconBase,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.g_mobiledata,
                        size: AppDimensions.iconBase,
                      ),
                    ),
                    label: const Text(AppStrings.continueWithGoogle),
                  ),
                ),

                const SizedBox(height: AppDimensions.xl),

                // Sign In Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.alreadyHaveAccount,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.login),
                        child: Text(
                          AppStrings.signIn,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum PasswordStrength {
  weak,
  medium,
  strong,
  excellent,
}

class _PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength strength;

  const _PasswordStrengthIndicator({
    required this.strength,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getStrengthColors();
    final text = _getStrengthText();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(
                  right: index < 3 ? AppDimensions.xs : 0,
                ),
                decoration: BoxDecoration(
                  color: index <= strength.index 
                      ? colors.color 
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colors.color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  ({Color color, String text}) _getStrengthColors() {
    switch (strength) {
      case PasswordStrength.weak:
        return (color: AppColors.error, text: AppStrings.passwordWeak);
      case PasswordStrength.medium:
        return (color: AppColors.warning, text: AppStrings.passwordMedium);
      case PasswordStrength.strong:
        return (color: AppColors.success, text: AppStrings.passwordStrong);
      case PasswordStrength.excellent:
        return (color: AppColors.success, text: AppStrings.passwordExcellent);
    }
  }

  String _getStrengthText() {
    return _getStrengthColors().text;
  }
}
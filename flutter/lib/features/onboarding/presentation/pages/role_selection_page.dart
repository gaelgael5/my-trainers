import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/user.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  UserRole? _selectedRole;

  void _onRoleSelected(UserRole role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _onContinue() {
    if (_selectedRole == null) return;
    
    // Navigate to register with selected role
    context.go('${AppRoutes.register}?role=${_selectedRole!.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.xxxl),

              // Header
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.fitness_center,
                          size: AppDimensions.iconBase + 20,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppDimensions.sm),
                        Text(
                          AppStrings.appName,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.xxxl),
                    Text(
                      AppStrings.chooseRole,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      'Sélectionnez votre profil pour une expérience personnalisée',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.xxxl + AppDimensions.base),

              // Role Cards
              Expanded(
                child: Column(
                  children: [
                    _RoleCard(
                      role: UserRole.coach,
                      title: AppStrings.coach,
                      description: AppStrings.coachDescription,
                      icon: Icons.school_outlined,
                      isSelected: _selectedRole == UserRole.coach,
                      onTap: () => _onRoleSelected(UserRole.coach),
                    ),
                    
                    const SizedBox(height: AppDimensions.base),
                    
                    _RoleCard(
                      role: UserRole.client,
                      title: AppStrings.client,
                      description: AppStrings.clientDescription,
                      icon: Icons.person_outline,
                      isSelected: _selectedRole == UserRole.client,
                      onTap: () => _onRoleSelected(UserRole.client),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.xl),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _selectedRole != null ? _onContinue : null,
                  child: const Text('Continuer'),
                ),
              ),

              const SizedBox(height: AppDimensions.base),

              // Login Link
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
                      child: const Text(AppStrings.signIn),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final UserRole role;
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppDimensions.xl),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Icon(
                icon,
                size: AppDimensions.iconLg,
                color: isSelected ? AppColors.onPrimary : AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(width: AppDimensions.base),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            if (isSelected)
              Container(
                width: AppDimensions.iconBase,
                height: AppDimensions.iconBase,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: AppDimensions.iconSm,
                  color: AppColors.onPrimary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
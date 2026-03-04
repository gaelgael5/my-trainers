import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/onboarding_bloc.dart';

@RoutePage()
class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              // Header
              const Text(
                'Bienvenue sur',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.textSecondary,
                ),
              ),
              const Text(
                'MyCoach',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              
              const Text(
                'Choisissez votre profil pour commencer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Role selection cards
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _RoleCard(
                      role: 'coach',
                      title: 'Je suis Coach',
                      subtitle: 'Je propose mes services de coaching sportif',
                      icon: Icons.fitness_center,
                      gradientColors: [
                        AppColors.coachSecondary,
                        AppColors.coachAccent,
                      ],
                      onTap: () => _selectRole(context, 'coach'),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    _RoleCard(
                      role: 'client',
                      title: 'Je cherche un Coach',
                      subtitle: 'Je souhaite trouver un coach sportif',
                      icon: Icons.directions_run,
                      gradientColors: [
                        AppColors.clientSecondary,
                        AppColors.clientAccent,
                      ],
                      onTap: () => _selectRole(context, 'client'),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Login option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Déjà inscrit ? ',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.router.push(const LoginRoute()),
                    child: const Text(
                      'Se connecter',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _selectRole(BuildContext context, String role) {
    context.read<OnboardingBloc>().add(
      OnboardingUserTypeSelected(userType: role),
    );
    
    // Navigate to registration with selected role
    context.router.push(RegisterRoute(role: role));
  }
}

class _RoleCard extends StatelessWidget {
  final String role;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.white,
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
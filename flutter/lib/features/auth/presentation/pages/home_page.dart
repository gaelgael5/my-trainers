import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;
        final isCoach = user?.isCoach ?? false;
        
        return Scaffold(
          backgroundColor: isCoach ? AppColors.coachBackground : AppColors.backgroundLight,
          appBar: AppBar(
            title: Text(
              'MyCoach - ${isCoach ? 'Coach' : 'Client'}',
              style: TextStyle(
                color: isCoach ? AppColors.coachOnSurface : AppColors.textPrimary,
              ),
            ),
            backgroundColor: isCoach ? AppColors.coachSurface : AppColors.backgroundLight,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: isCoach ? AppColors.coachOnSurface : AppColors.textPrimary,
                ),
                onPressed: () => _showLogoutDialog(context),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Welcome section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isCoach ? AppColors.coachSurface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Profile avatar
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: isCoach 
                            ? AppColors.coachAccent 
                            : AppColors.clientSecondary,
                        child: Text(
                          user?.initials ?? 'U',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Welcome message
                      Text(
                        'Bienvenue ${user?.firstName ?? 'Utilisateur'} !',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isCoach ? AppColors.coachOnSurface : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: isCoach 
                              ? AppColors.coachOnSurface.withOpacity(0.7)
                              : AppColors.textSecondary,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Role badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isCoach 
                              ? AppColors.coachAccent 
                              : AppColors.clientSecondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isCoach ? Icons.fitness_center : Icons.directions_run,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isCoach ? 'Coach Sportif' : 'Client',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Coming soon section
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: isCoach ? AppColors.coachSurface : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.construction,
                          size: 64,
                          color: isCoach 
                              ? AppColors.coachOnSurface.withOpacity(0.6)
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(height: 24),
                        
                        Text(
                          '🚀 Application en construction',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isCoach ? AppColors.coachOnSurface : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        Text(
                          'L\'application MyCoach est en cours de développement.\n\n'
                          'Prochaines fonctionnalités :\n'
                          '${isCoach ? '• Gestion des clients\n• Création de programmes\n• Messagerie intégrée' : '• Recherche de coachs\n• Réservations\n• Suivi des progrès'}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: isCoach 
                                ? AppColors.coachOnSurface.withOpacity(0.8)
                                : AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Version info
                Text(
                  'MyCoach MVP v1.0.0+1\nPhase 1 - Infrastructure & Auth',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: isCoach 
                        ? AppColors.coachOnSurface.withOpacity(0.6)
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              context.router.pushAndClearStack(const RoleSelectionRoute());
            },
            child: const Text(
              'Déconnecter',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
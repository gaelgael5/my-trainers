import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_dimensions.dart';
import '../widgets/app_logo.dart';
import '../providers/auth_provider.dart';

/// Écran d'accueil principal de l'application
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        title: Row(
          children: [
            const AppLogo(size: 32, showGradient: false),
            const SizedBox(width: AppDimensions.paddingM),
            const Text(
              'MyCoach',
              style: AppTextStyles.heading1,
            ),
          ],
        ),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return PopupMenuButton<String>(
                icon: CircleAvatar(
                  backgroundColor: AppColors.primaryOrange.withOpacity(0.2),
                  child: Text(
                    authProvider.user?.firstName?.substring(0, 1).toUpperCase() ?? 
                    authProvider.user?.email.substring(0, 1).toUpperCase() ?? 
                    'U',
                    style: const TextStyle(
                      color: AppColors.primaryOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                color: AppColors.inputBackground,
                onSelected: (value) {
                  if (value == 'logout') {
                    _handleLogout(context);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'profile',
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: AppColors.lightGrey, size: 20),
                        const SizedBox(width: AppDimensions.paddingS),
                        Text(
                          'Profil',
                          style: AppTextStyles.fieldText.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'settings',
                    child: Row(
                      children: [
                        const Icon(Icons.settings, color: AppColors.lightGrey, size: 20),
                        const SizedBox(width: AppDimensions.paddingS),
                        Text(
                          'Paramètres',
                          style: AppTextStyles.fieldText.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        const Icon(Icons.logout, color: AppColors.error, size: 20),
                        const SizedBox(width: AppDimensions.paddingS),
                        Text(
                          'Se déconnecter',
                          style: AppTextStyles.fieldText.copyWith(
                            fontSize: 14,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.marginHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Salutation utilisateur
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                final user = authProvider.user;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour ${user?.firstName ?? 'Utilisateur'} !',
                      style: AppTextStyles.heading1.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: AppDimensions.paddingS),
                    Text(
                      'Prêt pour votre séance d\'aujourd\'hui ?',
                      style: AppTextStyles.subtitle,
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: AppDimensions.paddingXL),
            
            // Statistiques rapides
            _buildQuickStats(),
            
            const SizedBox(height: AppDimensions.paddingXL),
            
            // Séances du jour
            _buildTodaySessions(),
            
            const SizedBox(height: AppDimensions.paddingXL),
            
            // Actions rapides
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  /// Construire les statistiques rapides
  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.inputBorder,
          width: AppDimensions.borderWidth,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem('12', 'Séances\ncomplétées'),
          ),
          Container(
            width: AppDimensions.borderWidth,
            height: 40,
            color: AppColors.inputBorder,
          ),
          Expanded(
            child: _buildStatItem('3', 'Cette\nsemaine'),
          ),
          Container(
            width: AppDimensions.borderWidth,
            height: 40,
            color: AppColors.inputBorder,
          ),
          Expanded(
            child: _buildStatItem('89%', 'Taux de\nréussite'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryOrange,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXS),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.secondaryText.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  /// Construire les séances du jour
  Widget _buildTodaySessions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Séances d\'aujourd\'hui',
          style: AppTextStyles.fieldLabel,
        ),
        const SizedBox(height: AppDimensions.paddingM),
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: AppColors.inputBorder,
              width: AppDimensions.borderWidth,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: AppColors.primaryOrange,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entraînement force',
                      style: AppTextStyles.fieldLabel.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '45 minutes • 14:00',
                      style: AppTextStyles.secondaryText.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Text(
                  'Commencer',
                  style: AppTextStyles.buttonPrimary.copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construire les actions rapides
  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actions rapides',
          style: AppTextStyles.fieldLabel,
        ),
        const SizedBox(height: AppDimensions.paddingM),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppDimensions.paddingM,
          mainAxisSpacing: AppDimensions.paddingM,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              icon: Icons.add,
              title: 'Nouvelle séance',
              onTap: () {
                // TODO: Implémenter navigation vers nouvelle séance
                _showComingSoon(context);
              },
            ),
            _buildActionCard(
              icon: Icons.calendar_today,
              title: 'Planning',
              onTap: () {
                // TODO: Implémenter navigation vers planning
                _showComingSoon(context);
              },
            ),
            _buildActionCard(
              icon: Icons.analytics,
              title: 'Progrès',
              onTap: () {
                // TODO: Implémenter navigation vers analytics
                _showComingSoon(context);
              },
            ),
            _buildActionCard(
              icon: Icons.person,
              title: 'Mon profil',
              onTap: () {
                // TODO: Implémenter navigation vers profil
                _showComingSoon(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: AppColors.inputBorder,
            width: AppDimensions.borderWidth,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.primaryOrange,
              size: 32,
            ),
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              title,
              style: AppTextStyles.fieldText.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }



  /// Gérer la déconnexion
  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.inputBackground,
          title: const Text(
            'Déconnexion',
            style: AppTextStyles.fieldLabel,
          ),
          content: const Text(
            'Êtes-vous sûr de vouloir vous déconnecter ?',
            style: AppTextStyles.secondaryText,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Annuler',
                style: AppTextStyles.link,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthProvider>().logout();
              },
              child: Text(
                'Se déconnecter',
                style: AppTextStyles.link.copyWith(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Afficher message "à venir"
  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité en cours de développement'),
        backgroundColor: AppColors.primaryOrange,
      ),
    );
  }
}
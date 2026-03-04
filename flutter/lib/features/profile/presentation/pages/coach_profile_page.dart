import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';

class CoachProfilePage extends StatefulWidget {
  const CoachProfilePage({super.key});

  @override
  State<CoachProfilePage> createState() => _CoachProfilePageState();
}

class _CoachProfilePageState extends State<CoachProfilePage> {
  final String _coachName = 'Sarah Martin';
  final String _coachTitle = 'Coach fitness • Paris';
  final String _planType = 'Plan Gratuit';
  final int _currentClients = 12;
  final int _maxClients = 15;

  @override
  Widget build(BuildContext context) {
    final progress = _currentClients / _maxClients;

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.backgroundLight,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.base),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: AppColors.primaryContainer,
                            child: Text(
                              'SM',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.backgroundLight,
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 14,
                                color: AppColors.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.base),
                      Text(
                        _coachName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        _coachTitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.sm,
                          vertical: AppDimensions.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                        child: Text(
                          _planType,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Account Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.base),
              child: _SectionCard(
                title: 'Compte',
                children: [
                  _SettingsTile(
                    icon: Icons.person_outlined,
                    title: 'Informations personnelles',
                    onTap: () {
                      // TODO: Navigate to personal info
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.lock_outlined,
                    title: 'Mot de passe',
                    onTap: () {
                      // TODO: Navigate to change password
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {
                      // TODO: Navigate to notifications settings
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.language_outlined,
                    title: 'Langue',
                    trailing: 'Français',
                    onTap: () {
                      // TODO: Show language picker
                    },
                  ),
                ],
              ),
            ),
          ),

          // Subscription Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.base),
              child: _SectionCard(
                title: 'Abonnement',
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppDimensions.base),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _planType,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '$_currentClients/$_maxClients clients',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: AppColors.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progress >= 0.8 ? AppColors.primary : AppColors.success,
                          ),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                        const SizedBox(height: AppDimensions.base),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              // TODO: Navigate to upgrade
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.success,
                            ),
                            child: const Text('Upgrade'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppDimensions.base),
          ),

          // Help Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.base),
              child: _SectionCard(
                title: 'Aide',
                children: [
                  _SettingsTile(
                    icon: Icons.help_outline,
                    title: 'Centre d\'aide',
                    onTap: () {
                      // TODO: Navigate to help center
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.star_outline,
                    title: 'Donner un avis',
                    onTap: () {
                      // TODO: Open app store review
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.description_outlined,
                    title: 'Conditions d\'utilisation',
                    onTap: () {
                      // TODO: Navigate to terms
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Politique de confidentialité',
                    onTap: () {
                      // TODO: Navigate to privacy policy
                    },
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppDimensions.base),
          ),

          // Logout
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.base),
              child: TextButton.icon(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(
                  Icons.logout,
                  size: AppDimensions.iconBase,
                  color: AppColors.error,
                ),
                label: Text(
                  'Se déconnecter',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          // Version Info
          SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.base),
                child: Text(
                  'MyCoach v1.0.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textDisabled,
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 100), // Navigation bar clearance
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Se déconnecter'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Annuler',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement logout logic
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: const Text('Déconnexion'),
            ),
          ],
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.base),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.base,
          vertical: 14,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textDisabled,
                ),
              ),
            const SizedBox(width: AppDimensions.sm),
            const Icon(
              Icons.chevron_right,
              size: AppDimensions.iconBase,
              color: AppColors.outline,
            ),
          ],
        ),
      ),
    );
  }
}
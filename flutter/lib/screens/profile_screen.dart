import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_dimensions.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';


/// Écran de profil utilisateur
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        title: Text(
          'Profil',
          style: AppTextStyles.heading,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: _goToSettings,
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;
          
          if (user == null) {
            return Center(
              child: Text(
                'Utilisateur non connecté',
                style: AppTextStyles.secondaryText,
              ),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.marginHorizontal),
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.paddingL),
                
                // Avatar et informations de base
                _buildUserHeader(user),
                
                const SizedBox(height: AppDimensions.paddingXXL),
                
                // Statistiques rapides
                _buildQuickStats(),
                
                const SizedBox(height: AppDimensions.paddingXXL),
                
                // Actions du profil
                _buildProfileActions(context, authProvider),
                
                const SizedBox(height: AppDimensions.paddingXXL),
                
                // Informations du compte
                _buildAccountInfo(user),
                
                const SizedBox(height: AppDimensions.paddingXXL),
                
                // Bouton de déconnexion
                _buildLogoutButton(context, authProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Construire l'en-tête utilisateur
  Widget _buildUserHeader(User user) {
    return Column(
      children: [
        // Avatar
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryOrange,
                Color(0xFFFF8E53),
              ],
            ),
            border: Border.all(
              color: AppColors.primaryOrange.withOpacity(0.3),
              width: 3,
            ),
          ),
          child: Center(
            child: Text(
              _getUserInitials(user),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: AppDimensions.paddingL),
        
        // Nom complet
        Text(
          '${user.firstName} ${user.lastName}',
          style: AppTextStyles.title,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppDimensions.paddingS),
        
        // Email
        Text(
          user.email,
          style: AppTextStyles.secondaryText,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppDimensions.paddingM),
        
        // Badge de statut
        _buildStatusBadge(),
      ],
    );
  }

  /// Construire le badge de statut
  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
          width: AppDimensions.borderWidth,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_user,
            size: 16,
            color: AppColors.success,
          ),
          const SizedBox(width: AppDimensions.paddingXS),
          Text(
            'Compte vérifié',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aperçu de votre activité',
            style: AppTextStyles.subtitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.fitness_center,
                  label: 'Entraînements',
                  value: '0',
                  color: AppColors.primaryOrange,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.access_time,
                  label: 'Heures d\'activité',
                  value: '0h',
                  color: AppColors.success,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.trending_up,
                  label: 'Progression',
                  value: '0%',
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construire un item de statistique
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Text(
          value,
          style: AppTextStyles.subtitle.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Construire les actions du profil
  Widget _buildProfileActions(BuildContext context, AuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actions rapides',
          style: AppTextStyles.subtitle,
        ),
        const SizedBox(height: AppDimensions.paddingM),
        
        _buildActionTile(
          icon: Icons.edit,
          title: 'Modifier le profil',
          subtitle: 'Mettre à jour vos informations',
          onTap: _editProfile,
        ),
        
        _buildActionTile(
          icon: Icons.security,
          title: 'Sécurité',
          subtitle: 'Changer le mot de passe',
          onTap: _changePassword,
        ),
        
        _buildActionTile(
          icon: Icons.notifications,
          title: 'Notifications',
          subtitle: 'Gérer vos préférences',
          onTap: _manageNotifications,
        ),
        
        _buildActionTile(
          icon: Icons.help_outline,
          title: 'Aide et support',
          subtitle: 'Contacter le support',
          onTap: _getHelp,
        ),
      ],
    );
  }

  /// Construire un tile d'action
  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      child: Material(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Icon(
                    icon,
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
                        title,
                        style: AppTextStyles.bodyText,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.lightGrey,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construire les informations du compte
  Widget _buildAccountInfo(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informations du compte',
          style: AppTextStyles.subtitle,
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
          child: Column(
            children: [
              _buildInfoRow('Email', user.email),
              const Divider(color: AppColors.inputBorder, height: 24),
              _buildInfoRow('Prénom', user.firstName ?? 'Non défini'),
              const Divider(color: AppColors.inputBorder, height: 24),
              _buildInfoRow('Nom', user.lastName ?? 'Non défini'),
              const Divider(color: AppColors.inputBorder, height: 24),
              _buildInfoRow('Dernière connexion', _formatDate(user.lastLogin)),
            ],
          ),
        ),
      ],
    );
  }

  /// Construire une ligne d'information
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.secondaryText,
        ),
        Text(
          value,
          style: AppTextStyles.bodyText,
        ),
      ],
    );
  }

  /// Construire le bouton de déconnexion
  Widget _buildLogoutButton(BuildContext context, AuthProvider authProvider) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () => _handleLogout(context, authProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error.withOpacity(0.1),
          foregroundColor: AppColors.error,
          side: BorderSide(
            color: AppColors.error.withOpacity(0.3),
            width: AppDimensions.borderWidth,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          elevation: 0,
        ),
        icon: const Icon(Icons.logout, size: 20),
        label: authProvider.isLoggingOut
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text(
                'Se déconnecter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
      ),
    );
  }

  /// Obtenir les initiales de l'utilisateur
  String _getUserInitials(User user) {
    final firstName = user.firstName ?? user.email;
    final lastName = user.lastName ?? '';
    return '${firstName[0]}${lastName.isNotEmpty ? lastName[0] : ''}'.toUpperCase();
  }

  /// Formater une date
  String _formatDate(DateTime? date) {
    if (date == null) return 'Non défini';
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Actions
  void _goToSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Paramètres - En cours de développement'),
        backgroundColor: AppColors.primaryOrange,
      ),
    );
  }

  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Modifier le profil - En cours de développement'),
        backgroundColor: AppColors.primaryOrange,
      ),
    );
  }

  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changer le mot de passe - En cours de développement'),
        backgroundColor: AppColors.primaryOrange,
      ),
    );
  }

  void _manageNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications - En cours de développement'),
        backgroundColor: AppColors.primaryOrange,
      ),
    );
  }

  void _getHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Aide - En cours de développement'),
        backgroundColor: AppColors.primaryOrange,
      ),
    );
  }

  /// Gérer la déconnexion
  Future<void> _handleLogout(BuildContext context, AuthProvider authProvider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.inputBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        title: Text(
          'Déconnexion',
          style: AppTextStyles.heading,
        ),
        content: Text(
          'Êtes-vous sûr de vouloir vous déconnecter ?',
          style: AppTextStyles.bodyText,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Annuler',
              style: AppTextStyles.link.copyWith(
                color: AppColors.lightGrey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await authProvider.logout();
    }
  }
}
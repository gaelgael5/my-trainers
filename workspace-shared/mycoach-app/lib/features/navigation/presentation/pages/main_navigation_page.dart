import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/user.dart';
import '../../../dashboard/presentation/pages/coach_dashboard_page.dart';
import '../../../dashboard/presentation/pages/client_dashboard_page.dart';
import '../../../clients/presentation/pages/clients_list_page.dart';
import '../../../programs/presentation/pages/programs_list_page.dart';
import '../../../chat/presentation/pages/chat_list_page.dart';
import '../../../profile/presentation/pages/coach_profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  final String? initialLocation;
  final Widget? child;
  final UserRole role;

  const MainNavigationPage({
    super.key,
    this.initialLocation,
    this.child,
    this.role = UserRole.coach, // TODO: Get from user state
  });

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  
  late final List<_NavigationItem> _coachNavItems;
  late final List<_NavigationItem> _clientNavItems;

  @override
  void initState() {
    super.initState();
    _setupNavigationItems();
  }

  void _setupNavigationItems() {
    _coachNavItems = [
      _NavigationItem(
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        label: 'Tableau de bord',
        page: const CoachDashboardPage(),
        route: AppRoutes.coachDashboard,
      ),
      _NavigationItem(
        icon: Icons.people_outline,
        selectedIcon: Icons.people,
        label: 'Clients',
        page: const ClientsListPage(),
        route: AppRoutes.coachClients,
      ),
      _NavigationItem(
        icon: Icons.fitness_center_outlined,
        selectedIcon: Icons.fitness_center,
        label: 'Programmes',
        page: const ProgramsListPage(),
        route: AppRoutes.coachPrograms,
      ),
      _NavigationItem(
        icon: Icons.chat_bubble_outline,
        selectedIcon: Icons.chat_bubble,
        label: 'Messages',
        page: const ChatListPage(),
        route: AppRoutes.coachChat,
      ),
      _NavigationItem(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'Profil',
        page: const CoachProfilePage(),
        route: AppRoutes.coachProfile,
      ),
    ];

    _clientNavItems = [
      _NavigationItem(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: 'Accueil',
        page: const ClientDashboardPage(),
        route: AppRoutes.clientDashboard,
      ),
      _NavigationItem(
        icon: Icons.search_outlined,
        selectedIcon: Icons.search,
        label: 'Recherche',
        page: const _ClientSearchPage(),
        route: AppRoutes.clientSearch,
      ),
      _NavigationItem(
        icon: Icons.event_outlined,
        selectedIcon: Icons.event,
        label: 'Réservations',
        page: const _ClientBookingsPage(),
        route: AppRoutes.clientBookings,
      ),
      _NavigationItem(
        icon: Icons.chat_bubble_outline,
        selectedIcon: Icons.chat_bubble,
        label: 'Messages',
        page: const ChatListPage(),
        route: AppRoutes.clientChat,
      ),
      _NavigationItem(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'Profil',
        page: const _ClientProfilePage(),
        route: AppRoutes.clientProfile,
      ),
    ];
  }

  List<_NavigationItem> get _currentNavItems => 
      widget.role == UserRole.coach ? _coachNavItems : _clientNavItems;

  void _onDestinationSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    final item = _currentNavItems[index];
    context.go(item.route);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Auto-switch theme based on role if dynamic theme is enabled
    final shouldUseDarkTheme = widget.role == UserRole.coach;
    final navBarColor = shouldUseDarkTheme 
        ? AppColors.coachSurface 
        : AppColors.backgroundLight;
    
    final selectedColor = shouldUseDarkTheme 
        ? AppColors.coachSecondary 
        : AppColors.clientSecondary;
    
    final unselectedColor = shouldUseDarkTheme 
        ? AppColors.coachOnSurface.withOpacity(0.6)
        : AppColors.textDisabled;

    return Scaffold(
      body: widget.child ?? _currentNavItems[_currentIndex].page,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBarColor,
          border: Border(
            top: BorderSide(
              color: shouldUseDarkTheme 
                  ? AppColors.coachOnSurface.withOpacity(0.1)
                  : AppColors.outline,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: NavigationBar(
            height: 80,
            elevation: 0,
            backgroundColor: navBarColor,
            indicatorColor: selectedColor.withOpacity(0.1),
            selectedIndex: _currentIndex,
            onDestinationSelected: _onDestinationSelected,
            destinations: _currentNavItems
                .map((item) => NavigationDestination(
                      icon: Icon(
                        item.icon,
                        color: unselectedColor,
                      ),
                      selectedIcon: Icon(
                        item.selectedIcon,
                        color: selectedColor,
                      ),
                      label: item.label,
                    ))
                .toList(),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          ),
        ),
      ),
    );
  }
}

class _NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final Widget page;
  final String route;

  _NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.page,
    required this.route,
  });
}

// Placeholder pages for client navigation
class _ClientSearchPage extends StatelessWidget {
  const _ClientSearchPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche'),
        backgroundColor: AppColors.clientPrimary,
        foregroundColor: AppColors.clientOnPrimary,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: AppColors.clientSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'Recherche de coachs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Fonctionnalité en développement',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClientBookingsPage extends StatelessWidget {
  const _ClientBookingsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Réservations'),
        backgroundColor: AppColors.clientPrimary,
        foregroundColor: AppColors.clientOnPrimary,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event,
              size: 64,
              color: AppColors.clientSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'Mes Réservations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Fonctionnalité en développement',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClientProfilePage extends StatelessWidget {
  const _ClientProfilePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: AppColors.clientPrimary,
        foregroundColor: AppColors.clientOnPrimary,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 64,
              color: AppColors.clientSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'Profil Client',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Fonctionnalité en développement',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
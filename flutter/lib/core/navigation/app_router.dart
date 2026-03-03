import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_routes.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/onboarding/presentation/pages/role_selection_page.dart';
import '../../features/navigation/presentation/pages/main_navigation_page.dart';
import '../../features/dashboard/presentation/pages/coach_dashboard_page.dart';
import '../../features/dashboard/presentation/pages/client_dashboard_page.dart';
import '../../shared/models/user.dart';

class AppRouter {
  static GoRouter get router => _router;

  static final _router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Auth Routes
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        name: 'role-selection',
        builder: (context, state) => const RoleSelectionPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) {
          final role = state.uri.queryParameters['role'];
          return RegisterPage(role: role);
        },
      ),
      
      // Coach Routes with Shell for Navigation
      ShellRoute(
        builder: (context, state, child) => MainNavigationPage(
          initialLocation: state.uri.toString(),
          role: UserRole.coach,
          child: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.coachDashboard,
            name: 'coach-dashboard',
            builder: (context, state) => const CoachDashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.coachClients,
            name: 'coach-clients',
            builder: (context, state) => const _CoachClientsPlaceholder(),
          ),
          GoRoute(
            path: AppRoutes.coachPrograms,
            name: 'coach-programs',
            builder: (context, state) => const _CoachProgramsPlaceholder(),
          ),
          GoRoute(
            path: AppRoutes.coachChat,
            name: 'coach-chat',
            builder: (context, state) => const _CoachChatPlaceholder(),
          ),
          GoRoute(
            path: AppRoutes.coachProfile,
            name: 'coach-profile',
            builder: (context, state) => const _CoachProfilePlaceholder(),
          ),
        ],
      ),

      // Client Routes with Shell for Navigation
      ShellRoute(
        builder: (context, state, child) => MainNavigationPage(
          initialLocation: state.uri.toString(),
          role: UserRole.client,
          child: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.clientDashboard,
            name: 'client-dashboard',
            builder: (context, state) => const ClientDashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.clientSearch,
            name: 'client-search',
            builder: (context, state) => const _ClientSearchPlaceholder(),
          ),
          GoRoute(
            path: AppRoutes.clientBookings,
            name: 'client-bookings',
            builder: (context, state) => const _ClientBookingsPlaceholder(),
          ),
          GoRoute(
            path: AppRoutes.clientChat,
            name: 'client-chat',
            builder: (context, state) => const _ClientChatPlaceholder(),
          ),
          GoRoute(
            path: AppRoutes.clientProfile,
            name: 'client-profile',
            builder: (context, state) => const _ClientProfilePlaceholder(),
          ),
        ],
      ),

      // Standalone Routes (without navigation shell)
      GoRoute(
        path: AppRoutes.coachOnboarding,
        name: 'coach-onboarding',
        builder: (context, state) => const _CoachOnboardingPlaceholder(),
      ),
    ],
    errorBuilder: (context, state) => _ErrorPage(error: state.error.toString()),
  );

  static Page<T> _buildPageWithSlideTransition<T extends Object?>({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOutCubic)),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }
}

// Placeholder widgets for routes not yet implemented
class _CoachOnboardingPlaceholder extends StatelessWidget {
  const _CoachOnboardingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Onboarding'),
        leading: IconButton(
          onPressed: () => context.go(AppRoutes.coachDashboard),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text('Coach Onboarding'),
            Text('Coming soon...'),
          ],
        ),
      ),
    );
  }
}

// Coach placeholder widgets
class _CoachClientsPlaceholder extends StatelessWidget {
  const _CoachClientsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Clients')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Mes Clients'),
            Text('Fonctionnalité en développement...'),
          ],
        ),
      ),
    );
  }
}

class _CoachProgramsPlaceholder extends StatelessWidget {
  const _CoachProgramsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Programmes')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Mes Programmes'),
            Text('Fonctionnalité en développement...'),
          ],
        ),
      ),
    );
  }
}

class _CoachChatPlaceholder extends StatelessWidget {
  const _CoachChatPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Messages'),
            Text('Fonctionnalité en développement...'),
          ],
        ),
      ),
    );
  }
}

class _CoachProfilePlaceholder extends StatelessWidget {
  const _CoachProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon Profil')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Mon Profil'),
            Text('Fonctionnalité en développement...'),
          ],
        ),
      ),
    );
  }
}

// Client placeholder widgets
class _ClientSearchPlaceholder extends StatelessWidget {
  const _ClientSearchPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recherche')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Recherche de coachs'),
            Text('Fonctionnalité en développement...'),
          ],
        ),
      ),
    );
  }
}

class _ClientBookingsPlaceholder extends StatelessWidget {
  const _ClientBookingsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Réservations')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Mes Réservations'),
            Text('Fonctionnalité en développement...'),
          ],
        ),
      ),
    );
  }
}

class _ClientChatPlaceholder extends StatelessWidget {
  const _ClientChatPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Messages'),
            Text('Fonctionnalité en développement...'),
          ],
        ),
      ),
    );
  }
}

class _ClientProfilePlaceholder extends StatelessWidget {
  const _ClientProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon Profil')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Mon Profil'),
            Text('Fonctionnalité en développement...'),
          ],
        ),
      ),
    );
  }
}

class _ErrorPage extends StatelessWidget {
  final String error;

  const _ErrorPage({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.splash),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
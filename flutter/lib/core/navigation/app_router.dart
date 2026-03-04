import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/role_selection_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
@injectable
class AppRouter extends AutoRouter {
  @override
  List<AutoRoute> get routes => [
    // Splash route
    AutoRoute(
      page: SplashRoute.page,
      path: '/',
      initial: true,
    ),
    
    // Auth routes
    AutoRoute(
      page: RoleSelectionRoute.page,
      path: '/role-selection',
    ),
    AutoRoute(
      page: LoginRoute.page,
      path: '/login',
    ),
    AutoRoute(
      page: RegisterRoute.page,
      path: '/register',
    ),
    
    // Placeholder home route for testing
    AutoRoute(
      page: HomeRoute.page,
      path: '/home',
    ),
  ];
}
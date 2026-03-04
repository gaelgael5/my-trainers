import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await configureDependencies();
  
  runApp(MyCoachApp());
}

class MyCoachApp extends StatelessWidget {
  final AppRouter appRouter = getIt<AppRouter>();

  MyCoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>()..add(const AuthCheckRequested()),
        ),
        BlocProvider<OnboardingBloc>(
          create: (context) => getIt<OnboardingBloc>(),
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          // Switch theme based on user type
          final theme = authState.userType == UserType.coach 
              ? AppTheme.coachTheme 
              : AppTheme.clientTheme;
              
          return MaterialApp(
            title: 'MyCoach',
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
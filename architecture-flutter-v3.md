# Architecture Flutter MyCoach V3

## 🏗️ Architecture Globale Recommandée

### Approche : Clean Architecture + Feature-First + Modular

```
MyCoach Flutter App
├── 📱 Presentation Layer      (UI/Widgets/BLoC)
├── 🧠 Application Layer       (UseCases/BLoC Events)
├── 🔧 Domain Layer           (Entities/Repositories)
└── 💾 Data Layer             (APIs/Local Storage)
```

---

## 📁 Structure Projet Modulaire

### Répartition Packages Flutter

```
mycoach_v3/
├── 🏠 app/                           # Main app shell
│   ├── lib/
│   │   ├── main.dart                 # Entry point
│   │   ├── app.dart                  # App widget + routing
│   │   └── core/                     # App-level config
│   └── pubspec.yaml
├── 📦 packages/
│   ├── 🎨 design_system/             # Shared design tokens
│   ├── 🔧 core/                      # Shared utilities
│   ├── 🏃‍♂️ coach_feature/             # Coach workspace
│   ├── 👥 client_feature/            # Client workspace
│   ├── 🔌 integrations/              # Connected devices
│   ├── 🏋️ gym_networks/             # Gym chains APIs
│   ├── 📍 geolocation/               # Maps & location
│   ├── 🌐 l10n/                      # Internationalization
│   └── 🔐 auth/                      # Authentication
```

### Avantages Modularisation
- ✅ **Isolation** : Développement parallèle équipe
- ✅ **Testabilité** : Tests isolés par feature
- ✅ **Performance** : Compilation incrémentale
- ✅ **Réutilisation** : Packages partagés entre projets

---

## 🎨 Design System Package

### Structure design_system/
```
design_system/
├── lib/
│   ├── tokens/
│   │   ├── colors.dart              # Coach/Client palettes
│   │   ├── typography.dart          # Space Grotesk styles
│   │   ├── spacing.dart             # Grid system
│   │   └── animations.dart          # Motion design
│   ├── themes/
│   │   ├── coach_theme.dart         # Dark theme (0A0E1A)
│   │   ├── client_theme.dart        # Light theme (F0F4FF)
│   │   └── theme_switcher.dart      # Runtime switching
│   ├── components/
│   │   ├── buttons/                 # CTA, Ghost, Outlined
│   │   ├── inputs/                  # Text fields, Dropdowns
│   │   ├── cards/                   # Glassmorphism variants
│   │   ├── navigation/              # Tab bars, App bars
│   │   └── effects/                 # Neon glow, Shadows
│   └── icons/
│       ├── coach_icons.dart         # Tech iconography
│       └── client_icons.dart        # Fitness iconography
```

### Theming Technique
```dart
// ThemeSwitcher Singleton
class ThemeModeManager extends ChangeNotifier {
  UserRole _currentRole = UserRole.client;
  
  ThemeData get currentTheme => _currentRole.isCoach 
    ? CoachTheme.darkTheme 
    : ClientTheme.lightTheme;
    
  void switchRole(UserRole role) {
    _currentRole = role;
    notifyListeners();
  }
}

// Glassmorphism Effect Widget
class GlassCard extends StatelessWidget {
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

---

## 🏃‍♂️ Coach Feature Package

### Structure coach_feature/
```
coach_feature/
├── lib/
│   ├── presentation/
│   │   ├── pages/
│   │   │   ├── dashboard/
│   │   │   │   ├── coach_dashboard_page.dart
│   │   │   │   └── dashboard_widgets.dart
│   │   │   ├── clients/
│   │   │   │   ├── clients_list_page.dart
│   │   │   │   ├── client_detail_page.dart
│   │   │   │   └── add_client_page.dart
│   │   │   ├── programs/
│   │   │   │   ├── programs_library_page.dart
│   │   │   │   ├── program_builder_page.dart
│   │   │   │   └── assign_program_page.dart
│   │   │   ├── analytics/
│   │   │   │   ├── performance_analytics_page.dart
│   │   │   │   └── revenue_analytics_page.dart
│   │   │   └── profile/
│   │   │       ├── coach_profile_page.dart
│   │   │       ├── certifications_page.dart
│   │   │       └── pricing_page.dart
│   │   ├── blocs/
│   │   │   ├── coach_dashboard_bloc.dart
│   │   │   ├── clients_management_bloc.dart
│   │   │   ├── program_builder_bloc.dart
│   │   │   └── analytics_bloc.dart
│   │   └── widgets/
│   │       ├── client_cards/
│   │       ├── analytics_charts/
│   │       ├── program_templates/
│   │       └── coaching_tools/
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── coach.dart
│   │   │   ├── client.dart
│   │   │   ├── program.dart
│   │   │   └── session.dart
│   │   ├── repositories/
│   │   │   ├── coach_repository.dart
│   │   │   ├── clients_repository.dart
│   │   │   └── programs_repository.dart
│   │   └── usecases/
│   │       ├── manage_clients_usecase.dart
│   │       ├── create_program_usecase.dart
│   │       └── track_performance_usecase.dart
│   └── data/
│       ├── datasources/
│       │   ├── coach_remote_datasource.dart
│       │   └── coach_local_datasource.dart
│       ├── models/
│       │   ├── coach_model.dart
│       │   ├── client_model.dart
│       │   └── program_model.dart
│       └── repositories/
│           └── coach_repository_impl.dart
```

### Navigation Coach (15+ écrans)
```dart
// Coach navigation structure
abstract class CoachRoutes {
  // Dashboard
  static const dashboard = '/coach/dashboard';
  
  // Clients Management (4 écrans)
  static const clientsList = '/coach/clients';
  static const clientDetail = '/coach/clients/:id';
  static const addClient = '/coach/clients/add';
  static const clientNotes = '/coach/clients/:id/notes';
  
  // Programs Management (4 écrans)
  static const programsLibrary = '/coach/programs';
  static const programBuilder = '/coach/programs/builder';
  static const programDetail = '/coach/programs/:id';
  static const assignProgram = '/coach/programs/assign';
  
  // Analytics (2 écrans)
  static const performanceAnalytics = '/coach/analytics/performance';
  static const revenueAnalytics = '/coach/analytics/revenue';
  
  // Profile Management (3 écrans)
  static const profile = '/coach/profile';
  static const certifications = '/coach/profile/certifications';
  static const pricing = '/coach/profile/pricing';
  
  // Tools & Communication
  static const messaging = '/coach/messaging';
  static const calendar = '/coach/calendar';
}
```

---

## 👥 Client Feature Package

### Structure client_feature/
```
client_feature/
├── lib/
│   ├── presentation/
│   │   ├── pages/
│   │   │   ├── dashboard/
│   │   │   │   ├── client_dashboard_page.dart
│   │   │   │   └── dashboard_widgets.dart
│   │   │   ├── workouts/
│   │   │   │   ├── workouts_page.dart
│   │   │   │   ├── workout_detail_page.dart
│   │   │   │   ├── guided_workout_page.dart
│   │   │   │   └── workout_timer_page.dart
│   │   │   ├── progress/
│   │   │   │   ├── progress_overview_page.dart
│   │   │   │   ├── performance_history_page.dart
│   │   │   │   └── body_metrics_page.dart
│   │   │   ├── nutrition/
│   │   │   │   ├── nutrition_tracker_page.dart
│   │   │   │   └── meal_plans_page.dart
│   │   │   ├── coaching/
│   │   │   │   ├── find_coach_page.dart
│   │   │   │   ├── coach_profile_page.dart
│   │   │   │   ├── booking_page.dart
│   │   │   │   └── discovery_session_page.dart
│   │   │   └── profile/
│   │   │       ├── client_profile_page.dart
│   │   │       ├── settings_page.dart
│   │   │       └── connected_devices_page.dart
│   │   ├── blocs/
│   │   │   ├── workouts_bloc.dart
│   │   │   ├── progress_tracking_bloc.dart
│   │   │   ├── coach_discovery_bloc.dart
│   │   │   └── nutrition_bloc.dart
│   │   └── widgets/
│   │       ├── workout_cards/
│   │       ├── progress_charts/
│   │       ├── coach_search/
│   │       └── metric_displays/
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── workout.dart
│   │   │   ├── exercise.dart
│   │   │   ├── performance_metric.dart
│   │   │   └── nutrition_entry.dart
│   │   └── usecases/
│   │       ├── track_workout_usecase.dart
│   │       ├── find_coaches_usecase.dart
│   │       └── log_performance_usecase.dart
│   └── data/
│       └── ... # Similar structure to coach
```

### Navigation Client (25+ écrans)
```dart
abstract class ClientRoutes {
  // Dashboard
  static const dashboard = '/client/dashboard';
  
  // Workouts (6 écrans)
  static const workouts = '/client/workouts';
  static const workoutDetail = '/client/workouts/:id';
  static const guidedWorkout = '/client/workouts/:id/guided';
  static const workoutTimer = '/client/workouts/timer';
  static const createWorkout = '/client/workouts/create';
  static const workoutHistory = '/client/workouts/history';
  
  // Progress Tracking (5 écrans)
  static const progressOverview = '/client/progress';
  static const performanceHistory = '/client/progress/performance';
  static const bodyMetrics = '/client/progress/body';
  static const achievementsPage = '/client/progress/achievements';
  static const goalsPage = '/client/progress/goals';
  
  // Coaching Discovery (5 écrans)
  static const findCoach = '/client/coaching/find';
  static const coachProfile = '/client/coaching/coach/:id';
  static const bookSession = '/client/coaching/book';
  static const discoverySession = '/client/coaching/discovery';
  static const myCoach = '/client/coaching/current';
  
  // Nutrition (3 écrans)
  static const nutritionTracker = '/client/nutrition';
  static const mealPlans = '/client/nutrition/meals';
  static const nutritionGoals = '/client/nutrition/goals';
  
  // Settings (3 écrans)
  static const profile = '/client/profile';
  static const settings = '/client/settings';
  static const connectedDevices = '/client/settings/devices';
  
  // Shared
  static const messaging = '/client/messaging';
  static const notifications = '/client/notifications';
}
```

---

## 🔌 Integrations Package

### Structure integrations/
```
integrations/
├── lib/
│   ├── strava/
│   │   ├── strava_service.dart
│   │   ├── strava_auth.dart
│   │   ├── strava_models.dart
│   │   └── strava_sync_bloc.dart
│   ├── garmin/
│   │   ├── garmin_service.dart
│   │   ├── garmin_health_api.dart
│   │   ├── garmin_models.dart
│   │   └── platform_channels/
│   │       ├── garmin_channel.dart
│   │       ├── android/
│   │       │   └── GarminPlugin.kt
│   │       └── ios/
│   │           └── GarminPlugin.swift
│   ├── smart_scales/
│   │   ├── bluetooth_scale_service.dart
│   │   ├── adapters/
│   │   │   ├── withings_adapter.dart
│   │   │   ├── tanita_adapter.dart
│   │   │   └── xiaomi_adapter.dart
│   │   └── scale_sync_bloc.dart
│   └── fitness_trackers/
│       ├── apple_healthkit/
│       ├── google_fit/
│       └── samsung_health/
```

### Strava Integration Architecture
```dart
// Strava Service avec rate limiting
class StravaService {
  final Dio _dio;
  final RateLimiter _rateLimiter;
  
  Future<List<Activity>> getActivities({
    int page = 1,
    int perPage = 30,
  }) async {
    await _rateLimiter.throttle(); // 100 requests / 15min
    
    final response = await _dio.get(
      '/athlete/activities',
      queryParameters: {
        'page': page,
        'per_page': perPage,
      },
    );
    
    return (response.data as List)
        .map((json) => Activity.fromJson(json))
        .toList();
  }
}

// Platform Channel pour Garmin SDK natif
class GarminConnectChannel {
  static const platform = MethodChannel('com.mycoach/garmin');
  
  Future<List<GarminDevice>> getConnectedDevices() async {
    final result = await platform.invokeMethod('getDevices');
    return (result as List).map((json) => 
        GarminDevice.fromJson(json)).toList();
  }
  
  Future<void> syncWorkout(String workoutId) async {
    await platform.invokeMethod('syncWorkout', {
      'workoutId': workoutId,
    });
  }
}
```

---

## 🌐 Internationalisation Architecture

### Structure l10n/
```
l10n/
├── lib/
│   ├── generated/
│   │   ├── app_localizations.dart    # Auto-generated
│   │   ├── app_localizations_en.dart
│   │   ├── app_localizations_fr.dart
│   │   └── ... # 8 langues
│   ├── arb/
│   │   ├── app_en.arb               # English base
│   │   ├── app_fr.arb               # Français
│   │   ├── app_es.arb               # Español
│   │   ├── app_pt.arb               # Português
│   │   ├── app_de.arb               # Deutsch
│   │   ├── app_fr_BE.arb           # Français Belgique
│   │   ├── app_fr_CH.arb           # Français Suisse
│   │   └── app_en_GB.arb           # English UK
│   └── utils/
│       ├── currency_formatter.dart  # EUR, USD, GBP, CHF, BRL
│       ├── unit_converter.dart      # kg ↔ lb
│       └── date_formatter.dart      # Formats régionaux
```

### Formatting Multi-devises
```dart
class CurrencyFormatter {
  static String formatPrice(double amount, Locale locale) {
    final formatter = NumberFormat.currency(
      locale: locale.toString(),
      symbol: _getCurrencySymbol(locale),
    );
    return formatter.format(amount);
  }
  
  static String _getCurrencySymbol(Locale locale) {
    switch (locale.countryCode) {
      case 'US': return '\$';
      case 'GB': return '£';
      case 'CH': return 'CHF';
      case 'BR': return 'R\$';
      default: return '€'; // FR, BE, ES, DE
    }
  }
}

class UnitConverter {
  static double convertWeight(double kg, Locale locale) {
    return locale.countryCode == 'US' ? kg * 2.20462 : kg;
  }
  
  static String getWeightUnit(Locale locale) {
    return locale.countryCode == 'US' ? 'lb' : 'kg';
  }
}
```

---

## 🗃️ State Management Architecture

### BLoC Pattern + Hydration
```dart
// Base BLoC with offline persistence
abstract class HydratedAppBloC<Event, State> extends HydratedBloc<Event, State> {
  @override
  State? fromJson(Map<String, dynamic> json);
  
  @override
  Map<String, dynamic>? toJson(State state);
}

// Example: Workouts BLoC
class WorkoutsBloC extends HydratedAppBloC<WorkoutsEvent, WorkoutsState> {
  final WorkoutsRepository _repository;
  
  WorkoutsBloC(this._repository) : super(WorkoutsInitial()) {
    on<LoadWorkouts>(_onLoadWorkouts);
    on<CreateWorkout>(_onCreateWorkout);
    on<CompleteWorkout>(_onCompleteWorkout);
  }
  
  void _onLoadWorkouts(LoadWorkouts event, Emitter<WorkoutsState> emit) async {
    emit(WorkoutsLoading());
    try {
      final workouts = await _repository.getWorkouts(
        userId: event.userId,
        offline: event.offline,
      );
      emit(WorkoutsLoaded(workouts));
    } catch (e) {
      emit(WorkoutsError(e.toString()));
    }
  }
  
  @override
  WorkoutsState? fromJson(Map<String, dynamic> json) {
    return WorkoutsLoaded.fromJson(json);
  }
  
  @override
  Map<String, dynamic>? toJson(WorkoutsState state) {
    return state is WorkoutsLoaded ? state.toJson() : null;
  }
}
```

### Global State Architecture
```dart
// Multi-BLoC Provider setup
class MyCoachApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloC>(create: (_) => GetIt.I<AuthBloC>()),
        BlocProvider<ThemeBloC>(create: (_) => GetIt.I<ThemeBloC>()),
        BlocProvider<WorkoutsBloC>(create: (_) => GetIt.I<WorkoutsBloC>()),
        BlocProvider<CoachingBloC>(create: (_) => GetIt.I<CoachingBloC>()),
        BlocProvider<IntegrationsBloC>(create: (_) => GetIt.I<IntegrationsBloC>()),
      ],
      child: BlocBuilder<ThemeBloC, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            theme: themeState.currentTheme,
            routerConfig: AppRouter.router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
```

---

## 🚀 Navigation Architecture

### Go Router Setup
```dart
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Auth Shell
      ShellRoute(
        builder: (context, state, child) => AuthShell(child: child),
        routes: [
          GoRoute(path: '/login', builder: (_, __) => LoginPage()),
          GoRoute(path: '/signup', builder: (_, __) => SignupPage()),
        ],
      ),
      
      // Main App Shell
      ShellRoute(
        builder: (context, state, child) => MainAppShell(child: child),
        routes: [
          // Coach Routes
          GoRoute(
            path: '/coach',
            redirect: (_, __) => '/coach/dashboard',
            routes: CoachRoutes.routes,
          ),
          
          // Client Routes
          GoRoute(
            path: '/client',
            redirect: (_, __) => '/client/dashboard',
            routes: ClientRoutes.routes,
          ),
        ],
      ),
    ],
  );
}

// Dynamic Shell based on User Role
class MainAppShell extends StatelessWidget {
  final Widget child;
  
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloC, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return state.user.role.isCoach
              ? CoachNavigationShell(child: child)
              : ClientNavigationShell(child: child);
        }
        return const Scaffold(body: CircularProgressIndicator());
      },
    );
  }
}
```

---

## 📊 Performance Architecture

### Memory Management
```dart
// Image optimization avec cache intelligent
class OptimizedImageProvider extends StatelessWidget {
  final String imageUrl;
  final double? width, height;
  
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
      placeholder: (_, __) => const SkeletonLoader(),
      errorWidget: (_, __, ___) => const ErrorImagePlaceholder(),
      cacheManager: CustomCacheManager.instance,
    );
  }
}

// Lazy loading pour listes longues
class LazyWorkoutsList extends StatelessWidget {
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        // Preload à 5 items de distance
        if (index >= workouts.length - 5) {
          context.read<WorkoutsBloC>().add(LoadMoreWorkouts());
        }
        
        return WorkoutCard(
          workout: workouts[index],
          onTap: () => _navigateToWorkout(context, workouts[index]),
        );
      },
    );
  }
}
```

### Background Tasks
```dart
// Background sync avec Workmanager
class BackgroundSyncService {
  static void initialize() {
    Workmanager().initialize(callbackDispatcher);
    
    // Sync objets connectés toutes les heures
    Workmanager().registerPeriodicTask(
      'sync-devices',
      'syncConnectedDevices',
      frequency: Duration(hours: 1),
    );
  }
  
  @pragma('vm:entry-point')
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      switch (task) {
        case 'syncConnectedDevices':
          await _syncConnectedDevices();
          break;
      }
      return Future.value(true);
    });
  }
}
```

---

## 🧪 Testing Architecture

### Tests par Layer
```dart
// Unit Tests - Domain Layer
class WorkoutUseCaseTest {
  test('should create workout with valid data', () async {
    // Arrange
    final repository = MockWorkoutRepository();
    final useCase = CreateWorkoutUseCase(repository);
    
    // Act
    final result = await useCase(CreateWorkoutParams(
      name: 'Push Day',
      exercises: [mockExercise],
    ));
    
    // Assert
    expect(result.isRight(), true);
    verify(repository.createWorkout(any)).called(1);
  });
}

// Widget Tests - Presentation Layer
class WorkoutCardTest {
  testWidgets('should display workout info correctly', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: WorkoutCard(workout: mockWorkout),
    ));
    
    expect(find.text(mockWorkout.name), findsOneWidget);
    expect(find.text('${mockWorkout.duration} min'), findsOneWidget);
  });
}

// Integration Tests - Full flow
class WorkoutFlowTest {
  testWidgets('complete workout creation flow', (tester) async {
    await tester.pumpWidget(MyCoachApp());
    
    // Navigate to workout creation
    await tester.tap(find.byKey(Key('create_workout_fab')));
    await tester.pumpAndSettle();
    
    // Fill workout form
    await tester.enterText(find.byKey(Key('workout_name_field')), 'Test Workout');
    
    // Add exercise
    await tester.tap(find.byKey(Key('add_exercise_button')));
    await tester.pumpAndSettle();
    
    // Save workout
    await tester.tap(find.byKey(Key('save_workout_button')));
    await tester.pumpAndSettle();
    
    // Verify navigation to workout detail
    expect(find.byType(WorkoutDetailPage), findsOneWidget);
  });
}
```

---

## 🔧 Dependency Injection

### GetIt Setup
```dart
// Service Locator configuration
class InjectionContainer {
  static final GetIt sl = GetIt.instance;
  
  static Future<void> init() async {
    // External dependencies
    sl.registerLazySingleton(() => Dio());
    sl.registerLazySingleton(() => HiveInterface());
    
    // Repositories
    sl.registerLazySingleton<WorkoutRepository>(
      () => WorkoutRepositoryImpl(sl(), sl()),
    );
    
    // Use Cases
    sl.registerLazySingleton(() => CreateWorkoutUseCase(sl()));
    sl.registerLazySingleton(() => GetWorkoutsUseCase(sl()));
    
    // BLoCs
    sl.registerFactory(() => WorkoutsBloC(sl()));
    sl.registerFactory(() => CoachingBloC(sl()));
  }
}
```

---

## 📈 Scalabilité & Maintenance

### Métriques Performance
```dart
// Performance monitoring automatique
class PerformanceInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['start_time'] = DateTime.now();
    super.onRequest(options, handler);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['start_time'] as DateTime;
    final duration = DateTime.now().difference(startTime);
    
    // Log si > 2 secondes
    if (duration.inMilliseconds > 2000) {
      FirebaseCrashlytics.instance.log(
        'Slow API call: ${response.requestOptions.path} - ${duration.inMilliseconds}ms'
      );
    }
    
    super.onResponse(response, handler);
  }
}
```

### Code Generation
```bash
# Build automation pour 60+ écrans
flutter packages pub run build_runner build --delete-conflicting-outputs

# Génération localizations
flutter gen-l10n

# Génération JSON models
json_serializable + freezed pour models immutables
```

---

## ✅ Recommandations Finales

### Architecture Principles

1. **Separation of Concerns** : Clean Architecture stricte
2. **Dependency Inversion** : Abstractions > Implémentations
3. **Single Responsibility** : Une classe = une responsabilité
4. **Testability First** : Mockable dependencies partout
5. **Performance by Design** : Lazy loading, caching, optimisation

### Outils Recommandés

| Catégorie | Package | Justification |
|-----------|---------|---------------|
| State Management | `flutter_bloc` | Predictable, testable |
| Navigation | `go_router` | Declarative, type-safe |
| DI | `get_it` | Simple, performant |
| Storage | `hive` + `sqlite3` | Fast + relational |
| HTTP | `dio` + `retrofit` | Robust + code gen |
| Images | `cached_network_image` | Memory optimized |
| Animations | `flutter_animate` | Micro-interactions |
| Background | `workmanager` | Cross-platform tasks |

Cette architecture modulaire permet de gérer les **60+ écrans** de manière scalable, avec une séparation claire des responsabilités et une maintenance facilitée pour une équipe de 3-4 développeurs Flutter.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _titleAnimation;
  late Animation<double> _subtitleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
    _navigateToLogin();
  }

  void _setupAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutCubic,
    ));

    _titleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _subtitleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));
  }

  void _startAnimations() {
    _logoController.forward();
    
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _textController.forward();
      }
    });
  }

  void _navigateToLogin() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        context.go(AppRoutes.roleSelection);
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xl),
            child: Column(
              children: [
                const Expanded(
                  flex: 4,
                  child: SizedBox(),
                ),
                
                // Logo Animation
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: FadeTransition(
                        opacity: _logoAnimation,
                        child: Container(
                          width: AppDimensions.avatarXl,
                          height: AppDimensions.avatarXl,
                          decoration: BoxDecoration(
                            color: AppColors.onPrimary.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.fitness_center,
                            size: AppDimensions.iconXxl,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppDimensions.base),

                // Title Animation
                AnimatedBuilder(
                  animation: _titleAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _titleAnimation,
                      child: Text(
                        AppStrings.appName,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppDimensions.sm),

                // Subtitle Animation
                AnimatedBuilder(
                  animation: _subtitleAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _subtitleAnimation,
                      child: Text(
                        AppStrings.appTagline,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.onPrimary.withOpacity(0.7),
                        ),
                      ),
                    );
                  },
                ),

                const Expanded(
                  flex: 3,
                  child: SizedBox(),
                ),

                // Loading Indicator
                const SizedBox(
                  width: AppDimensions.lg,
                  height: AppDimensions.lg,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                  ),
                ),

                const SizedBox(height: AppDimensions.xxxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
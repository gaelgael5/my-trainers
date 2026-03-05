import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Logo de l'application selon le design sobre v2
class AppLogo extends StatelessWidget {
  final double size;
  final bool showGradient;
  
  const AppLogo({
    super.key,
    this.size = AppDimensions.logoSize,
    this.showGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        gradient: showGradient ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.logoGradient,
        ) : null,
        color: showGradient ? null : AppColors.primaryOrange,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.3),
            blurRadius: AppDimensions.elevationMedium,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'MC',
          style: TextStyle(
            fontSize: size * 0.35, // Proportion du texte par rapport au conteneur
            fontWeight: FontWeight.w700,
            color: AppColors.white,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }
}

/// Logo avec animation de rotation (pour les états de loading)
class AnimatedAppLogo extends StatefulWidget {
  final double size;
  final bool isLoading;
  
  const AnimatedAppLogo({
    super.key,
    this.size = AppDimensions.logoSize,
    this.isLoading = false,
  });

  @override
  State<AnimatedAppLogo> createState() => _AnimatedAppLogoState();
}

class _AnimatedAppLogoState extends State<AnimatedAppLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant AnimatedAppLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return RotationTransition(
        turns: _animation,
        child: AppLogo(size: widget.size),
      );
    } else {
      return AppLogo(size: widget.size);
    }
  }
}

/// Logo avec texte pour la page de connexion
class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppLogo(size: AppDimensions.logoSize),
        const SizedBox(height: AppDimensions.paddingL),
        Text(
          'Bienvenue',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Text(
          'Connectez-vous pour continuer',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.lightGrey,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}
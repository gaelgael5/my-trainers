import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final double blur;
  final double opacity;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.blur = 10.0,
    this.opacity = 0.2,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;
    
    // Default glass color based on theme
    final defaultGlassColor = isDarkTheme 
        ? AppColors.coachSurface.withOpacity(opacity)
        : AppColors.surface.withOpacity(opacity);

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor ?? defaultGlassColor,
              borderRadius: borderRadius ?? BorderRadius.circular(16),
              border: border ?? Border.all(
                color: isDarkTheme 
                    ? AppColors.coachOnSurface.withOpacity(0.2)
                    : AppColors.outline.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: boxShadow ?? [
                BoxShadow(
                  color: isDarkTheme 
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class GlassButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;

  const GlassButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onPressed,
      child: GlassContainer(
        width: width,
        height: height ?? 52,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        backgroundColor: backgroundColor ?? (isDarkTheme 
            ? AppColors.coachAccent.withOpacity(0.3)
            : AppColors.primary.withOpacity(0.1)),
        child: Center(
          child: DefaultTextStyle(
            style: theme.textTheme.labelLarge!.copyWith(
              color: foregroundColor ?? (isDarkTheme 
                  ? AppColors.coachOnSurface
                  : AppColors.primary),
              fontWeight: FontWeight.w600,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = GlassContainer(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: child,
    );

    if (onTap != null) {
      card = GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}
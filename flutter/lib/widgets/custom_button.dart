import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_dimensions.dart';

enum CustomButtonStyle {
  primary,
  secondary,
  text,
}

/// Bouton personnalisé selon le design sobre v2
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonStyle style;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsets? padding;
  final Widget? icon;
  final double? height;
  
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = CustomButtonStyle.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.padding,
    this.icon,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? AppDimensions.buttonHeight;
    
    switch (style) {
      case CustomButtonStyle.primary:
        return _buildPrimaryButton(buttonHeight);
      case CustomButtonStyle.secondary:
        return _buildSecondaryButton(buttonHeight);
      case CustomButtonStyle.text:
        return _buildTextButton();
    }
  }
  
  /// Bouton principal orange
  Widget _buildPrimaryButton(double buttonHeight) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.primaryOrange.withOpacity(0.6),
          disabledForegroundColor: AppColors.white.withOpacity(0.7),
          elevation: AppDimensions.elevationLow,
          shadowColor: AppColors.primaryOrange.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
            vertical: AppDimensions.paddingM,
          ),
        ),
        child: _buildButtonContent(AppTextStyles.buttonPrimary),
      ),
    );
  }
  
  /// Bouton secondaire (contour)
  Widget _buildSecondaryButton(double buttonHeight) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: buttonHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryOrange,
          disabledForegroundColor: AppColors.primaryOrange.withOpacity(0.6),
          side: const BorderSide(
            color: AppColors.primaryOrange,
            width: AppDimensions.borderWidth,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
            vertical: AppDimensions.paddingM,
          ),
        ),
        child: _buildButtonContent(AppTextStyles.buttonPrimary.copyWith(
          color: AppColors.primaryOrange,
        )),
      ),
    );
  }
  
  /// Bouton texte (lien)
  Widget _buildTextButton() {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryOrange,
        disabledForegroundColor: AppColors.primaryOrange.withOpacity(0.6),
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
      ),
      child: _buildButtonContent(AppTextStyles.link),
    );
  }
  
  /// Contenu du bouton avec loading/texte/icône
  Widget _buildButtonContent(TextStyle textStyle) {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(textStyle.color!),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingS),
          Text('Chargement...', style: textStyle),
        ],
      );
    }
    
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(width: AppDimensions.paddingS),
          Text(text, style: textStyle),
        ],
      );
    }
    
    return Text(text, style: textStyle);
  }
}

/// Bouton spécialisé pour le login (raccourci)
class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  
  const LoginButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Se connecter',
      onPressed: onPressed,
      isLoading: isLoading,
      style: CustomButtonStyle.primary,
    );
  }
}
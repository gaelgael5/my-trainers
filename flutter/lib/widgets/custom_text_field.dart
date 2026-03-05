import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_dimensions.dart';

/// Champ de saisie personnalisé selon le design sobre v2
class CustomTextField extends StatefulWidget {
  final String label;
  final String? placeholder;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  
  const CustomTextField({
    super.key,
    required this.label,
    this.placeholder,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.inputFormatters,
    this.autofocus = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: AppTextStyles.fieldLabel,
        ),
        const SizedBox(height: AppDimensions.paddingS),
        
        // Champ de saisie
        TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : false,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            enabled: widget.enabled,
            maxLines: widget.maxLines,
            inputFormatters: widget.inputFormatters,
            autofocus: widget.autofocus,
            style: AppTextStyles.fieldText,
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: AppTextStyles.fieldPlaceholder,
              filled: true,
              fillColor: AppColors.inputBackground,
              prefixIcon: widget.prefixIcon,
              suffixIcon: _buildSuffixIcon(),
              border: _buildBorder(),
              enabledBorder: _buildBorder(),
              focusedBorder: _buildBorder(isFocused: true),
              errorBorder: _buildBorder(isError: true),
              focusedErrorBorder: _buildBorder(isFocused: true, isError: true),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.paddingM,
              ),
            ),
          ),
      ],
    );
  }
  
  /// Construire l'icône de suffixe (avec toggle password si nécessaire)
  Widget? _buildSuffixIcon() {
    if (widget.isPassword) {
      return IconButton(
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: AppColors.lightGrey,
          size: 20,
        ),
      );
    }
    
    return widget.suffixIcon;
  }
  
  /// Construire la bordure selon l'état
  OutlineInputBorder _buildBorder({bool isFocused = false, bool isError = false}) {
    Color borderColor;
    double borderWidth;
    
    if (isError) {
      borderColor = AppColors.error;
      borderWidth = isFocused ? 2.0 : AppDimensions.borderWidth;
    } else if (isFocused) {
      borderColor = AppColors.primaryOrange;
      borderWidth = 2.0;
    } else {
      borderColor = AppColors.inputBorder;
      borderWidth = AppDimensions.borderWidth;
    }
    
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
    );
  }
}
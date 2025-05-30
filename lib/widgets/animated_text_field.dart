import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

class AnimatedTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final bool readOnly;
  final Widget? prefix;
  final Widget? suffix;
  final FocusNode? focusNode;
  final bool autofocus;
  final EdgeInsetsGeometry contentPadding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? labelColor;
  final Color? hintColor;
  final Color? textColor;
  final Color? errorColor;
  final double labelFontSize;
  final double hintFontSize;
  final double textFontSize;
  final FontWeight labelFontWeight;
  final FontWeight hintFontWeight;
  final FontWeight textFontWeight;

  const AnimatedTextField({
    Key? key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.readOnly = false,
    this.prefix,
    this.suffix,
    this.focusNode,
    this.autofocus = false,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    this.borderRadius = 8.0,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.labelColor,
    this.hintColor,
    this.textColor,
    this.errorColor,
    this.labelFontSize = 14.0,
    this.hintFontSize = 14.0,
    this.textFontSize = 16.0,
    this.labelFontWeight = FontWeight.w500,
    this.hintFontWeight = FontWeight.normal,
    this.textFontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveBackgroundColor = backgroundColor ??
        (isDark ? AppTheme.darkSurfaceColor : AppTheme.surfaceColor);
    final effectiveBorderColor = borderColor ??
        (isDark ? AppTheme.darkTextColor.withOpacity(0.5) : AppTheme.textLightColor);
    final effectiveFocusedBorderColor = focusedBorderColor ?? AppTheme.primaryColor;
    final effectiveErrorBorderColor = errorBorderColor ?? AppTheme.errorColor;
    final effectiveLabelColor = labelColor ??
        (isDark ? AppTheme.darkTextColor : AppTheme.textSecondaryColor);
    final effectiveHintColor = hintColor ??
        (isDark ? AppTheme.darkTextColor.withOpacity(0.5) : AppTheme.textLightColor);
    final effectiveTextColor = textColor ??
        (isDark ? AppTheme.darkTextColor : AppTheme.textPrimaryColor);
    final effectiveErrorColor = errorColor ?? AppTheme.errorColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: errorText != null ? effectiveErrorBorderColor : effectiveBorderColor,
          width: 1.0,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        minLines: minLines,
        enabled: enabled,
        readOnly: readOnly,
        focusNode: focusNode,
        autofocus: autofocus,
        style: TextStyle(
          color: effectiveTextColor,
          fontSize: textFontSize,
          fontWeight: textFontWeight,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: errorText,
          prefixIcon: prefix,
          suffixIcon: suffix,
          contentPadding: contentPadding,
          border: InputBorder.none,
          labelStyle: TextStyle(
            color: effectiveLabelColor,
            fontSize: labelFontSize,
            fontWeight: labelFontWeight,
          ),
          hintStyle: TextStyle(
            color: effectiveHintColor,
            fontSize: hintFontSize,
            fontWeight: hintFontWeight,
          ),
          errorStyle: TextStyle(
            color: effectiveErrorColor,
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class AnimatedSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final FocusNode? focusNode;
  final bool autofocus;
  final EdgeInsetsGeometry contentPadding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? hintColor;
  final Color? textColor;
  final double hintFontSize;
  final double textFontSize;
  final FontWeight hintFontWeight;
  final FontWeight textFontWeight;

  const AnimatedSearchField({
    Key? key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onClear,
    this.focusNode,
    this.autofocus = false,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    this.borderRadius = 8.0,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.hintColor,
    this.textColor,
    this.hintFontSize = 14.0,
    this.textFontSize = 16.0,
    this.hintFontWeight = FontWeight.normal,
    this.textFontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedTextField(
      controller: controller,
      hint: hint,
      onChanged: onChanged,
      focusNode: focusNode,
      autofocus: autofocus,
      contentPadding: contentPadding,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      focusedBorderColor: focusedBorderColor,
      hintColor: hintColor,
      textColor: textColor,
      hintFontSize: hintFontSize,
      textFontSize: textFontSize,
      hintFontWeight: hintFontWeight,
      textFontWeight: textFontWeight,
      prefix: const Icon(Icons.search),
      suffix: controller?.text.isNotEmpty == true
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                controller?.clear();
                onClear?.call();
              },
            )
          : null,
    );
  }
} 
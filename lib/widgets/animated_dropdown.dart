import 'package:flutter/material.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

class AnimatedDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool enabled;
  final Widget? prefix;
  final Widget? suffix;
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
  final bool isExpanded;
  final double? width;
  final double? height;
  final AlignmentGeometry alignment;
  final bool isDense;

  const AnimatedDropdown({
    Key? key,
    required this.value,
    required this.items,
    this.onChanged,
    this.label,
    this.hint,
    this.errorText,
    this.enabled = true,
    this.prefix,
    this.suffix,
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
    this.isExpanded = false,
    this.width,
    this.height,
    this.alignment = Alignment.centerLeft,
    this.isDense = false,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              color: effectiveLabelColor,
              fontSize: labelFontSize,
              fontWeight: labelFontWeight,
            ),
          ),
          const SizedBox(height: 8.0),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: errorText != null ? effectiveErrorBorderColor : effectiveBorderColor,
              width: 1.0,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: enabled ? onChanged : null,
              isExpanded: isExpanded,
              alignment: alignment,
              isDense: isDense,
              icon: const Icon(Icons.arrow_drop_down),
              hint: hint != null
                  ? Text(
                      hint!,
                      style: TextStyle(
                        color: effectiveHintColor,
                        fontSize: hintFontSize,
                        fontWeight: hintFontWeight,
                      ),
                    )
                  : null,
              style: TextStyle(
                color: effectiveTextColor,
                fontSize: textFontSize,
                fontWeight: textFontWeight,
              ),
              dropdownColor: effectiveBackgroundColor,
              padding: contentPadding,
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4.0),
          Text(
            errorText!,
            style: TextStyle(
              color: effectiveErrorColor,
              fontSize: 12.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ],
    );
  }
}

class AnimatedDropdownButton<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool enabled;
  final Widget? prefix;
  final Widget? suffix;
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
  final bool isExpanded;
  final double? width;
  final double? height;
  final AlignmentGeometry alignment;
  final bool isDense;
  final VoidCallback? onTap;

  const AnimatedDropdownButton({
    Key? key,
    required this.value,
    required this.items,
    this.onChanged,
    this.label,
    this.hint,
    this.errorText,
    this.enabled = true,
    this.prefix,
    this.suffix,
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
    this.isExpanded = false,
    this.width,
    this.height,
    this.alignment = Alignment.centerLeft,
    this.isDense = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDropdown<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      label: label,
      hint: hint,
      errorText: errorText,
      enabled: enabled,
      prefix: prefix,
      suffix: suffix,
      contentPadding: contentPadding,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      focusedBorderColor: focusedBorderColor,
      errorBorderColor: errorBorderColor,
      labelColor: labelColor,
      hintColor: hintColor,
      textColor: textColor,
      errorColor: errorColor,
      labelFontSize: labelFontSize,
      hintFontSize: hintFontSize,
      textFontSize: textFontSize,
      labelFontWeight: labelFontWeight,
      hintFontWeight: hintFontWeight,
      textFontWeight: textFontWeight,
      isExpanded: isExpanded,
      width: width,
      height: height,
      alignment: alignment,
      isDense: isDense,
    );
  }
} 
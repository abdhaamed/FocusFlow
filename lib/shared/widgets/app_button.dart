import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

enum AppButtonVariant { primary, secondary, outlined, inverted }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final AppButtonVariant variant;
  final Widget? trailingIcon;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;
    BorderSide? side;

    switch (variant) {
      case AppButtonVariant.primary:
        backgroundColor = AppColors.primary;
        foregroundColor = Colors.white;
        break;
      case AppButtonVariant.secondary:
        backgroundColor = AppColors.primary.withOpacity(0.08); // Light blueish
        foregroundColor = AppColors.primary;
        break;
      case AppButtonVariant.inverted:
        backgroundColor = AppColors.neutral;
        foregroundColor = Colors.white;
        break;
      case AppButtonVariant.outlined:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.primary;
        side = const BorderSide(color: AppColors.neutral, width: 1);
        break;
    }

    Widget content = Text(
      label,
      style: AppTypography.labelMedium.copyWith(
        color: foregroundColor,
        fontSize: 14,
      ),
    );

    if (trailingIcon != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          content,
          const SizedBox(width: 8),
          trailingIcon!,
        ],
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: side,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
      child: content,
    );
  }
}

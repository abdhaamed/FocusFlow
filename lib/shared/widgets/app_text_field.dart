// ASSIGNED TO: Hamid
// TODO(Hamid): Implement AppTextField with custom styling and validation support.

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String? label;
  final int maxLines;
  final Widget? prefixIcon;

  const AppTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.label,
    this.maxLines = 1,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final inputField = TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.neutral.withOpacity(0.6)),
        prefixIcon: prefixIcon,
        prefixIconColor: AppColors.neutral.withOpacity(0.6),
        filled: true,
        fillColor: AppColors.primary.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.1), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );

    if (label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label!,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          inputField,
        ],
      );
    }

    return inputField;
  }
}

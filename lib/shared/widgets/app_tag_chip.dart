// ASSIGNED TO: Hamid
// TODO(Hamid): Implement AppTagChip for displaying categories or tags.

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class AppTagChip extends StatelessWidget {
  final String label;
  final Color? color;

  const AppTagChip({
    super.key,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Minimal reference to AppColors and AppTypography as requested
    return Text(
      'AppTagChip: $label',
      style: AppTypography.labelSmall.copyWith(color: color ?? AppColors.secondary),
    );
  }
}

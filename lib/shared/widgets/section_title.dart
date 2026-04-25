// ASSIGNED TO: Hamid
// TODO(Hamid): Implement SectionTitle with optional action button.

import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    // Minimal reference to AppTypography as requested
    return Text(
      'SectionTitle: $title',
      style: AppTypography.headlineMedium,
    );
  }
}

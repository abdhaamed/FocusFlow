// ASSIGNED TO: Hamid
// TODO(Hamid): Implement AppProgressBar with smooth animation and custom colors.

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppProgressBar extends StatelessWidget {
  final double value;
  final Color? color;

  const AppProgressBar({
    super.key,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primary;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: animatedValue,
            minHeight: 8,
            backgroundColor: activeColor.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(activeColor),
          ),
        );
      },
    );
  }
}

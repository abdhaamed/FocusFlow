import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/progress_bar.dart';
import 'smart_badge.dart';

class GoalSummaryCard extends StatelessWidget {
  final String title;
  final String specific;
  final String measurable;
  final String achievable;
  final String relevant;
  final String timebound;
  final double progressValue;

  const GoalSummaryCard({
    super.key,
    required this.title,
    required this.specific,
    required this.measurable,
    required this.achievable,
    required this.relevant,
    required this.timebound,
    this.progressValue = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(height: 4, color: AppColors.tertiary),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    title,
                    style: AppTypography.headlineMedium.copyWith(
                      fontSize: 22,
                      color: AppColors.primary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 13,
                          color: AppColors.neutral,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${(progressValue * 100).toInt()}%',
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 13,
                          color: AppColors.neutral,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AppProgressBar(value: progressValue),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 16),
                  SmartBadge(
                    icon: Icons.my_location,
                    title: 'Specific',
                    description: specific,
                  ),
                  SmartBadge(
                    icon: Icons.bar_chart_rounded,
                    title: 'Measurable',
                    description: measurable,
                  ),
                  SmartBadge(
                    icon: Icons.check_circle_outline,
                    title: 'Achievable',
                    description: achievable,
                  ),
                  SmartBadge(
                    icon: Icons.link,
                    title: 'Relevant',
                    description: relevant,
                  ),
                  SmartBadge(
                    icon: Icons.calendar_today_outlined,
                    title: 'Time-bound',
                    description: timebound,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


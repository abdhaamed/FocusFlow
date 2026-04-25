import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/main_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'FOCUSFLOW',
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.primary,
            letterSpacing: 2.0,
            fontSize: 16,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: const Icon(
                Icons.person,
                size: 20,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Stack(
                children: [
                  const Icon(
                    Icons.notifications_none,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  Positioned(
                    right: 4,
                    top: 2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Command Center Title
            Text(
              'Command Center',
              style: AppTypography.headlineLarge.copyWith(
                color: AppColors.primary,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Good morning, Alex. Let\'s focus.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.neutral,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // Active Goal Card
            _buildActiveGoalCard(context),
            const SizedBox(height: 16),

            // Add New Goal Button
            _buildAddGoalButton(context),
            const SizedBox(height: 24),

            // Focus Flow Section
            _buildFocusFlowCard(),
            const SizedBox(height: 24),

            // Momentum Section
            _buildMomentumSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: const MainBottomNav(currentIndex: 0),
    );
  }

  Widget _buildActiveGoalCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.goalDetail);
      },
      child: Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: AppColors.primary, width: 4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tags
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'CURRENT GOAL',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Q3',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.neutral,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Goal Title
                Text(
                  'Complete Project Alpha MVP',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.primary,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),

                // SMART Tags
                Wrap(
                  spacing: 6.0,
                  runSpacing: 8.0,
                  children: [
                    _buildSmartTag(Icons.track_changes, 'Specific'),
                    _buildSmartTag(Icons.bar_chart, 'Measurable'),
                    _buildSmartTag(Icons.flash_on, 'Achievable'),
                    _buildSmartTag(Icons.auto_awesome_mosaic, 'Relevant'),
                    _buildSmartTag(Icons.access_time, 'Time-bound'),
                  ],
                ),
                const SizedBox(height: 20),

                // Progress Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '65%',
                            style: AppTypography.headlineLarge.copyWith(
                              color: AppColors.primary,
                              fontSize: 28,
                            ),
                          ),
                          Text(
                            'Completion',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.neutral,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: 0.65,
                            minHeight: 8,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmartTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.neutral),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.neutral,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddGoalButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.onboardingSpecific);
      },
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          radius: const Radius.circular(12),
          color: AppColors.primary.withOpacity(0.3),
          strokeWidth: 1.5,
          dashPattern: const [6, 4],
        ),
        child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_circle_outline,
              color: AppColors.primary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Add New Goal',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildFocusFlowCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Focus Flow',
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.primary,
                  fontSize: 15,
                ),
              ),
              Text(
                'View All',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTaskItem(
            title: 'Finalize Q3 Budget Projections',
            subtitleIcon: Icons.access_time,
            subtitleText: 'Due Today, 2 PM',
            subtitleColor: Colors.red.shade600,
            tagText: 'Finance',
            borderColor: Colors.red.shade700,
          ),
          const SizedBox(height: 12),
          _buildTaskItem(
            title: 'Review Design System Updates',
            subtitleIcon: Icons.calendar_today_outlined,
            subtitleText: 'Tomorrow',
            subtitleColor: AppColors.neutral,
            tagText: 'Design',
            borderColor: Colors.green.shade800,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem({
    required String title,
    required IconData subtitleIcon,
    required String subtitleText,
    required Color subtitleColor,
    required String tagText,
    required Color borderColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: borderColor, width: 3)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade400, width: 1.5),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(subtitleIcon, size: 12, color: subtitleColor),
                              const SizedBox(width: 4),
                              Text(
                                subtitleText,
                                style: AppTypography.labelMedium.copyWith(
                                  color: subtitleColor,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tagText,
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.neutral,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMomentumSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Momentum',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.primary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 16),

          // Main Blue Box
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Focus Score',
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '84',
                      style: AppTypography.headlineLarge.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.trending_up,
                  color: Colors.white.withOpacity(0.5),
                  size: 32,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Stat Row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '12',
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tasks Completed',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary.withOpacity(0.8),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '4h',
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Deep Work',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary.withOpacity(0.8),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

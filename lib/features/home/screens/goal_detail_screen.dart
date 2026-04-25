import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class GoalDetailScreen extends StatelessWidget {
  const GoalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Executive Goals',
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: const Icon(Icons.person, size: 20, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Main Objective Card
            _buildMainCard(),
            const SizedBox(height: 16),
            
            // SMART Specific
            _buildSmartComponentCard(
              icon: Icons.track_changes,
              iconColor: AppColors.primary,
              title: 'Specific',
              borderColor: AppColors.primary.withOpacity(0.5),
              description: 'Develop and deploy the core \'Task Tracking\' and \'Reporting\' modules. Exclude \'Integration\' features for this phase.',
            ),
            const SizedBox(height: 12),
            
            // SMART Measurable
            _buildSmartComponentCard(
              icon: Icons.bar_chart,
              iconColor: AppColors.tertiary,
              title: 'Measurable',
              borderColor: AppColors.tertiary,
              description: 'Pass 100% of P1 unit tests. Achieve a sub-200ms response time on key API endpoints.',
            ),
            const SizedBox(height: 12),
            
            // SMART Achievable
            _buildSmartComponentCard(
              icon: Icons.check_circle,
              iconColor: AppColors.secondary,
              title: 'Achievable',
              borderColor: AppColors.secondary,
              description: 'Allocated 3 full-time senior engineers. Dependencies on UX design are fully resolved.',
            ),
            const SizedBox(height: 12),
            
            // SMART Relevant
            _buildSmartComponentCard(
              icon: Icons.link,
              iconColor: Colors.purple.shade300,
              title: 'Relevant',
              borderColor: Colors.purple.shade200,
              description: 'Aligns directly with Q3 corporate priority: "Modernize Internal Tooling".',
            ),
            const SizedBox(height: 12),
            
            // SMART Time-bound
            _buildTimeboundCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: AppColors.primary, width: 4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                      ),
                      child: Text(
                        'Q3 Objective',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.edit, color: AppColors.primary, size: 18),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Complete Project Alpha MVP',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.primary,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Deliver core functionality for internal beta testing by end of quarter.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.neutral,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '68%',
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 0.68,
                    minHeight: 8,
                    backgroundColor: Colors.blue.withOpacity(0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF004D00)), // Very dark green
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Updated 2 days ago',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.neutral,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmartComponentCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Color borderColor,
    required String description,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: borderColor, width: 3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: iconColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.neutral,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeboundCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: AppColors.primary, width: 3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time_filled, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Time-bound',
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Target completion: September 30th. Key milestone review: August 15th.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.neutral,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            'Sep 30',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '45 Days Left',
                        style: AppTypography.labelMedium.copyWith(
                          color: Colors.red.shade800,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

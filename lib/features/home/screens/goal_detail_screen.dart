import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/goal_provider.dart';
import '../../../core/providers/task_provider.dart';
import '../../../core/models/task_model.dart';
import '../../../core/models/goal_model.dart';
import '../../../core/constants/app_constants.dart';

class GoalDetailScreen extends StatelessWidget {
  const GoalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goalProvider = context.watch<GoalProvider>();
    final taskProvider = context.watch<TaskProvider>();
    final currentGoal = goalProvider.currentGoal;

    if (currentGoal == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Goal Details',
            style: AppTypography.headlineMedium.copyWith(color: AppColors.primary),
          ),
        ),
        body: Center(
          child: Text(
            'No active goal found.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.neutral),
          ),
        ),
      );
    }

    final tasksForGoal = taskProvider.tasks.where((t) => t.goalId == currentGoal.id).toList();
    final totalTasks = tasksForGoal.length;
    final completedTasks = tasksForGoal.where((t) => t.status == TaskStatus.done).length;
    final double progress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;
    final int progressPercent = (progress * 100).round();

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
            child: GestureDetector(
              onTap: () => context.push(AppRoutes.profile),
              child: Builder(
                builder: (context) {
                  final authProvider = context.watch<AuthProvider>();
                  return CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    backgroundImage: authProvider.user?.photoURL != null && authProvider.user!.photoURL!.isNotEmpty
                        ? NetworkImage(authProvider.user!.photoURL!)
                        : null,
                    child: authProvider.user?.photoURL == null || authProvider.user!.photoURL!.isEmpty
                        ? const Icon(Icons.person, size: 20, color: AppColors.primary)
                        : null,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Main Objective Card
            _buildMainCard(context, currentGoal, progress, progressPercent, tasksForGoal),
            const SizedBox(height: 16),
            
            // SMART Specific
            _buildSmartComponentCard(
              icon: Icons.track_changes,
              iconColor: AppColors.primary,
              title: 'Specific',
              borderColor: AppColors.primary.withOpacity(0.5),
              description: currentGoal.specific.isNotEmpty ? currentGoal.specific : 'Not specified.',
            ),
            const SizedBox(height: 12),
            
            // SMART Measurable
            _buildSmartComponentCard(
              icon: Icons.bar_chart,
              iconColor: AppColors.tertiary,
              title: 'Measurable',
              borderColor: AppColors.tertiary,
              description: currentGoal.measurable.isNotEmpty ? currentGoal.measurable : 'Not specified.',
            ),
            const SizedBox(height: 12),
            
            // SMART Achievable
            _buildSmartComponentCard(
              icon: Icons.check_circle,
              iconColor: AppColors.secondary,
              title: 'Achievable',
              borderColor: AppColors.secondary,
              description: currentGoal.achievable.isNotEmpty ? currentGoal.achievable : 'Not specified.',
            ),
            const SizedBox(height: 12),
            
            // SMART Relevant
            _buildSmartComponentCard(
              icon: Icons.link,
              iconColor: Colors.purple.shade300,
              title: 'Relevant',
              borderColor: Colors.purple.shade200,
              description: currentGoal.relevant.isNotEmpty ? currentGoal.relevant : 'Not specified.',
            ),
            const SizedBox(height: 12),
            
            // SMART Time-bound
            _buildTimeboundCard(currentGoal.timebound),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard(BuildContext context, GoalModel goal, double progress, int progressPercent, List<TaskModel> tasks) {
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
                        'CURRENT GOAL',
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
                  goal.primaryObjective,
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.primary,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Track your progress systematically.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.neutral,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Progress Section (Clickable)
                GestureDetector(
                  onTap: () => _showLinkedTasksBottomSheet(context, tasks),
                  child: Container(
                    color: Colors.transparent, // Ensure gesture detector works on whole area
                    child: Column(
                      children: [
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
                              '$progressPercent%',
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
                            value: progress,
                            minHeight: 8,
                            backgroundColor: Colors.blue.withOpacity(0.15),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF004D00)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'View Linked Tasks',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: 11,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildTimeboundCard(DateTime? timebound) {
    final hasDate = timebound != null;
    final dateStr = hasDate ? DateFormat('MMM dd, yyyy').format(timebound) : 'Not specified';
    final daysLeft = hasDate ? timebound.difference(DateTime.now()).inDays : 0;
    final daysStr = daysLeft > 0 ? '$daysLeft Days Left' : (hasDate ? 'Overdue' : '-');

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
                          const Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            dateStr,
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
                    if (hasDate)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: daysLeft > 0 ? Colors.red.shade50 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          daysStr,
                          style: AppTypography.labelMedium.copyWith(
                            color: daysLeft > 0 ? Colors.red.shade800 : AppColors.neutral,
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

  void _showLinkedTasksBottomSheet(BuildContext context, List<TaskModel> tasks) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Linked Tasks',
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.primary,
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${tasks.length}',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              Expanded(
                child: tasks.isEmpty
                    ? Center(
                        child: Text(
                          'No tasks linked to this goal yet.',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.neutral),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: tasks.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          final isDone = task.status == TaskStatus.done;
                          return _buildTaskItem(
                            title: task.title,
                            subtitleIcon: Icons.calendar_today,
                            subtitleText: task.deadline != null
                                ? DateFormat('MMM dd, yyyy - hh:mm a').format(task.deadline!)
                                : (task.subtitle ?? 'No deadline'),
                            subtitleColor: isDone ? Colors.green.shade600 : AppColors.neutral,
                            tagText: task.status.name.toUpperCase(),
                            borderColor: isDone ? Colors.green.shade600 : task.leftBorderColor,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
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
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: borderColor, width: 3)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
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
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
}

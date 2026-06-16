import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/goal_provider.dart';
import '../../../core/providers/task_provider.dart';
import '../../../core/models/task_model.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final goalProvider = context.watch<GoalProvider>();
    final taskProvider = context.watch<TaskProvider>();
    final userName = authProvider.user?.displayName?.split(' ').first ?? 'User';

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
            child: GestureDetector(
              onTap: () => context.push(AppRoutes.profile),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                backgroundImage: authProvider.user?.photoURL != null && authProvider.user!.photoURL!.isNotEmpty 
                    ? NetworkImage(authProvider.user!.photoURL!) 
                    : null,
                child: authProvider.user?.photoURL == null || authProvider.user!.photoURL!.isEmpty 
                    ? const Icon(Icons.person, size: 20, color: AppColors.primary)
                    : null,
              ),
            ),
          ),
        ),
        // actions removed per user request
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
              'Good morning, $userName. Let\'s focus.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.neutral,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // Active Goal Card
            if (goalProvider.hasGoal)
              _buildActiveGoalCard(context, goalProvider, taskProvider)
            else
              _buildNoGoalCard(context),
            const SizedBox(height: 16),

            // Add New Goal Button
            _buildAddGoalButton(context),
            const SizedBox(height: 24),

            // Focus Flow Section
            _buildFocusFlowCard(context, taskProvider),
            const SizedBox(height: 24),

            // Momentum Section
            _buildMomentumSection(taskProvider),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNoGoalCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const Icon(Icons.flag_outlined, size: 48, color: AppColors.neutral),
          const SizedBox(height: 16),
          Text(
            'No Active Goal',
            style: AppTypography.headlineMedium.copyWith(color: AppColors.primary, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Set your primary goal to start tracking progress.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.neutral, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveGoalCard(BuildContext context, GoalProvider goalProvider, TaskProvider taskProvider) {
    final currentGoal = goalProvider.currentGoal;
    
    // Calculate dynamic progress
    final tasksForGoal = taskProvider.tasks.where((t) => t.goalId == currentGoal?.id).toList();
    final totalTasks = tasksForGoal.length;
    final completedTasks = tasksForGoal.where((t) => t.status == TaskStatus.done).length;
    final double progress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;
    final int progressPercent = (progress * 100).round();

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
            color: Colors.black.withValues(alpha: 0.02),
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
                        color: AppColors.secondary.withValues(alpha: 0.15),
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
                    if (currentGoal?.timebound != null)
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
                          '${currentGoal!.timebound!.difference(DateTime.now()).inDays}d left',
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
                  goalProvider.currentGoal?.primaryObjective ?? 'My Primary Goal',
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
                GestureDetector(
                  onTap: () => _showLinkedTasksBottomSheet(context, tasksForGoal),
                  child: Container(
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
                            '$progressPercent%',
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
                            value: progress,
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
                ),
              ],
            ),
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
                        color: AppColors.primary.withValues(alpha: 0.1),
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
          color: AppColors.primary.withValues(alpha: 0.3),
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

  Widget _buildFocusFlowCard(BuildContext context, TaskProvider taskProvider) {
    final tasks = taskProvider.inProgressTasks.toList();
    // Filter tasks that have a deadline
    final deadlineTasks = tasks.where((t) => t.deadline != null).toList();
    // Sort ascending by deadline (closest first)
    deadlineTasks.sort((a, b) => a.deadline!.compareTo(b.deadline!));
    final displayTasks = deadlineTasks.take(3).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
              GestureDetector(
                onTap: () {
                  context.go(AppRoutes.tasks);
                },
                child: Text(
                  'View All',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (displayTasks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  'No tasks in progress.',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.neutral),
                ),
              ),
            )
          else
            ...displayTasks.map((task) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildTaskItem(
                    title: task.title,
                    subtitleIcon: task.subtitleIcon ?? Icons.access_time,
                    subtitleText: task.deadline != null 
                        ? DateFormat('MMM dd, yyyy - hh:mm a').format(task.deadline!) 
                        : (task.subtitle ?? 'No deadline'),
                    subtitleColor: task.subtitleColor ?? AppColors.neutral,
                    tagText: task.tagLabel ?? task.priorityLabel,
                    borderColor: task.leftBorderColor,
                  ),
                )),
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

  Widget _buildMomentumSection(TaskProvider taskProvider) {
    final allTasks = taskProvider.tasks;
    final doneTasks = taskProvider.doneTasks;
    
    // 1. Tasks Completed
    final tasksCompleted = doneTasks.length;
    
    // 2. Focus Score Calculation (0-100)
    int focusScore = 0;
    if (allTasks.isNotEmpty) {
      final completionRate = doneTasks.length / allTasks.length;
      
      final allHighPriority = allTasks.where((t) => t.priorityLabel == 'Q1' || t.priorityLabel == 'Q2').toList();
      final doneHighPriority = doneTasks.where((t) => t.priorityLabel == 'Q1' || t.priorityLabel == 'Q2').toList();
      
      double highPriorityRate = 0;
      if (allHighPriority.isNotEmpty) {
        highPriorityRate = doneHighPriority.length / allHighPriority.length;
      } else {
        highPriorityRate = completionRate; // Default to completion rate if no high priority tasks
      }
      
      focusScore = ((completionRate * 60) + (highPriorityRate * 40)).round();
    }
    
    // 3. Deep Work Hours Estimation
    double deepWorkHours = 0;
    for (var task in doneTasks) {
      if (task.priorityLabel == 'Q1') {
        deepWorkHours += 2.0;
      } else if (task.priorityLabel == 'Q2') deepWorkHours += 1.5;
      else if (task.priorityLabel == 'Q3') deepWorkHours += 1.0;
      else deepWorkHours += 0.5; // Q4
    }
    
    final deepWorkStr = deepWorkHours == deepWorkHours.truncateToDouble() 
        ? deepWorkHours.toInt().toString() 
        : deepWorkHours.toStringAsFixed(1);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      focusScore.toString(),
                      style: AppTypography.headlineLarge.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.trending_up,
                  color: Colors.white.withValues(alpha: 0.5),
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
                        tasksCompleted.toString(),
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tasks Completed',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary.withValues(alpha: 0.8),
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
                        '${deepWorkStr}h',
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Deep Work',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary.withValues(alpha: 0.8),
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

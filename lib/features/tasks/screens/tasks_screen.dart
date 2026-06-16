import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/task_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/models/task_model.dart';
import 'create_task_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _searchQuery = '';

  bool _matchesQuery(TaskModel task) {
    if (_searchQuery.isEmpty) return true;

    final formattedDeadline = task.deadline != null
        ? DateFormat('MMM dd, yyyy - hh:mm a').format(task.deadline!).toLowerCase()
        : '';

    final haystacks = <String>[
      task.title,
      task.subtitle ?? '',
      task.tagLabel ?? '',
      task.priorityLabel,
      formattedDeadline,
    ];

    return haystacks.any((value) => value.toLowerCase().contains(_searchQuery));
  }

  bool _isOverdue(TaskModel task) {
    return task.deadline != null && task.status != TaskStatus.done && task.deadline!.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Tasks',
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.primary,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage and prioritize your workflow.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.neutral,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            // Search Bar
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value.trim().toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Search tasks...',
                  hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.neutral.withValues(alpha: 0.5)),
                  prefixIcon: Icon(Icons.search, color: AppColors.neutral.withValues(alpha: 0.5)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Info Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.neutral,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        children: const [
                          TextSpan(text: 'Tasks added here are automatically sorted onto your '),
                          TextSpan(
                            text: 'Priority Board',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                          TextSpan(text: ' based on urgency and impact.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Provider Injection
            Consumer<TaskProvider>(
              builder: (context, provider, child) {
                final filteredTodo = provider.todoTasks.where(_matchesQuery).toList();
                final filteredInProgress = provider.inProgressTasks.where(_matchesQuery).toList();
                final filteredDone = provider.doneTasks.where(_matchesQuery).toList();
                final filteredTasks = <TaskModel>[...filteredTodo, ...filteredInProgress, ...filteredDone];
                final overdueCount = provider.tasks.where(_isOverdue).length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsRow(provider: provider, overdueCount: overdueCount),
                    const SizedBox(height: 24),
                    if (provider.isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (provider.tasks.isEmpty)
                      _buildEmptyState(
                        icon: Icons.task_alt,
                        title: 'No tasks yet',
                        description: 'Create your first task to start organizing the day.',
                      )
                    else if (filteredTasks.isEmpty)
                      _buildEmptyState(
                        icon: Icons.search_off,
                        title: 'No matches found',
                        description: 'Try a different keyword or clear the search.',
                      )
                    else ...[
                      if (filteredTodo.isNotEmpty) ...[
                        _buildCategoryHeader('TODO', filteredTodo.length, Colors.grey.shade600),
                        const SizedBox(height: 16),
                        ...filteredTodo.map((task) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: _buildSlidableTaskCard(task: task, provider: provider),
                            )),
                        const SizedBox(height: 32),
                      ],
                      if (filteredInProgress.isNotEmpty) ...[
                        _buildCategoryHeader('IN PROGRESS', filteredInProgress.length, AppColors.primary),
                        const SizedBox(height: 16),
                        ...filteredInProgress.map((task) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: _buildSlidableTaskCard(task: task, provider: provider),
                            )),
                        const SizedBox(height: 32),
                      ],
                      if (filteredDone.isNotEmpty) ...[
                        _buildCategoryHeader('DONE', filteredDone.length, Colors.grey.shade500),
                        const SizedBox(height: 16),
                        ...filteredDone.map((task) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: _buildDoneTaskCard(task: task, provider: provider),
                            )),
                        const SizedBox(height: 40),
                      ],
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => CreateTaskSheet.show(context),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildStatsRow({
    required TaskProvider provider,
    required int overdueCount,
  }) {
    final openCount = provider.todoTasks.length + provider.inProgressTasks.length;

    return Row(
      children: [
        Expanded(
          child: _buildStatChip(
            label: 'Open',
            value: openCount.toString(),
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatChip(
            label: 'Overdue',
            value: overdueCount.toString(),
            color: Colors.red.shade600,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatChip(
            label: 'Done',
            value: provider.doneTasks.length.toString(),
            color: Colors.green.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTypography.headlineMedium.copyWith(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.neutral,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.primary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.neutral,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return AppBar(
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
    );
  }

  Widget _buildCategoryHeader(String title, int count, Color bulletColor) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: bulletColor, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.neutral,
            fontWeight: FontWeight.w600,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
        if (count > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTaskCard({
    required String title,
    required IconData subtitleIcon,
    required String subtitleText,
    required Color subtitleColor,
    String? tagLabel,
    bool avatars = false,
    bool isOverdue = false,
    required String priorityLabel,
    required Color priorityColor,
    required Color leftBorderColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: leftBorderColor, width: 4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(subtitleIcon, size: 14, color: subtitleColor),
                              const SizedBox(width: 4),
                              Text(
                                subtitleText,
                                style: AppTypography.labelMedium.copyWith(
                                  color: subtitleColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          if (tagLabel != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                tagLabel,
                                style: AppTypography.labelMedium.copyWith(
                                  color: AppColors.neutral,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          if (avatars)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  widthFactor: 0.75,
                                  child: CircleAvatar(radius: 8, backgroundColor: AppColors.primary.withValues(alpha: 0.2), child: const Icon(Icons.person, size: 10, color: AppColors.primary)),
                                ),
                                const CircleAvatar(radius: 8, backgroundColor: AppColors.tertiary, child: Icon(Icons.person, size: 10, color: Colors.white)),
                              ],
                            ),
                          if (isOverdue)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Text(
                                'OVERDUE',
                                style: AppTypography.labelMedium.copyWith(
                                  color: Colors.red.shade700,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (priorityLabel.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      priorityLabel,
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
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

  Widget _buildSlidableTaskCard({
    required TaskModel task,
    required TaskProvider provider,
  }) {
    final innerCard = _buildTaskCard(
      title: task.title,
      subtitleIcon: task.subtitleIcon ?? Icons.access_time,
      subtitleText: task.deadline != null 
          ? DateFormat('MMM dd, yyyy - hh:mm a').format(task.deadline!) 
          : (task.subtitle ?? ''),
      subtitleColor: task.subtitleColor ?? AppColors.neutral,
      tagLabel: task.tagLabel,
      avatars: task.hasAvatars,
      isOverdue: _isOverdue(task),
      priorityLabel: task.priorityLabel,
      priorityColor: task.priorityColor,
      leftBorderColor: task.leftBorderColor,
    );

    final bool canProgress = task.status != TaskStatus.done;
    final TaskStatus nextStatus = task.status == TaskStatus.todo ? TaskStatus.inProgress : TaskStatus.done;

    final bool isTodo = task.status == TaskStatus.todo;
    final TaskStatus regressStatus = task.status == TaskStatus.inProgress
      ? TaskStatus.todo
      : TaskStatus.inProgress;

    return Slidable(
      key: ValueKey(task.id),
      startActionPane: canProgress ? ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {
          provider.updateTaskStatus(task.id, nextStatus);
        }),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) {
              provider.updateTaskStatus(task.id, nextStatus);
            },
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            icon: Icons.check,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
          ),
        ],
      ) : null,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: isTodo ? null : DismissiblePane(onDismissed: () {
          provider.updateTaskStatus(task.id, regressStatus);
        }),
        extentRatio: 0.25,
        children: [
          if (isTodo)
            SlidableAction(
              onPressed: (context) {
                provider.deleteTask(task.id);
              },
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              icon: Icons.delete_outline,
              borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
            )
          else
            SlidableAction(
              onPressed: (context) {
                provider.updateTaskStatus(task.id, regressStatus);
              },
              backgroundColor: Colors.orange.shade600,
              foregroundColor: Colors.white,
              icon: Icons.undo,
              borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
            ),
        ],
      ),
      child: innerCard,
    );
  }

  Widget _buildDoneTaskCard({
    required TaskModel task,
    required TaskProvider provider,
  }) {
    final innerCard = Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.grey, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.title,
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.grey.shade400,
                  decoration: TextDecoration.lineThrough,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Slidable(
      key: ValueKey(task.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {
          provider.updateTaskStatus(task.id, TaskStatus.inProgress);
        }),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) {
              provider.updateTaskStatus(task.id, TaskStatus.inProgress);
            },
            backgroundColor: Colors.orange.shade600,
            foregroundColor: Colors.white,
            icon: Icons.undo,
            borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
          ),
        ],
      ),
      child: innerCard,
    );
  }
}

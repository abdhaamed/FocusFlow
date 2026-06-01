import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/main_bottom_nav.dart';
import '../../../core/providers/task_provider.dart';
import '../../../core/models/task_model.dart';

// ── Data Model ─────────────────────────────────────────────────────────────────

enum Quadrant { doItNow, schedule, delegate, drop }

// ── Screen ────────────────────────────────────────────────────────────────────

class PriorityBoardScreen extends StatefulWidget {
  const PriorityBoardScreen({super.key});

  @override
  State<PriorityBoardScreen> createState() => _PriorityBoardScreenState();
}

class _PriorityBoardScreenState extends State<PriorityBoardScreen> {
  bool isGridActive = true;

  Quadrant _mapLabelToQuadrant(String label) {
    switch (label) {
      case 'Q1': return Quadrant.doItNow;
      case 'Q2': return Quadrant.schedule;
      case 'Q3': return Quadrant.delegate;
      case 'Q4': return Quadrant.drop;
      default: return Quadrant.drop; // Fallback for no-label tasks
    }
  }

  String _mapQuadrantToLabel(Quadrant quadrant) {
    switch (quadrant) {
      case Quadrant.doItNow: return 'Q1';
      case Quadrant.schedule: return 'Q2';
      case Quadrant.delegate: return 'Q3';
      case Quadrant.drop: return 'Q4';
    }
  }

  List<TaskModel> _tasksFor(List<TaskModel> tasks, Quadrant q) {
    return tasks.where((t) => _mapLabelToQuadrant(t.priorityLabel) == q).toList();
  }

  void _moveTask(TaskModel task, Quadrant target) {
    final taskProvider = context.read<TaskProvider>();
    final newLabel = _mapQuadrantToLabel(target);
    taskProvider.updateTaskPriority(task.id, newLabel);
  }

  void _toggleDone(TaskModel task) {
    final taskProvider = context.read<TaskProvider>();
    final newStatus = task.status == TaskStatus.done ? TaskStatus.todo : TaskStatus.done;
    taskProvider.updateTaskStatus(task.id, newStatus);
  }

  // ── Quadrant config ─────────────────────────────────────────────────────────

  _QuadrantConfig _config(Quadrant q) {
    switch (q) {
      case Quadrant.doItNow:
        return _QuadrantConfig(
          title: 'Do It Now',
          icon: Icons.warning_amber_rounded,
          iconColor: Colors.red.shade900,
          badgeText: 'Urgent & Important',
          badgeColor: Colors.red.shade50,
          badgeTextColor: Colors.red.shade700,
          containerColor: Colors.red.shade50.withOpacity(0.5),
          borderColor: Colors.red.shade100,
          leftBorderColor: Colors.red.shade700,
          titleColor: AppColors.primary,
        );
      case Quadrant.schedule:
        return _QuadrantConfig(
          title: 'Schedule',
          icon: Icons.calendar_month,
          iconColor: AppColors.primary,
          badgeText: 'Not Urgent & Important',
          badgeColor: AppColors.primary.withOpacity(0.1),
          badgeTextColor: AppColors.primary,
          containerColor: AppColors.primary.withOpacity(0.03),
          borderColor: AppColors.primary.withOpacity(0.15),
          leftBorderColor: AppColors.primary,
          titleColor: AppColors.primary,
        );
      case Quadrant.delegate:
        return _QuadrantConfig(
          title: 'Delegate',
          icon: Icons.move_to_inbox,
          iconColor: AppColors.primary,
          badgeText: 'Urgent & Not Important',
          badgeColor: AppColors.primary.withOpacity(0.15),
          badgeTextColor: AppColors.primary,
          containerColor: AppColors.primary.withOpacity(0.04),
          borderColor: AppColors.primary.withOpacity(0.15),
          leftBorderColor: AppColors.primary,
          titleColor: AppColors.primary,
        );
      case Quadrant.drop:
        return _QuadrantConfig(
          title: 'Drop',
          icon: Icons.delete_outline,
          iconColor: AppColors.neutral.withOpacity(0.6),
          badgeText: 'Not Urgent & Not Important',
          badgeColor: AppColors.primary.withOpacity(0.05),
          badgeTextColor: AppColors.neutral.withOpacity(0.6),
          containerColor: Colors.grey.shade50,
          borderColor: Colors.grey.shade200,
          leftBorderColor: Colors.grey.shade300,
          titleColor: AppColors.neutral.withOpacity(0.6),
        );
    }
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final allTasks = taskProvider.tasks;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: taskProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Priority Board',
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Eisenhower Matrix',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.neutral,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildToggleButton(),
                  const SizedBox(height: 24),

                  // Four quadrants
                  for (final q in Quadrant.values) ...[
                    _buildQuadrantSection(q, allTasks),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
      bottomNavigationBar: const MainBottomNav(currentIndex: 2),
    );
  }

  // ── Quadrant section with DragTarget ──────────────────────────────────────

  Widget _buildQuadrantSection(Quadrant quadrant, List<TaskModel> allTasks) {
    final cfg = _config(quadrant);
    final tasks = _tasksFor(allTasks, quadrant);

    return DragTarget<TaskModel>(
      onWillAcceptWithDetails: (details) => _mapLabelToQuadrant(details.data.priorityLabel) != quadrant,
      onAcceptWithDetails: (details) => _moveTask(details.data, quadrant),
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isHovering
                ? cfg.containerColor.withOpacity(0.85)
                : cfg.containerColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHovering
                  ? cfg.leftBorderColor.withOpacity(0.6)
                  : cfg.borderColor,
              width: isHovering ? 2.0 : 1.5,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Icon(cfg.icon, color: cfg.iconColor, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    cfg.title,
                    style: AppTypography.headlineMedium.copyWith(
                      color: cfg.titleColor,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: cfg.badgeColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      cfg.badgeText,
                      style: AppTypography.labelMedium.copyWith(
                        color: cfg.badgeTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Drop-here hint when hovering
              if (isHovering && tasks.isEmpty)
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: cfg.leftBorderColor.withOpacity(0.4),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: cfg.leftBorderColor.withOpacity(0.06),
                  ),
                  child: Center(
                    child: Text(
                      'Drop here',
                      style: AppTypography.labelMedium.copyWith(
                        color: cfg.leftBorderColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

              // Task cards — each is Draggable
              ...tasks.map(
                (task) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildDraggableTask(task, cfg),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Draggable task card ───────────────────────────────────────────────────

  Widget _buildDraggableTask(TaskModel task, _QuadrantConfig cfg) {
    final card = _TaskCard(
      task: task,
      cfg: cfg,
      onToggleDone: () => _toggleDone(task),
    );

    return LongPressDraggable<TaskModel>(
      data: task,
      delay: const Duration(milliseconds: 300),
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.85,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 72,
            child: _TaskCard(task: task, cfg: cfg, onToggleDone: () {}),
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.35, child: card),
      child: card,
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
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
          child: CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: const Icon(Icons.person, size: 20, color: AppColors.primary),
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
    );
  }

  // ── Toggle button ─────────────────────────────────────────────────────────

  Widget _buildToggleButton() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleChip(
            label: 'Grid',
            icon: Icons.grid_view,
            active: isGridActive,
            onTap: () => setState(() => isGridActive = true),
          ),
          _toggleChip(
            label: 'List',
            icon: Icons.format_list_bulleted,
            active: !isGridActive,
            onTap: () => setState(() => isGridActive = false),
          ),
        ],
      ),
    );
  }

  Widget _toggleChip({
    required String label,
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: active ? Colors.white : AppColors.neutral,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: active ? Colors.white : AppColors.neutral,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Quadrant config data object ───────────────────────────────────────────────

class _QuadrantConfig {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;
  final Color containerColor;
  final Color borderColor;
  final Color leftBorderColor;
  final Color titleColor;

  const _QuadrantConfig({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.containerColor,
    required this.borderColor,
    required this.leftBorderColor,
    required this.titleColor,
  });
}

// ── Task card widget ──────────────────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final TaskModel task;
  final _QuadrantConfig cfg;
  final VoidCallback onToggleDone;

  const _TaskCard({
    required this.task,
    required this.cfg,
    required this.onToggleDone,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = task.priorityLabel == 'Q4';
    final isDone = task.status == TaskStatus.done;

    final titleStyle = AppTypography.bodyMedium.copyWith(
      color: isDone
          ? AppColors.neutral.withOpacity(0.5)
          : isDisabled
          ? AppColors.neutral.withOpacity(0.7)
          : AppColors.primary,
      fontWeight: FontWeight.w600,
      fontSize: 14,
      decoration: isDone ? TextDecoration.lineThrough : null,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: task.leftBorderColor, width: 4),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Drag handle
              Icon(Icons.drag_indicator, color: Colors.grey.shade300, size: 20),
              const SizedBox(width: 8),

              // Title + meta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.title, style: titleStyle),
                    if (task.subtitle != null ||
                        task.tagLabel != null ||
                        task.hasAvatars) ...[
                      const SizedBox(height: 6),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          // Subtitle with icon
                          if (task.subtitle != null && task.subtitleIcon != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  task.subtitleIcon,
                                  size: 12,
                                  color: AppColors.neutral,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  task.subtitle!,
                                  style: AppTypography.labelMedium.copyWith(
                                    color: AppColors.neutral,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          // Subtitle plain text
                          if (task.subtitle != null && task.subtitleIcon == null)
                            Text(
                              task.subtitle!,
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.neutral.withOpacity(0.7),
                                fontSize: 11,
                              ),
                            ),
                          // Dot separator
                          if (task.subtitle != null && task.tagLabel != null)
                            Container(
                              width: 3,
                              height: 3,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                          // Tag badge
                          if (task.tagLabel != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: task.priorityColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: task.priorityColor.withOpacity(0.2),
                                ),
                              ),
                              child: Text(
                                task.tagLabel!,
                                style: AppTypography.labelMedium.copyWith(
                                  color: task.priorityColor,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          // Avatar label
                          if (task.hasAvatars)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.orange.shade200,
                                  child: const Icon(
                                    Icons.person,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Assigned',
                                  style: AppTypography.labelMedium.copyWith(
                                    color: AppColors.neutral,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // ── Checkbox circle ──────────────────────────────────────────
              GestureDetector(
                onTap: onToggleDone,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? cfg.leftBorderColor
                        : Colors.transparent,
                    border: Border.all(
                      color: isDone
                          ? cfg.leftBorderColor
                          : Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
                  child: isDone
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


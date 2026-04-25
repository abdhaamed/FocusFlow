import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/main_bottom_nav.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/task_provider.dart';
import 'create_task_screen.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
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

            // Search and Filter Bar
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search tasks...',
                        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.neutral.withOpacity(0.5)),
                        prefixIcon: Icon(Icons.search, color: AppColors.neutral.withOpacity(0.5)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Center(
                    child: Icon(Icons.filter_list, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Info Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TODO Section
                    _buildCategoryHeader('TODO', provider.todoTasks.length, Colors.grey.shade600),
                    const SizedBox(height: 16),
                    ...provider.todoTasks.map((task) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildSlidableTaskCard(
                            title: task.title,
                            subtitleIcon: task.subtitleIcon ?? Icons.access_time, // Fallback
                            subtitleText: task.subtitle ?? '',
                            subtitleColor: task.subtitleColor ?? AppColors.neutral,
                            tagLabel: task.tagLabel,
                            avatars: task.hasAvatars,
                            priorityLabel: task.priorityLabel,
                            priorityColor: task.priorityColor,
                            leftBorderColor: task.leftBorderColor,
                          ),
                        )),
                    const SizedBox(height: 32),

                    // IN PROGRESS Section
                    _buildCategoryHeader('IN PROGRESS', provider.inProgressTasks.length, AppColors.primary),
                    const SizedBox(height: 16),
                    ...provider.inProgressTasks.map((task) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildSlidableTaskCard(
                            title: task.title,
                            subtitleIcon: task.subtitleIcon ?? Icons.access_time,
                            subtitleText: task.subtitle ?? '',
                            subtitleColor: task.subtitleColor ?? AppColors.neutral,
                            tagLabel: task.tagLabel,
                            avatars: task.hasAvatars,
                            priorityLabel: task.priorityLabel,
                            priorityColor: task.priorityColor,
                            leftBorderColor: task.leftBorderColor,
                          ),
                        )),
                    const SizedBox(height: 32),

                    // DONE Section
                    _buildCategoryHeader('DONE', provider.doneTasks.length, Colors.grey.shade500),
                    const SizedBox(height: 16),
                    ...provider.doneTasks.map((task) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildDoneTaskCard(task.title),
                        )),
                    const SizedBox(height: 40), // Padding for FAB
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
      bottomNavigationBar: const MainBottomNav(currentIndex: 1),
    );
  }

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
                const Icon(Icons.notifications_none, color: AppColors.primary, size: 28),
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
              color: AppColors.primary.withOpacity(0.15),
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
            color: Colors.black.withOpacity(0.02),
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
                                  child: CircleAvatar(radius: 8, backgroundColor: AppColors.primary.withOpacity(0.2), child: const Icon(Icons.person, size: 10, color: AppColors.primary)),
                                ),
                                const CircleAvatar(radius: 8, backgroundColor: AppColors.tertiary, child: Icon(Icons.person, size: 10, color: Colors.white)),
                              ],
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

  // To simulate the exact layout from the image which shows items mid-swipe.
  Widget _buildSlidableTaskCard({
    required String title,
    required IconData subtitleIcon,
    required String subtitleText,
    required Color subtitleColor,
    String? tagLabel,
    bool avatars = false,
    required String priorityLabel,
    required Color priorityColor,
    required Color leftBorderColor,
  }) {
    final innerCard = _buildTaskCard(
      title: title,
      subtitleIcon: subtitleIcon,
      subtitleText: subtitleText,
      subtitleColor: subtitleColor,
      tagLabel: tagLabel,
      avatars: avatars,
      priorityLabel: priorityLabel,
      priorityColor: priorityColor,
      leftBorderColor: leftBorderColor,
    );

    // Using real Slidable to make it actually work!
    return Slidable(
      key: ValueKey(title),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) {},
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            icon: Icons.check,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) {},
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
          ),
        ],
      ),
      child: innerCard,
    );
  }

  Widget _buildDoneTaskCard(String title) {
    return Container(
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
                title,
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.grey.shade400,
                  decoration: TextDecoration.lineThrough,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

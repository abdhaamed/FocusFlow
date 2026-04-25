import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/providers/task_provider.dart';
import '../../../core/models/task_model.dart';

/// Call this static method from anywhere to show the Create Task bottom sheet.
class CreateTaskSheet extends StatefulWidget {
  const CreateTaskSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<TaskProvider>(),
        child: const CreateTaskSheet(),
      ),
    );
  }

  @override
  State<CreateTaskSheet> createState() => _CreateTaskSheetState();
}

class _CreateTaskSheetState extends State<CreateTaskSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deadlineController = TextEditingController();

  double _urgency = 5.0;
  double _importance = 4.0;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  void _createTask() {
    if (_titleController.text.trim().isEmpty) return;

    final newTask = TaskModel.create(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      deadline: _deadlineController.text.trim(),
      urgency: _urgency,
      importance: _importance,
    );

    context.read<TaskProvider>().addTask(newTask);
    Navigator.of(context).pop();
  }

  // ── Computed Placement ──────────────────────────────────────────────────────
  bool get _isDoItNow => _urgency >= 4 && _importance >= 4;
  bool get _isSchedule => _urgency < 4 && _importance >= 4;
  bool get _isDelegate => _urgency >= 4 && _importance < 4;

  String get _placementTitle {
    if (_isDoItNow) return 'Do It Now (Q1)';
    if (_isSchedule) return 'Schedule (Q2)';
    if (_isDelegate) return 'Delegate (Q3)';
    return 'Drop (Q4)';
  }

  String get _placementDescription {
    if (_isDoItNow) return 'It is both urgent and important.';
    if (_isSchedule) return 'It is important but not urgent.';
    if (_isDelegate) return 'It is urgent but not important.';
    return 'It is neither urgent nor important.';
  }

  Color get _placementColor {
    if (_isDoItNow) return const Color(0xFFB91C1C);
    if (_isSchedule) return AppColors.primary;
    if (_isDelegate) return AppColors.primary;
    return AppColors.neutral;
  }

  Color get _placementBgColor {
    if (_isDoItNow) return const Color(0xFFFEF2F2);
    return const Color(0xFFF8FAFC);
  }

  Color get _placementBorderColor {
    if (_isDoItNow) return const Color(0xFFFCA5A5);
    return Colors.grey.shade200;
  }

  IconData get _placementIcon {
    if (_isDoItNow) return Icons.local_fire_department_rounded;
    if (_isSchedule) return Icons.calendar_month;
    if (_isDelegate) return Icons.move_to_inbox;
    return Icons.delete_outline;
  }

  // ── Badge helpers ──────────────────────────────────────────────────────────
  String _badgeText(double v) {
    if (v >= 4) return 'High';
    if (v >= 2.5) return 'Medium';
    return 'Low';
  }

  Color _urgencyBadgeBg(double v) {
    if (v >= 4) return const Color(0xFFFEE2E2);
    if (v >= 2.5) return const Color(0xFFFEF3C7);
    return const Color(0xFFEFF6FF);
  }

  Color _urgencyBadgeFg(double v) {
    if (v >= 4) return const Color(0xFFB91C1C);
    if (v >= 2.5) return const Color(0xFF92400E);
    return AppColors.primary;
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.94;

    return Container(
      height: maxH,
      decoration: const BoxDecoration(
        color: Color(0xFFF4F6FB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // ── drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ── App‑bar row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.primary, size: 24),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Create New Task',
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.primary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // balance close button
              ],
            ),
          ),

          // ── Scrollable body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Form card ──────────────────────────────────────────────
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Task Title'),
                        _field(
                          hint: 'e.g. Prepare Q3 Financial Report',
                          controller: _titleController,
                        ),
                        const SizedBox(height: 18),
                        _label('Description (Optional)'),
                        _field(
                          hint: 'Add details or context here...',
                          controller: _descriptionController,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 18),
                        _label('Deadline'),
                        _deadlineField(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Matrix Assessment header
                  Text(
                    'Matrix Assessment',
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Sliders card
                  _card(
                    child: Column(
                      children: [
                        _sliderRow(
                          icon: Icons.timer_outlined,
                          iconColor: const Color(0xFFB91C1C),
                          title: 'Urgency',
                          value: _urgency,
                          badgeBg: _urgencyBadgeBg(_urgency),
                          badgeFg: _urgencyBadgeFg(_urgency),
                          badgeText: '${_badgeText(_urgency)} (${_urgency.toInt()}/5)',
                          onChanged: (v) => setState(() => _urgency = v),
                        ),
                        const SizedBox(height: 28),
                        _sliderRow(
                          icon: Icons.stars_rounded,
                          iconColor: AppColors.primary,
                          title: 'Importance',
                          value: _importance,
                          badgeBg: const Color(0xFFE0E7FF),
                          badgeFg: AppColors.primary,
                          badgeText: '${_badgeText(_importance)} (${_importance.toInt()}/5)',
                          onChanged: (v) => setState(() => _importance = v),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Predicted placement card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _placementBgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _placementBorderColor),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: _placementColor.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_placementIcon, color: _placementColor, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Predicted Placement',
                                style: AppTypography.headlineMedium.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.neutral,
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                  children: [
                                    const TextSpan(text: 'This task will be placed in: '),
                                    TextSpan(
                                      text: _placementTitle,
                                      style: TextStyle(
                                        color: _placementColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(text: '. $_placementDescription'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom action bar
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              12 + MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _createTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        'Create Task',
                        style: AppTypography.headlineMedium.copyWith(
                          color: Colors.white,
                          fontSize: 15,
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
    );
  }

  // ── Reusable helpers ───────────────────────────────────────────────────────

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.neutral,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _field({
    required String hint,
    TextEditingController? controller,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.primary,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.neutral.withOpacity(0.5),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  Widget _deadlineField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: _deadlineController,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.primary,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'mm/dd/yyyy, --:-- --',
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.neutral.withOpacity(0.5),
            fontSize: 14,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.calendar_today_outlined,
              color: AppColors.neutral.withOpacity(0.6),
              size: 18,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  Widget _sliderRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required double value,
    required Color badgeBg,
    required Color badgeFg,
    required String badgeText,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row
        Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badgeText,
                style: AppTypography.labelMedium.copyWith(
                  color: badgeFg,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary.withOpacity(0.25),
            inactiveTrackColor: Colors.grey.shade200,
            thumbColor: AppColors.primary,
            overlayColor: Colors.transparent,
            trackHeight: 4.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
          ),
          child: Slider(
            value: value,
            min: 1,
            max: 5,
            divisions: 4,
            onChanged: onChanged,
          ),
        ),

        // Low / High labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Low',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.neutral.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
              Text(
                'High',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.neutral.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

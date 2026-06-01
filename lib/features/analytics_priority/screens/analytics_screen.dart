import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/main_bottom_nav.dart';
import '../../../core/providers/task_provider.dart';
import '../../../core/models/task_model.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _progressAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final allTasks = taskProvider.tasks;

    int totalTasks = allTasks.length;
    int doneTasks = taskProvider.doneTasks.length;
    double progressRatio = totalTasks == 0 ? 0.0 : doneTasks / totalTasks;

    int q1 = 0, q2 = 0, q3 = 0, q4 = 0;
    for (var t in allTasks) {
      if (t.priorityLabel == 'Q1') q1++;
      else if (t.priorityLabel == 'Q2') q2++;
      else if (t.priorityLabel == 'Q3') q3++;
      else q4++;
    }

    double q1Pct = totalTasks == 0 ? 0.0 : q1 / totalTasks;
    double q2Pct = totalTasks == 0 ? 0.0 : q2 / totalTasks;
    double q3Pct = totalTasks == 0 ? 0.0 : q3 / totalTasks;
    double q4Pct = totalTasks == 0 ? 0.0 : q4 / totalTasks;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: taskProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Page header ──────────────────────────────────────────────────
                  Text(
                    'Analytics',
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your productivity insights for this week.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.neutral,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Card 1: OKR Progress ─────────────────────────────────────────
                  _OKRProgressCard(
                    progressAnim: _progressAnim,
                    progressRatio: progressRatio,
                    totalTasks: totalTasks,
                    doneTasks: doneTasks,
                  ),
                  const SizedBox(height: 16),

                  // ── Card 2: Weekly Briefing ──────────────────────────────────────
                  _weeklyBriefingCard(q1, totalTasks, q1Pct),
                  const SizedBox(height: 16),

                  // ── Card 3: Eisenhower Distribution ─────────────────────────────
                  _eisenhowerCard(q1Pct, q2Pct, q3Pct, q4Pct),
                  const SizedBox(height: 16),

                  // ── Card 4: Activity Heatmap ─────────────────────────────────────
                  _activityCard(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
      bottomNavigationBar: const MainBottomNav(currentIndex: 3),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
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
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: GestureDetector(
            onTap: () => context.push(AppRoutes.profile),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: const Icon(Icons.person, size: 20, color: AppColors.primary),
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.notifications_none,
                  color: AppColors.primary, size: 28),
              Positioned(
                right: 4,
                top: 10,
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
      ],
    );
  }

  // ── Weekly Briefing Card (dark) ────────────────────────────────────────────
  Widget _weeklyBriefingCard(int q1Count, int totalTasks, double q1Pct) {
    String q1Desc = 'Excellent management of Urgent & Important tasks.';
    if (q1Pct > 0.6) {
      q1Desc = 'You have a high volume of Urgent tasks. Consider delegating more to Q3.';
    } else if (q1Pct < 0.2 && totalTasks > 0) {
      q1Desc = 'Your urgent tasks are well under control. Great job!';
    } else if (totalTasks == 0) {
      q1Desc = 'Start adding tasks to see your insights here.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                'Weekly Briefing',
                style: AppTypography.headlineMedium.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Deep Work Hours
          _briefingStatRow(
            value: '$totalTasks',
            label: 'TOTAL TASKS',
            description: 'You have actively recorded $totalTasks tasks across your board.',
            valueColor: const Color(0xFF4ADE80),
          ),
          const SizedBox(height: 4),
          Divider(color: Colors.white.withOpacity(0.12), thickness: 1),
          const SizedBox(height: 4),

          // Q1 Completion
          _briefingStatRow(
            value: '${(q1Pct * 100).toInt()}%',
            label: 'Q1 DISTRIBUTION',
            description: q1Desc,
            valueColor: const Color(0xFF4ADE80),
          ),
        ],
      ),
    );
  }

  Widget _briefingStatRow({
    required String value,
    required String label,
    required String description,
    required Color valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTypography.headlineMedium.copyWith(
            color: valueColor,
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: Colors.white.withOpacity(0.6),
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: AppTypography.bodyMedium.copyWith(
            color: Colors.white.withOpacity(0.8),
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ── Eisenhower Distribution ────────────────────────────────────────────────
  Widget _eisenhowerCard(double q1, double q2, double q3, double q4) {
    return _surfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.pie_chart_outline,
                    color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                'Eisenhower Distribution',
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Ring chart + Legend
          Row(
            children: [
              // Ring chart
              SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(
                  painter: _RingChartPainter(
                    segments: [
                      _Segment(value: q1 == 0 && q2 == 0 && q3 == 0 && q4 == 0 ? 0.0 : q1, color: const Color(0xFFDC2626)), // Q1
                      _Segment(value: q1 == 0 && q2 == 0 && q3 == 0 && q4 == 0 ? 0.0 : q2, color: AppColors.primary), // Q2
                      _Segment(value: q1 == 0 && q2 == 0 && q3 == 0 && q4 == 0 ? 0.0 : q3, color: const Color(0xFF16A34A)), // Q3
                      _Segment(value: q1 == 0 && q2 == 0 && q3 == 0 && q4 == 0 ? 1.0 : q4, color: const Color(0xFFE5E7EB)), // Q4
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 28),

              // Legend
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _legendItem(
                      color: const Color(0xFFDC2626), label: 'Q1: ${(q1 * 100).toInt()}%'),
                  const SizedBox(height: 10),
                  _legendItem(
                      color: AppColors.primary, label: 'Q2: ${(q2 * 100).toInt()}%'),
                  const SizedBox(height: 10),
                  _legendItem(
                      color: const Color(0xFF16A34A), label: 'Q3: ${(q3 * 100).toInt()}%'),
                  const SizedBox(height: 10),
                  _legendItem(
                      color: const Color(0xFFE5E7EB), label: 'Q4: ${(q4 * 100).toInt()}%'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.primary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ── Activity Heatmap ───────────────────────────────────────────────────────
  Widget _activityCard() {
    return _surfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.calendar_today_outlined,
                    color: AppColors.primary, size: 17),
              ),
              const SizedBox(width: 12),
              Text(
                'Activity',
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              _yearChip(),
              const Spacer(),
              // Less / More legend
              Row(
                children: [
                  Text(
                    'Less',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.neutral.withOpacity(0.6),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 4),
                  ...[ 0.1, 0.3, 0.6, 1.0].map((op) => Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(op),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      )),
                  const SizedBox(width: 4),
                  Text(
                    'More',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.neutral.withOpacity(0.6),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Heatmap grid
          _HeatmapGrid(),
        ],
      ),
    );
  }

  Widget _yearChip() {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Text(
              '2024',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.arrow_drop_down,
                color: AppColors.primary, size: 16),
          ],
        ),
      ),
    );
  }

  // ── Shared surface card ───────────────────────────────────────────────────
  Widget _surfaceCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }
}

// ── OKR Progress Card ─────────────────────────────────────────────────────────

class _OKRProgressCard extends StatelessWidget {
  final Animation<double> progressAnim;
  final double progressRatio;
  final int totalTasks;
  final int doneTasks;
  const _OKRProgressCard({
    required this.progressAnim,
    required this.progressRatio,
    required this.totalTasks,
    required this.doneTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.flag_outlined,
                    color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task Completion',
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '$doneTasks out of $totalTasks Tasks',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.neutral.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Circular progress
          Center(
            child: AnimatedBuilder(
              animation: progressAnim,
              builder: (_, __) => SizedBox(
                width: 130,
                height: 130,
                child: CustomPaint(
                  painter: _CircleProgressPainter(
                    progress: progressAnim.value * progressRatio,
                    trackColor: const Color(0xFFE8EBF5),
                    progressColor: AppColors.primary,
                    strokeWidth: 10,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(progressAnim.value * progressRatio * 100).toInt()}%',
                          style: AppTypography.headlineMedium.copyWith(
                            color: AppColors.primary,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'Completed',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.neutral.withOpacity(0.6),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Linear progress bar below
          AnimatedBuilder(
            animation: progressAnim,
            builder: (_, __) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressAnim.value * progressRatio,
                minHeight: 6,
                backgroundColor: const Color(0xFFE8EBF5),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Heatmap Grid ──────────────────────────────────────────────────────────────

class _HeatmapGrid extends StatelessWidget {
  static final _rng = math.Random(42);
  static final List<List<double>> _data = List.generate(
    7,
    (_) => List.generate(18, (_) => _rng.nextDouble()),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(7, (row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: List.generate(18, (col) {
              final intensity = _data[row][col];
              Color cellColor;
              if (intensity < 0.15) {
                cellColor = const Color(0xFFEEF0F8);
              } else if (intensity < 0.40) {
                cellColor = AppColors.primary.withOpacity(0.2);
              } else if (intensity < 0.65) {
                cellColor = AppColors.primary.withOpacity(0.45);
              } else if (intensity < 0.85) {
                cellColor = AppColors.primary.withOpacity(0.70);
              } else {
                cellColor = AppColors.primary;
              }
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  height: 14,
                  decoration: BoxDecoration(
                    color: cellColor,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

// ── Custom Painters ───────────────────────────────────────────────────────────

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  const _CircleProgressPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -math.pi / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircleProgressPainter old) =>
      old.progress != progress;
}

// Ring chart for Eisenhower distribution
class _Segment {
  final double value;
  final Color color;
  const _Segment({required this.value, required this.color});
}

class _RingChartPainter extends CustomPainter {
  final List<_Segment> segments;
  const _RingChartPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 18.0;
    final innerRadius = radius - strokeWidth;

    double startAngle = -math.pi / 2;
    const gap = 0.04; // radian gap between segments

    for (final seg in segments) {
      if (seg.value == 0) continue; // Skip empty segments
      final sweep = 2 * math.pi * seg.value - gap;
      final paint = Paint()
        ..color = seg.color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle,
        sweep > 0 ? sweep : 0,
        false,
        paint,
      );
      startAngle += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(_RingChartPainter old) => false;
}


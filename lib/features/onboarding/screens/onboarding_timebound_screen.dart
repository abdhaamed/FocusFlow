import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_button.dart';
import '../widgets/onboarding_progress_bar.dart';
import '../widgets/onboarding_step_header.dart';

import 'package:provider/provider.dart';
import '../../../core/providers/goal_provider.dart';

class OnboardingTimeboundScreen extends StatefulWidget {
  const OnboardingTimeboundScreen({super.key});

  @override
  State<OnboardingTimeboundScreen> createState() => _OnboardingTimeboundScreenState();
}

class _OnboardingTimeboundScreenState extends State<OnboardingTimeboundScreen> {
  late DateTime _selectedDate;
  String? _selectedQuick;

  final List<String> _quickOptions = [
    'End of Week',
    'End of Month',
    'End of Q4',
    '1 Year',
  ];

  @override
  void initState() {
    super.initState();
    final goalProvider = Provider.of<GoalProvider>(context, listen: false);
    _selectedDate = goalProvider.timebound ?? DateTime.now().add(const Duration(days: 30));
    _selectedQuick = null;
    
    // Set initial value to provider
    Future.microtask(() {
      if (mounted) {
        context.read<GoalProvider>().setTimebound(_selectedDate);
      }
    });
  }

  void _updateDate(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
    context.read<GoalProvider>().setTimebound(newDate);
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM dd, yyyy').format(_selectedDate);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.neutral),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'FOCUSFLOW',
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.primary,
            letterSpacing: 2.0,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.neutral),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // STEP PROGRESS HEADER
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: OnboardingProgressBar(currentStep: 5, totalSteps: 5),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OnboardingStepHeader(
                      title: 'Set a deadline.',
                      description: 'A goal without a deadline is just a dream. When do you commit to achieving this?',
                      icon: Icons.calendar_today_outlined,
                    ),
                    const SizedBox(height: 32),
                    
                    // Main Container
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
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
                                // Inner Header
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Select Target Date',
                                      style: AppTypography.headlineMedium.copyWith(
                                        color: AppColors.primary,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                
                                // Calendar Custom UI Lookalike
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: AppColors.primary,
                                      onPrimary: Colors.white,
                                      surface: AppColors.surface,
                                      onSurface: AppColors.primary,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: CalendarDatePicker(
                                      initialDate: _selectedDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                      onDateChanged: (newDate) {
                                        _updateDate(newDate);
                                        setState(() {
                                          _selectedQuick = null; // Clear quick select when manually picking
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                
                                // Manual Entry
                                Text(
                                  'Manual Entry',
                                  style: AppTypography.labelMedium.copyWith(
                                    color: AppColors.neutral,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formattedDate,
                                        style: AppTypography.bodyMedium.copyWith(
                                          color: AppColors.neutral,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Icon(Icons.edit_calendar_outlined, color: AppColors.neutral.withValues(alpha: 0.8), size: 20),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                
                                // Quick Select
                                Text(
                                  'Quick Select',
                                  style: AppTypography.labelMedium.copyWith(
                                    color: AppColors.neutral,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 10.0,
                                  children: _quickOptions.map((option) {
                                    final isSelected = _selectedQuick == option;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedQuick = option;
                                          
                                          // Update date based on quick select
                                          final now = DateTime.now();
                                          if (option == 'End of Week') {
                                            _updateDate(now.add(Duration(days: 7 - now.weekday)));
                                          } else if (option == 'End of Month') {
                                            _updateDate(DateTime(now.year, now.month + 1, 0));
                                          } else if (option == 'End of Q4') {
                                            _updateDate(DateTime(now.year, 12, 31));
                                          } else if (option == '1 Year') {
                                            _updateDate(DateTime(now.year + 1, now.month, now.day));
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isSelected ? AppColors.primary : Colors.transparent,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          option,
                                          style: AppTypography.labelMedium.copyWith(
                                            fontSize: 12,
                                            color: isSelected ? Colors.white : AppColors.primary,
                                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 24),
                                
                                // Info Banner
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.info_outline, color: AppColors.primary.withValues(alpha: 0.8), size: 18),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Setting a firm deadline creates urgency. You can always adjust this later in the goal settings if circumstances change.',
                                          style: AppTypography.bodyMedium.copyWith(
                                            color: AppColors.neutral,
                                            fontSize: 12,
                                            height: 1.4,
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
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            
            // Bottom Action Buttons
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: AppColors.background,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: AppButton(
                      label: 'Back',
                      variant: AppButtonVariant.outlined,
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      label: 'Launch',
                      variant: AppButtonVariant.primary,
                      trailingIcon: const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                      onPressed: () async {
                        try {
                          await context.read<GoalProvider>().addGoal();
                          if (context.mounted) {
                            context.go(AppRoutes.home);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to save goal: $e')),
                            );
                          }
                        }
                      },
                    ),
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

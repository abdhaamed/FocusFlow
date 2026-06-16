import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_button.dart';
import '../widgets/onboarding_progress_bar.dart';
import '../widgets/onboarding_step_header.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/goal_provider.dart';

class OnboardingSpecificScreen extends StatefulWidget {
  const OnboardingSpecificScreen({super.key});

  @override
  State<OnboardingSpecificScreen> createState() => _OnboardingSpecificScreenState();
}

class _OnboardingSpecificScreenState extends State<OnboardingSpecificScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final goalProvider = Provider.of<GoalProvider>(context, listen: false);
    _controller = TextEditingController(text: goalProvider.specific);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: OnboardingProgressBar(currentStep: 1, totalSteps: 5),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OnboardingStepHeader(
                      title: 'Specific Goal',
                      description: 'Define exactly what you want to accomplish. A specific goal has a much greater chance of being accomplished than a general goal.',
                      icon: Icons.track_changes,
                    ),
                    const SizedBox(height: 32),
                    
                    // Main Card
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
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
                                Text(
                                  'What is your primary objective?',
                                  style: AppTypography.headlineMedium.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Consider: Who is involved? What do I want to accomplish? Where will it happen? Why is this important?',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.neutral.withValues(alpha: 0.8),
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                
                                // Text Field with Chip
                                Stack(
                                  children: [
                                    TextField(
                                      controller: _controller,
                                      onChanged: (val) {
                                        context.read<GoalProvider>().setSpecific(val);
                                      },
                                      maxLines: 7,
                                      style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
                                      decoration: InputDecoration(
                                        hintText: 'e.g., I want to increase my daily focused work sessions to 4 hours by the end of the quarter...',
                                        hintStyle: AppTypography.bodyMedium.copyWith(
                                          color: AppColors.neutral.withValues(alpha: 0.5),
                                        ),
                                        contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 48), // Bottom padding for chip
                                        fillColor: Colors.transparent,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.grey.shade300),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 12,
                                      right: 12,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.lightbulb_outline, size: 14, color: AppColors.neutral),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Use active verbs',
                                              style: AppTypography.labelSmall.copyWith(
                                                fontSize: 11,
                                                color: AppColors.neutral,
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
              decoration: BoxDecoration(
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
                      label: 'Next: Measurable',
                      variant: AppButtonVariant.primary,
                      trailingIcon: const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                      onPressed: () {
                        if (_controller.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please define your specific goal before proceeding.')),
                          );
                          return;
                        }
                        // Also set primaryObjective and specific
                        final goalVal = _controller.text.trim();
                        context.read<GoalProvider>().setPrimaryObjective(goalVal);
                        context.read<GoalProvider>().setSpecific(goalVal);
                        context.push(AppRoutes.onboardingMeasurable);
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

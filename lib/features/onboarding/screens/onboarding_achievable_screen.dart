import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/progress_bar.dart';

class OnboardingAchievableScreen extends StatefulWidget {
  const OnboardingAchievableScreen({super.key});

  @override
  State<OnboardingAchievableScreen> createState() => _OnboardingAchievableScreenState();
}

class _OnboardingAchievableScreenState extends State<OnboardingAchievableScreen> {
  bool _isRealistic = true;

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'STEP 3 OF 5',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.neutral,
                          fontSize: 11,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'Achievable',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.neutral,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const AppProgressBar(
                    value: 0.6,
                    color: AppColors.tertiary, // Green
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Titles
                    Text(
                      'Achievable Goal',
                      style: AppTypography.headlineLarge.copyWith(
                        color: AppColors.primary,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Outline the critical steps, resources, and skills required to bridge the gap between where you are now and your objective.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.neutral,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Card 1: Key Milestones
                    _buildInputCard(
                      borderColor: AppColors.primary,
                      titleWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Key Milestones (Steps)',
                            style: AppTypography.headlineMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Break your goal down into logical, sequential actions.',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.neutral.withOpacity(0.8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      inputWidget: _buildTextField(
                        hint: 'e.g., 1. Research phase, 2. Draft initial proposal...',
                        maxLines: 4,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 2: Resources Needed
                    _buildInputCard(
                      borderColor: const Color(0xFF2E7D32), // Dark Green
                      titleWidget: Row(
                        children: [
                          const Icon(Icons.inventory_2_outlined, color: Color(0xFF2E7D32), size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Resources Needed',
                            style: AppTypography.headlineMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      inputWidget: _buildTextField(
                        hint: 'Budget, tools, software...',
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 3: Potential Blockers
                    _buildInputCard(
                      borderColor: Colors.red.shade700,
                      titleWidget: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Potential Blockers',
                            style: AppTypography.headlineMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      inputWidget: _buildTextField(
                        hint: 'Time constraints, lack of expertise...',
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 4: Realistic Assessment
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Realistic Assessment',
                                  style: AppTypography.headlineMedium.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Are you confident this is achievable within your constraints?',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.neutral.withOpacity(0.8),
                                    fontSize: 11,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isRealistic,
                            activeColor: Colors.white,
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: Colors.grey.shade300,
                            inactiveThumbColor: Colors.white,
                            onChanged: (val) {
                              setState(() {
                                _isRealistic = val;
                              });
                            },
                          ),
                        ],
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
                      label: 'Next: Relevant',
                      variant: AppButtonVariant.primary,
                      trailingIcon: const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                      onPressed: () {
                        context.push(AppRoutes.onboardingRelevant);
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

  Widget _buildInputCard({required Color borderColor, required Widget titleWidget, required Widget inputWidget}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: borderColor, width: 4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleWidget,
                const SizedBox(height: 16),
                inputWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint, required int maxLines}) {
    return TextField(
      maxLines: maxLines,
      style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.neutral.withOpacity(0.5)),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

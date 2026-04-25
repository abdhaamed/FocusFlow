import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/progress_bar.dart';

class OnboardingMeasurableScreen extends StatefulWidget {
  const OnboardingMeasurableScreen({super.key});

  @override
  State<OnboardingMeasurableScreen> createState() => _OnboardingMeasurableScreenState();
}

class _OnboardingMeasurableScreenState extends State<OnboardingMeasurableScreen> {
  String _selectedFrequency = 'Weekly';

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
                        'Step 2 of 5',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.neutral,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Measurable',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const AppProgressBar(
                    value: 0.4,
                    color: AppColors.tertiary, // Green
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.table_chart_outlined,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Titles
                    Text(
                      'Measurable Goal',
                      textAlign: TextAlign.center,
                      style: AppTypography.headlineLarge.copyWith(
                        color: AppColors.primary,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Define how you will track progress. A measurable goal allows you to see your advancement and know exactly when you\'ve reached the finish line.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.neutral,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Main layout structure
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
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
                            border: Border(
                              left: BorderSide(color: AppColors.primary, width: 4),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Field 1
                                _buildLabel('What is the primary metric?'),
                                const SizedBox(height: 4),
                                Text(
                                  'e.g., Revenue, Users, Pages read, Miles run.',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.neutral.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  hint: 'Enter metric name',
                                  icon: Icons.show_chart,
                                ),
                                const SizedBox(height: 20),
                                
                                // Field 2
                                _buildLabel('Current Value (Optional)'),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  hint: '0',
                                  icon: Icons.compare_arrows,
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 20),
                                
                                // Field 3
                                _buildLabel('Target Value'),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  hint: '100',
                                  icon: Icons.flag_outlined,
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 20),
                                
                                // Field 4 (Frequency)
                                _buildLabel('Tracking Frequency'),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildFrequencyChip('Daily'),
                                    const SizedBox(width: 8),
                                    _buildFrequencyChip('Weekly'),
                                    const SizedBox(width: 8),
                                    _buildFrequencyChip('Monthly'),
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
                      label: 'Next: Achievable',
                      variant: AppButtonVariant.primary,
                      trailingIcon: const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                      onPressed: () {
                        context.push(AppRoutes.onboardingAchievable);
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTypography.headlineMedium.copyWith(
        color: AppColors.primary,
        fontSize: 13,
      ),
    );
  }

  Widget _buildTextField({required String hint, required IconData icon, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      keyboardType: keyboardType,
      style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.neutral.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: AppColors.neutral.withOpacity(0.6), size: 20),
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

  Widget _buildFrequencyChip(String label) {
    final isSelected = _selectedFrequency == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFrequency = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.06) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            fontSize: 12,
            color: isSelected ? AppColors.primary : AppColors.neutral,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

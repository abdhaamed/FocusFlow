import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/progress_bar.dart';

class OnboardingRelevantScreen extends StatefulWidget {
  const OnboardingRelevantScreen({super.key});

  @override
  State<OnboardingRelevantScreen> createState() => _OnboardingRelevantScreenState();
}

class _OnboardingRelevantScreenState extends State<OnboardingRelevantScreen> {
  final Set<String> _selectedValues = {'Financial Stability'};

  final List<String> _valuesList = [
    'Career Growth',
    'Financial Stability',
    'Skill Mastery',
    'Health & Wellbeing',
  ];

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
                        'Step 4 of 5',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.neutral,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Relevant',
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
                    value: 0.8,
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
                    const SizedBox(height: 8),
                    // Titles
                    Text(
                      'Make it Relevant',
                      textAlign: TextAlign.center,
                      style: AppTypography.headlineLarge.copyWith(
                        color: AppColors.primary,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ensure your goal aligns with your broader objectives and core values. Why does this matter right now?',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.neutral,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Card 1: Long-term vision
                    _buildCard(
                      title: 'How does this align with your long-term vision?',
                      child: _buildTextField(
                        hint: 'e.g., It\'s a stepping stone to my desired career transition...',
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 2: Right time
                    _buildCard(
                      title: 'Why is this the right time to focus on this?',
                      child: _buildTextField(
                        hint: 'e.g., The market trends support this direction...',
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 3: Values
                    _buildCard(
                      title: 'Select aligned values (Optional)',
                      child: _buildValuesWrap(),
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
                      label: 'Next: Set Date',
                      variant: AppButtonVariant.primary,
                      trailingIcon: const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                      onPressed: () {
                        context.push(AppRoutes.onboardingTimebound);
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

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.primary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
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

  Widget _buildValuesWrap() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 10.0,
      children: _valuesList.map((val) {
        final isSelected = _selectedValues.contains(val);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedValues.remove(val);
              } else {
                _selectedValues.add(val);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                width: 1.0,
              ),
            ),
            child: Text(
              val,
              style: AppTypography.labelMedium.copyWith(
                fontSize: 12,
                color: isSelected ? Colors.white : AppColors.primary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

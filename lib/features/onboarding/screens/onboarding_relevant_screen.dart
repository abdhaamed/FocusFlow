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

class OnboardingRelevantScreen extends StatefulWidget {
  const OnboardingRelevantScreen({super.key});

  @override
  State<OnboardingRelevantScreen> createState() => _OnboardingRelevantScreenState();
}

class _OnboardingRelevantScreenState extends State<OnboardingRelevantScreen> {
  late TextEditingController _visionController;
  late TextEditingController _timingController;
  final Set<String> _selectedValues = {'Financial Stability'};

  final List<String> _valuesList = [
    'Career Growth',
    'Financial Stability',
    'Skill Mastery',
    'Health & Wellbeing',
  ];

  @override
  void initState() {
    super.initState();
    final goalProvider = Provider.of<GoalProvider>(context, listen: false);
    _visionController = TextEditingController();
    _timingController = TextEditingController();
    
    // Parse existing data if available
    if (goalProvider.relevant.isNotEmpty) {
      final data = goalProvider.relevant.split('\n');
      for (var line in data) {
        if (line.startsWith('Vision: ')) {
          _visionController.text = line.replaceFirst('Vision: ', '');
        } else if (line.startsWith('Timing: ')) {
          _timingController.text = line.replaceFirst('Timing: ', '');
        } else if (line.startsWith('Values: ')) {
          final values = line.replaceFirst('Values: ', '').split(', ');
          _selectedValues.clear();
          _selectedValues.addAll(values.where((v) => v.isNotEmpty));
        }
      }
    }
  }

  void _updateRelevant() {
    final vision = _visionController.text;
    final timing = _timingController.text;
    final valuesStr = _selectedValues.join(', ');
    
    final relevantString = 'Vision: $vision\nTiming: $timing\nValues: $valuesStr';
    context.read<GoalProvider>().setRelevant(relevantString);
  }

  @override
  void dispose() {
    _visionController.dispose();
    _timingController.dispose();
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
              child: OnboardingProgressBar(currentStep: 4, totalSteps: 5),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const OnboardingStepHeader(
                      title: 'Make it Relevant',
                      description: 'Ensure your goal aligns with your broader objectives and core values. Why does this matter right now?',
                      icon: Icons.link,
                    ),
                    const SizedBox(height: 32),
                    
                    // Card 1: Long-term vision
                    _buildCard(
                      title: 'How does this align with your long-term vision?',
                      child: _buildTextField(
                        controller: _visionController,
                        hint: 'e.g., It\'s a stepping stone to my desired career transition...',
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 2: Right time
                    _buildCard(
                      title: 'Why is this the right time to focus on this?',
                      child: _buildTextField(
                        controller: _timingController,
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
                        if (_visionController.text.trim().isEmpty || _timingController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please answer both questions to ensure your goal is relevant.')),
                          );
                          return;
                        }
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
            color: Colors.black.withValues(alpha: 0.02),
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

  Widget _buildTextField({required TextEditingController controller, required String hint, required int maxLines}) {
    return TextField(
      controller: controller,
      onChanged: (_) => _updateRelevant(),
      maxLines: maxLines,
      style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.neutral.withValues(alpha: 0.5)),
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
            _updateRelevant();
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

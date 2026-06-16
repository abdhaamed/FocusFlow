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

class OnboardingAchievableScreen extends StatefulWidget {
  const OnboardingAchievableScreen({super.key});

  @override
  State<OnboardingAchievableScreen> createState() => _OnboardingAchievableScreenState();
}

class _OnboardingAchievableScreenState extends State<OnboardingAchievableScreen> {
  late TextEditingController _milestonesController;
  late TextEditingController _resourcesController;
  late TextEditingController _blockersController;
  bool _isRealistic = true;

  @override
  void initState() {
    super.initState();
    final goalProvider = Provider.of<GoalProvider>(context, listen: false);
    _milestonesController = TextEditingController();
    _resourcesController = TextEditingController();
    _blockersController = TextEditingController();
    
    // Try to parse existing data if it's there
    if (goalProvider.achievable.isNotEmpty) {
      final data = goalProvider.achievable.split('\n');
      for (var line in data) {
        if (line.startsWith('Milestones: ')) {
          _milestonesController.text = line.replaceFirst('Milestones: ', '');
        } else if (line.startsWith('Resources: ')) {
          _resourcesController.text = line.replaceFirst('Resources: ', '');
        } else if (line.startsWith('Blockers: ')) {
          _blockersController.text = line.replaceFirst('Blockers: ', '');
        } else if (line.startsWith('Realistic: ')) {
          _isRealistic = line.replaceFirst('Realistic: ', '') == 'true';
        }
      }
    }
  }

  void _updateAchievable() {
    final miles = _milestonesController.text;
    final res = _resourcesController.text;
    final block = _blockersController.text;
    
    final achievableString = 'Milestones: $miles\nResources: $res\nBlockers: $block\nRealistic: $_isRealistic';
    context.read<GoalProvider>().setAchievable(achievableString);
  }

  @override
  void dispose() {
    _milestonesController.dispose();
    _resourcesController.dispose();
    _blockersController.dispose();
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
              child: OnboardingProgressBar(currentStep: 3, totalSteps: 5),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OnboardingStepHeader(
                      title: 'Achievable Goal',
                      description: 'Outline the critical steps, resources, and skills required to bridge the gap between where you are now and your objective.',
                      icon: Icons.verified,
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
                              color: AppColors.neutral.withValues(alpha: 0.8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      inputWidget: _buildTextField(
                        controller: _milestonesController,
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
                        controller: _resourcesController,
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
                        controller: _blockersController,
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
                            color: Colors.black.withValues(alpha: 0.02),
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
                                    color: AppColors.neutral.withValues(alpha: 0.8),
                                    fontSize: 11,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isRealistic,
                            activeThumbColor: Colors.white,
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: Colors.grey.shade300,
                            inactiveThumbColor: Colors.white,
                            onChanged: (val) {
                              setState(() {
                                _isRealistic = val;
                              });
                              _updateAchievable();
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
                        if (_milestonesController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please outline your key milestones.')),
                          );
                          return;
                        }
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
            color: Colors.black.withValues(alpha: 0.02),
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

  Widget _buildTextField({required TextEditingController controller, required String hint, required int maxLines}) {
    return TextField(
      controller: controller,
      onChanged: (_) => _updateAchievable(),
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
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/focusflow_video_welcome.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      })
      ..setLooping(true)
      ..play();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top decorative line
                        Container(height: 4, color: AppColors.primary),
                        // Video area
                        Expanded(
                          flex: 4,
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFA5B4BA),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Looping Welcome Video
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: _controller.value.isInitialized
                                      ? SizedBox.expand(
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: SizedBox(
                                              width: _controller.value.size.width,
                                              height: _controller.value.size.height,
                                              child: VideoPlayer(_controller),
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.track_changes,
                                      color: AppColors.primary,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Text section
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Welcome to\nFocusFlow',
                                  textAlign: TextAlign.center,
                                  style: AppTypography.headlineLarge.copyWith(
                                    fontSize: 32,
                                    color: AppColors.primary,
                                    height: 1.15,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Master your productivity with the power of S.M.A.R.T goals and the Eisenhower Matrix.',
                                  textAlign: TextAlign.center,
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontSize: 15,
                                    color: AppColors.neutral,
                                    height: 1.5,
                                  ),
                                ),
                                const Spacer(),
                                // Button
                                SizedBox(
                                  width: double.infinity,
                                  child: AppButton(
                                    label: 'Get Started',
                                    variant: AppButtonVariant.primary,
                                    trailingIcon: const Icon(
                                      Icons.arrow_forward,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      context.push(AppRoutes.goalSummary);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Chips
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildChip(
                                      Icons.grid_view_rounded,
                                      'Matrix',
                                    ),
                                    const SizedBox(width: 12),
                                    _buildChip(
                                      Icons.track_changes_rounded,
                                      'Goals',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 14,
                    color: AppColors.neutral,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Nexus Digital Solutions',
                    style: AppTypography.labelMedium.copyWith(
                      fontSize: 13,
                      color: AppColors.neutral,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.neutral),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              fontSize: 13,
              color: AppColors.neutral,
            ),
          ),
        ],
      ),
    );
  }
}

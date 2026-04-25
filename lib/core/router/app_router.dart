// ASSIGNED TO: Hamid
// TODO(Hamid): Implement proper route guards and transitions later.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../../features/analytics_priority/screens/analytics_screen.dart';
import '../../features/analytics_priority/screens/priority_board_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/goal_detail_screen.dart';
import '../../features/onboarding/screens/goal_summary_screen.dart';
import '../../features/onboarding/screens/onboarding_achievable_screen.dart';
import '../../features/onboarding/screens/onboarding_measurable_screen.dart';
import '../../features/onboarding/screens/onboarding_relevant_screen.dart';
import '../../features/onboarding/screens/onboarding_specific_screen.dart';
import '../../features/onboarding/screens/onboarding_timebound_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/tasks/screens/task_detail_screen.dart';
import '../../features/tasks/screens/tasks_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.welcome,
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingSpecific,
        builder: (context, state) => const OnboardingSpecificScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingMeasurable,
        builder: (context, state) => const OnboardingMeasurableScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingAchievable,
        builder: (context, state) => const OnboardingAchievableScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingRelevant,
        builder: (context, state) => const OnboardingRelevantScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingTimebound,
        builder: (context, state) => const OnboardingTimeboundScreen(),
      ),
      GoRoute(
        path: AppRoutes.goalSummary,
        builder: (context, state) => const GoalSummaryScreen(),
      ),
      GoRoute(
        path: AppRoutes.goalDetail,
        builder: (context, state) => const GoalDetailScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.tasks,
        builder: (context, state) => const TasksScreen(),
      ),
      GoRoute(
        path: AppRoutes.createTask,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Use the + button on Tasks screen')),
        ),
      ),
      GoRoute(
        path: AppRoutes.taskDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TaskDetailScreen(taskId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.analytics,
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: AppRoutes.priority,
        builder: (context, state) => const PriorityBoardScreen(),
      ),
    ],
  );
}

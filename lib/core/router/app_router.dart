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
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/profile_screen.dart';
import '../providers/auth_provider.dart';
import '../providers/goal_provider.dart';

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider, GoalProvider goalProvider) {
    return GoRouter(
      initialLocation: AppRoutes.welcome,
      refreshListenable: Listenable.merge([authProvider, goalProvider]),
      redirect: (context, state) {
        final isLoggedIn = authProvider.isAuthenticated;
        
        // Define paths that are strictly for authentication
        final isAuthRoute = state.matchedLocation == AppRoutes.login || 
                            state.matchedLocation == AppRoutes.register;
                            
        // Define paths that unauthenticated users can access
        final isPublicRoute = state.matchedLocation == AppRoutes.welcome ||
                              isAuthRoute;

        final isOnboardingRoute = state.matchedLocation.startsWith('/onboarding') ||
                                  state.matchedLocation.startsWith('/goal');

        if (authProvider.isLoading || goalProvider.isLoading) return null;

        // If not logged in and trying to access a private/onboarding route, send to login
        if (!isLoggedIn && !isPublicRoute) {
          return AppRoutes.login;
        }

        // If logged in:
        if (isLoggedIn) {
          final hasCompletedOnboarding = goalProvider.hasGoal;

          // If they haven't completed onboarding, force them there
          if (!hasCompletedOnboarding && !isOnboardingRoute) {
            return AppRoutes.goalSummary;
          }

          // If they HAVE completed onboarding, and try to access public/onboarding routes, send to home
          if (hasCompletedOnboarding && (isPublicRoute || isOnboardingRoute)) {
            return AppRoutes.home;
          }
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterScreen(),
        ),
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
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    );
  }
}

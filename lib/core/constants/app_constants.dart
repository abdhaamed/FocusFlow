// ASSIGNED TO: Hamid
// TODO(Hamid): Add more constants as the app grows.

abstract class AppConstants {
  static const String appName = 'FocusFlow';
}

abstract class AppRoutes {
  static const String welcome = '/welcome';
  static const String onboardingSpecific = '/onboarding/specific';
  static const String onboardingMeasurable = '/onboarding/measurable';
  static const String onboardingAchievable = '/onboarding/achievable';
  static const String onboardingRelevant = '/onboarding/relevant';
  static const String onboardingTimebound = '/onboarding/timebound';
  static const String goalSummary = '/goal-summary';
  static const String goalDetail = '/goal-detail';
  static const String home = '/home';
  static const String tasks = '/tasks';
  static const String createTask = '/tasks/create';
  static const String taskDetail = '/tasks/:id';
  static const String priority = '/priority';
  static const String analytics = '/analytics';
}

abstract class AppCopy {
  static const String welcomeTitle = 'Welcome to FocusFlow';
  static const String welcomeSubtitle = 'Master your productivity with SMART goals & Eisenhower Matrix';
}

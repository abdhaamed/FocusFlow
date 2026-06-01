// ASSIGNED TO: Hamid
// TODO(Hamid): Add global state providers here later.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';

class FocusFlowApp extends StatelessWidget {
  final GoRouter router;
  
  const FocusFlowApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FocusFlow',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

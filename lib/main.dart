// ASSIGNED TO: Hamid
// TODO(Hamid): Initialize local storage and other services here later.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'core/providers/task_provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/goal_provider.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authProvider = AuthProvider();
  final goalProvider = GoalProvider(authProvider);
  final router = AppRouter.createRouter(authProvider, goalProvider);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: goalProvider),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: FocusFlowApp(router: router),
    ),
  );
}

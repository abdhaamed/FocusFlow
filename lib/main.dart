// ASSIGNED TO: Hamid
// TODO(Hamid): Initialize local storage and other services here later.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/providers/task_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TaskProvider())],
      child: const FocusFlowApp(),
    ),
  );
}

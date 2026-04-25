// ASSIGNED TO: Hamid
// TODO(Hamid): Add more comprehensive widget tests later.

import 'package:flutter_test/flutter_test.dart';
import 'package:focusflow/app.dart';

void main() {
  testWidgets('App starts and shows WelcomeScreen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FocusFlowApp());
    await tester.pumpAndSettle();

    // Verify that the WelcomeScreen is shown.
    expect(find.text('WelcomeScreen'), findsOneWidget);
  });
}

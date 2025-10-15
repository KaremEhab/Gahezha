// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:gahezha/constants/remote_config.dart';
import 'package:gahezha/gahezha_splash.dart';
import 'package:gahezha/main.dart';

void main() {
  // Test case for when the app is enabled
  testWidgets('App shows splash screen when enabled', (
    WidgetTester tester,
  ) async {
    // Build our app with the enabled flag and trigger a frame.
    await tester.pumpWidget(const MyApp(enabled: true));

    // Verify that the GahezhaSplash screen is shown.
    expect(find.byType(GahezhaSplash), findsOneWidget);

    // Verify that the disabled screen is NOT shown.
    expect(find.byType(AppDisabledScreen), findsNothing);
  });

  // Test case for when the app is disabled
  testWidgets('App shows disabled screen when disabled', (
    WidgetTester tester,
  ) async {
    // Build our app with the disabled flag and trigger a frame.
    await tester.pumpWidget(const MyApp(enabled: false));

    // Verify that the AppDisabledScreen is shown.
    expect(find.byType(AppDisabledScreen), findsOneWidget);

    // Verify that the splash screen is NOT shown.
    expect(find.byType(GahezhaSplash), findsNothing);
  });
}

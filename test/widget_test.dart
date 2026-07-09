import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:square_repos/app/app.dart';
import 'package:square_repos/core/di/service_locator.dart' as di;

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Set up mock SharedPreferences before initializing dependency injection
    SharedPreferences.setMockInitialValues({});
    await di.init();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Verify that the skeleton landing page is displayed
    expect(find.text('Square Repos App'), findsOneWidget);
  });
}

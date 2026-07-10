import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:square_repos/app/app.dart';
import 'package:square_repos/core/di/service_locator.dart' as di;
import 'package:square_repos/core/services/local_database.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Set up mock SharedPreferences before initializing dependency injection
    SharedPreferences.setMockInitialValues({});
    await di.init();

    // Register FakeLocalDataBaseService to bypass real Hive operations in tests
    di.sl.unregister<LocalDataBaseService>();
    di.sl.registerSingleton<LocalDataBaseService>(FakeLocalDataBaseService());

    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Verify that the skeleton landing page is displayed
    expect(find.text('Square Repositories'), findsOneWidget);
  });
}

class FakeLocalDataBaseService implements LocalDataBaseService {
  @override
  Future<List> getData(String boxName) async => [];

  @override
  Future<void> saveData(String boxName, List data) async {}

  @override
  Future<void> addData(String boxName, List data) async {}

  @override
  Future<void> clearBox(String boxName) async {}
}

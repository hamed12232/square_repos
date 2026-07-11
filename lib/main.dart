import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'core/di/service_locator.dart' as di;
import 'core/services/notification_service.dart';
import 'features/domain/usecase/sync_repositories_use_case.dart';
import 'app/app.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    await di.init();
    await di.sl<NotificationService>().initialize();
    final syncUseCase = di.sl<SyncRepositoriesUseCase>();
    try {
      await syncUseCase();
    } catch (_) {
      // Ignore background task exceptions
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await di.init();

  await di.sl<NotificationService>().initialize();
  await Workmanager().initialize(
    callbackDispatcher,
  );

  await Workmanager().registerPeriodicTask(
    'sync_repos_task',
    'sync_repos_periodic',
    frequency: const Duration(hours: 1),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  runApp(const App());
}

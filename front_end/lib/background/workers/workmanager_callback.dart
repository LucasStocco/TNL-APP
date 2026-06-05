import 'package:crud_flutter/background/workers/notification_worker.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("━━━━━━━━━━━━━━━━━━━━━━");
    print("🚀 WORKMANAGER DISPARADO");
    print("📌 TASK: $task");
    print("━━━━━━━━━━━━━━━━━━━━━━");

    try {
      final result = await NotificationWorker.execute(task, inputData);

      print("✅ TASK RESULTADO: $result");

      return result;
    } catch (e) {
      print("❌ ERRO NO CALLBACK: $e");
      return false;
    }
  });
}

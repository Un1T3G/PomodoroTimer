import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';
import 'package:pomodoro_timer_task_management/core/hive_adapters.dart';
import 'package:pomodoro_timer_task_management/core/hive_default_data.dart';
import 'package:pomodoro_timer_task_management/routes/main_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  registerAllHiveApadters();
  await insertDefaultProject();
  runApp(const StartApp());
}

class StartApp extends StatelessWidget {
  const StartApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: kAppName,
      theme: const CupertinoThemeData(
        scaffoldBackgroundColor: kBGColor,
      ),
      initialRoute: MainNavigator.initialRoute,
      routes: MainNavigator.routes,
      onGenerateRoute: MainNavigator.generateRoute,
    );
  }
}

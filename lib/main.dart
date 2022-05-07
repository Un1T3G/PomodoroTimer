import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';
import 'package:pomodoro_timer_task_management/core/hive_adapters.dart';
import 'package:pomodoro_timer_task_management/core/hive_default_data.dart';
import 'package:pomodoro_timer_task_management/cubit/task_work_logic/task_work_cubit.dart';
import 'package:pomodoro_timer_task_management/cubit/theme_switcher_logic/theme_switcher_cubit.dart';
import 'package:pomodoro_timer_task_management/cubit/timer_logic/timer_cubit.dart';
import 'package:pomodoro_timer_task_management/routes/main_navigation.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Hive.initFlutter();
  registerAllHiveApadters();
  await insertDefaultData();
  FlutterNativeSplash.remove();
  runApp(const StartApp());
}

class StartApp extends StatelessWidget {
  const StartApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeSwitcherCubit>(
          create: (_) => ThemeSwitcherCubit(),
        ),
        BlocProvider<TimerCubit>(
          create: (_) => TimerCubit()..init(),
        ),
        BlocProvider<TaskWorkCubit>(
          create: (_) => TaskWorkCubit()..init(),
        ),
      ],
      child: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  void initState() {
    super.initState();

    final timerCubit = context.read<TimerCubit>();
    final taskWorkCubit = context.read<TaskWorkCubit>();

    taskWorkCubit.lisenStream(timerCubit.timerStream);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: kAppName,
      theme: const CupertinoThemeData(
        primaryColor: kTextColor,
        scaffoldBackgroundColor: kBGColor,
        textTheme: CupertinoTextThemeData(
          primaryColor: kTextColor,
        ),
      ),
      initialRoute: MainNavigation.initialRoute,
      routes: MainNavigation.routes,
      onGenerateRoute: MainNavigation.generateRoute,
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    );
  }
}

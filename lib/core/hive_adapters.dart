import 'package:hive_flutter/adapters.dart';
import 'package:pomodoro_timer_task_management/models/pomodoro_timer.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';
import 'package:pomodoro_timer_task_management/models/task.dart';
import 'package:pomodoro_timer_task_management/models/task_priority.dart';

void registerAllHiveApadters() {
  Hive.registerAdapter(PomodoroTimerAdapter());
  Hive.registerAdapter(TaskPriorityAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(ProjectAdapter());
}

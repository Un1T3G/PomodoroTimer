import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';
import 'package:pomodoro_timer_task_management/models/task.dart';

class TaskService {
  final Project project;
  final String boxName;

  TaskService({
    required this.project,
    required this.boxName,
  });

  bool tryAddTask(Task task) {
    final tasks = project.tasks ?? List<Task>.empty(growable: true);

    if (tasks.map((e) => e.title).contains(task.title)) {
      return false;
    }

    project.copyWith(tasks: tasks..add(task));

    _updateProject();

    return true;
  }

  void updateTask(Task task) {
    final tasks = project.tasks ?? List<Task>.empty(growable: true);
    final index = tasks.indexWhere((e) => e.title == task.title);

    if (index == -1) {
      return;
    }

    tasks[index] = task;

    project.copyWith(tasks: tasks);

    _updateProject();
  }

  void deleteTask(Task task) {
    final tasks = project.tasks ?? List<Task>.empty(growable: true);
    final index = tasks.indexWhere((e) => e.title == task.title);

    if (index == -1) {
      return;
    }

    tasks.removeAt(index);

    project.copyWith(tasks: tasks);

    _updateProject();
  }

  Future<void> _updateProject() async {
    final box = await Hive.openBox<Project>(boxName);
    await box.put(project.title, project);
  }
}

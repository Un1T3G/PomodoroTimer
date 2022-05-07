import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:pomodoro_timer_task_management/models/pomodoro_timer.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';
import 'package:pomodoro_timer_task_management/models/task.dart';
import 'package:pomodoro_timer_task_management/models/task_priority.dart';

part 'project_detail_form_state.dart';

class ProjectDetailFormCubit extends Cubit<ProjectDetailFormState> {
  final String boxName;
  final int projectKey;
  final Task? task;

  ProjectDetailFormCubit({
    required this.boxName,
    required this.projectKey,
    this.task,
  }) : super(ProjectDetailFormState.initial());

  late final Project _project;
  late final Box<Project> _box;

  void init() async {
    if (task != null) {
      emit(state.copyWith(
        taskTitle: task!.title,
        pomodoroTimer: task!.pomodoroTimer,
        isEditing: true,
      ));
    }

    _box = await Hive.openBox<Project>(boxName);
    _project = _box.get(projectKey)!;
  }

  void changeState(ProjectDetailFormState state) {
    emit(state);
  }

  Future<void> saveTask() async {
    final tasks = _project.tasks!;
    final index = tasks.indexOf(task!);

    if (_taskTitleIsContains(tasks) && task!.title != state.taskTitle) {
      return;
    }

    tasks.removeAt(index);
    final newTask = task!.copyWith(
      title: state.taskTitle,
      priority: state.taskPriority,
      pomodoroTimer: state.pomodoroTimer,
    );

    tasks.insert(index, newTask);
    await _box.put(projectKey, _project.copyWith(tasks: tasks));
  }

  Future<void> addTask() async {
    final tasks = _project.tasks ?? [];

    final task = Task(
      title: state.taskTitle,
      priority: state.taskPriority,
      pomodoroTimer: state.pomodoroTimer,
      workedTime: 0,
      workedInterval: 0,
      isDone: false,
      date: DateTime.now().toIso8601String(),
    );

    if (_taskTitleIsContains(tasks)) {
      return;
    }

    tasks.add(task);
    await _box.put(projectKey, _project.copyWith(tasks: tasks));
  }

  Future<void> deleteTask() async {
    final tasks = _project.tasks!;

    tasks.remove(task!);

    await _box.put(projectKey, _project.copyWith(tasks: tasks));
  }

  bool _taskTitleIsContains(List<Task> tasks) {
    return tasks.map((e) => e.title).contains(state.taskTitle);
  }
}

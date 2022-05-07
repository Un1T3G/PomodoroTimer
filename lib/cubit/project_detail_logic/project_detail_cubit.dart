import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';
import 'package:pomodoro_timer_task_management/models/task.dart';

part 'project_detail_state.dart';

class ProjectDetailCubit extends Cubit<ProjectDetailState> {
  final String boxName;
  Project project;
  final int projectKey;

  ProjectDetailCubit({
    required this.boxName,
    required this.project,
    required this.projectKey,
  }) : super(ProjectDetailLoading());

  late final Box<Project> _box;

  void init() async {
    emit(ProjectDetailLoading());
    _box = await Hive.openBox<Project>(boxName);
    updateState();
  }

  void updateState() {
    final tasks = _getTasks();

    final projectTitle = project.title;
    final totalWorkTime =
        tasks.fold<int>(0, (sum, task) => sum + task.pomodoroTimer.workTime) /
            60;
    final workedTime =
        tasks.fold<int>(0, (sum, task) => sum + (task.workedTime ?? 0)) / 60;
    final completedTaskCount =
        tasks.fold<int>(0, (sum, task) => sum + (task.isDone! ? 1 : 0));
    final totalTaskCount = tasks.length;

    emit(
      ProjectDetailLoadedState(
        projectTitle: projectTitle,
        tasks: tasks,
        totalTaskCount: totalTaskCount,
        completedTaskCount: completedTaskCount,
        workedTime: workedTime,
        totalWorkTime: totalWorkTime,
      ),
    );
  }

  void deleteTask(Task task) async {
    final tasks = project.tasks!;
    tasks.remove(task);

    project = project.copyWith(tasks: tasks);
    await _box.put(projectKey, project);

    updateState();
  }

  void toggleTask(Task task) async {
    final tasks = project.tasks!;
    final index = tasks.indexOf(task);

    tasks.remove(task);
    task = task.copyWith(
      isDone: !task.isDone!,
    );
    tasks.insert(index, task);

    project = project.copyWith(tasks: tasks);
    await _box.put(projectKey, project);

    updateState();
  }

  void fetchTasks() async {
    emit(ProjectDetailLoading());

    final box = await Hive.openBox<Project>(boxName);
    final newProject = box.get(projectKey);

    if (newProject != null) {
      project = newProject;
      updateState();
    }
  }

  @override
  Future<void> close() async {
    //_box.listenable().removeListener(updateProject);
    await super.close();
  }

  List<Task> _getTasks() {
    return project.tasks ?? [];
  }
}

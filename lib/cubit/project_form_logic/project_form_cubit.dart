import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:pomodoro_timer_task_management/core/extensions/color.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';

part 'project_form_state.dart';

class ProjectformCubit extends Cubit<ProjectformState> {
  final String boxName;
  final Project? project;
  final int? projectKey;

  ProjectformCubit({
    required this.boxName,
    this.project,
    this.projectKey,
  }) : super(ProjectformState.initial()) {
    _init();
  }

  late final Box<Project> _box;

  void _init() async {
    if (project != null && projectKey != null) {
      emit(
        state.copyWith(
          projectTitle: project!.title,
          projectColor: HexColor.fromHex(project!.color),
          isEditMode: true,
        ),
      );
    }
    _box = await Hive.openBox<Project>(boxName);
  }

  void changeState(ProjectformState state) {
    emit(state);
  }

  Future<void> saveProject() async {
    final projects = _box.values.toList();

    if (_projectTitleIsContains(projects) &&
        project!.title != state.projectTitle) {
      return;
    }

    Project newProject = project!.copyWith(
      title: state.projectTitle,
      color: state.projectColor.toHex(),
    );

    await _box.put(projectKey!, newProject);
  }

  Future<void> addProject() async {
    final projects = _box.values.toList();

    if (_projectTitleIsContains(projects)) {
      return;
    }

    Project project = Project(
      title: state.projectTitle,
      color: state.projectColor.toHex(),
      date: DateTime.now().toIso8601String(),
    );

    await _box.add(project);
  }

  Future<void> deleteProject() async {
    await _box.delete(projectKey!);
  }

  bool _projectTitleIsContains(List<Project> projects) {
    return projects.any((project) => project.title == state.projectTitle);
  }
}

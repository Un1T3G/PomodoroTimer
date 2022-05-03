import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pomodoro_timer_task_management/core/extensions/color.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';
import 'package:pomodoro_timer_task_management/services/project_service.dart';

part 'project_form_state.dart';

class ProjectformCubit extends Cubit<ProjectformState> {
  final String boxName;
  final Project? project;

  ProjectformCubit({
    required this.boxName,
    this.project,
  }) : super(ProjectformState.initial()) {
    _init();
  }

  late final ProjectService _projectService;

  void _init() {
    if (project != null) {
      emit(
        state.copyWith(
          projectTitle: project!.title,
          projectColor: HexColor.fromHex(project!.color),
          isEditMode: true,
        ),
      );
    }

    _projectService = ProjectService(boxName: boxName);
  }

  void changeProjectTitle(String title) {
    emit(
      state.copyWith(
        projectTitle: title,
      ),
    );
  }

  void changeProjectColor(Color color) {
    emit(
      state.copyWith(
        projectColor: color,
      ),
    );
  }

  void putProject() async {
    Project project = Project(
      title: state.projectTitle,
      color: state.projectColor.toHex(),
      date: DateTime.now().toIso8601String(),
    );

    await _projectService.putProject(project);
  }

  void deleteProject() => _projectService.deleteProject(project!);
}

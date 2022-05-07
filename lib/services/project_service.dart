import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';

class ProjectService {
  final String boxName;

  ProjectService({required this.boxName});

  Future<bool> tryAddProject(Project project) async {
    final box = await Hive.openBox<Project>(boxName);

    if (box.values.map((e) => e.title).contains(project.title)) {
      return false;
    }

    return true;
  }

  Future<void> upadeProject(Project oldProject, Project newProject) async {
    if (oldProject == newProject) {
      return;
    }

    await deleteProject(oldProject);
    await putProject(newProject);
  }

  Future<void> putProject(Project project) async {
    final box = await Hive.openBox<Project>(boxName);
    await box.put(project.title, project);
  }

  Future<void> deleteProject(Project project) async {
    final box = await Hive.openBox<Project>(boxName);
    await box.delete(project.title);
  }
}

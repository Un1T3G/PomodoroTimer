import 'package:hive_flutter/adapters.dart';
import 'package:pomodoro_timer_task_management/core/values/keys.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';

class ProjectRepository {
  Future<List<Project>> getProjects(String boxName) async {
    final box = await Hive.openBox<Project>(boxName);

    return box.values.toList();
  }

  Future<List<Project>> getAllProjects() async {
    List<Project> projects = [];
    final boxes = [kProjectBox, kMainProjectBox];

    for (int i = 0; i < boxes.length; i++) {
      projects.addAll(await getProjects(boxes[i]));
    }

    return projects;
  }
}

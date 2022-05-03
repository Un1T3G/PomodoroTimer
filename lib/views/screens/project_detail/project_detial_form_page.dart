import 'package:flutter/cupertino.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';
import 'package:pomodoro_timer_task_management/models/task.dart';

class ProjectDetailFormPage extends StatelessWidget {
  const ProjectDetailFormPage({
    Key? key,
    required this.boxName,
    required this.project,
    this.task,
  }) : super(key: key);

  final String boxName;
  final Project project;
  final Task? task;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

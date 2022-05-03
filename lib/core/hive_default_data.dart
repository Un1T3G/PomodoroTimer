import 'package:hive_flutter/adapters.dart';
import 'package:pomodoro_timer_task_management/core/extensions/color.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/core/values/keys.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';

final _projects = [
  {
    'title': 'Inbox',
    'color': kIndigoColor.toHex(),
  },
  {
    'title': 'Today',
    'color': kYellowColor.toHex(),
  },
  {
    'title': 'Next 7 days',
    'color': kGreenColor.toHex(),
  },
  {
    'title': 'Some days',
    'color': kGreyColor.toHex(),
  },
];

Future<void> insertDefaultProject() async {
  final box = await Hive.openBox<Project>(kMainProjectBox);
  if (box.isEmpty) {
    for (int i = 0; i < _projects.length; i++) {
      final project = Project(
        title: _projects[i]['title'] as String,
        color: _projects[i]['color'] as String,
        date: DateTime.now().toIso8601String(),
      );
      await box.put(project.title, project);
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';
import 'package:pomodoro_timer_task_management/models/task.dart';
import 'package:pomodoro_timer_task_management/views/screens/project/project_form_page.dart';
import 'package:pomodoro_timer_task_management/views/screens/project/project_page.dart';
import 'package:pomodoro_timer_task_management/views/screens/project_detail/project_detail_page.dart';
import 'package:pomodoro_timer_task_management/views/screens/project_detail/project_detial_form_page.dart';

abstract class MainNavigatorRoutes {
  static const String projects = '/projects';
  static const String projectForm = '/project/form';
  static const String projectDetail = '/projects/detail';
  static const String projectDetailForm = '/projects/detail/form';
}

class MainNavigator {
  static const String initialRoute = MainNavigatorRoutes.projects;

  static final routes = <String, WidgetBuilder>{
    MainNavigatorRoutes.projects: (context) => const ProjectsPage(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigatorRoutes.projectForm:
        final boxName =
            (settings.arguments as Map<String, Object>)['boxName'] as String;
        final project = (settings.arguments
            as Map<String, Object>)['projectKey'] as Project?;

        return CupertinoPageRoute(
          fullscreenDialog: project == null,
          builder: (_) => ProjectFormPage(
            boxName: boxName,
            project: project,
          ),
        );
      case MainNavigatorRoutes.projectDetail:
        final boxName =
            (settings.arguments as Map<String, Object>)['boxName'] as String;
        final project =
            (settings.arguments as Map<String, Object>)['project'] as Project;

        return CupertinoPageRoute(
          builder: (_) => ProjectDetailPage(
            boxName: boxName,
            project: project,
          ),
        );
      case MainNavigatorRoutes.projectDetailForm:
        final boxName =
            (settings.arguments as Map<String, Object>)['boxName'] as String;
        final project =
            (settings.arguments as Map<String, Object>)['project'] as Project;
        final task =
            (settings.arguments as Map<String, Object>)['task'] as Task?;

        return CupertinoPageRoute(
          fullscreenDialog: task == null,
          builder: (_) => ProjectDetailFormPage(
            boxName: boxName,
            project: project,
            task: task,
          ),
        );
      default:
        return CupertinoPageRoute(
          builder: (_) => CupertinoPageScaffold(
            child: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

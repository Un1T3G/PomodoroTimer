import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/cubit/tab_navigator_logic/tab_navigator_cubit.dart';
import 'package:pomodoro_timer_task_management/routes/main_navigation.dart';
import 'package:pomodoro_timer_task_management/views/screens/project/project_page.dart';
import 'package:pomodoro_timer_task_management/views/screens/settings/settings_page.dart';
import 'package:pomodoro_timer_task_management/views/screens/statistics/statistics_page.dart';
import 'package:pomodoro_timer_task_management/views/screens/timer/timer_page.dart';

class TabNavigator extends StatefulWidget {
  const TabNavigator({Key? key}) : super(key: key);

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: kIndigoColor,
        inactiveColor: kGreyColor,
        backgroundColor: kCardColor,
        currentIndex: context.watch<TabNavigatorCubit>().state.tabIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.alarm),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              onGenerateRoute: MainNavigation.generateRoute,
              builder: (_) => const TimerPage(),
            );
          case 1:
            return CupertinoTabView(
              onGenerateRoute: MainNavigation.generateRoute,
              builder: (_) => const ProjectsPage(),
            );
          case 2:
            return CupertinoTabView(
              onGenerateRoute: MainNavigation.generateRoute,
              builder: (_) => const StatisticsPage(),
            );
          case 3:
            return CupertinoTabView(
              onGenerateRoute: MainNavigation.generateRoute,
              builder: (_) => const SettingsPage(),
            );
          default:
            return const Center(
              child: Text('Navigation Error'),
            );
        }
      },
    );
  }
}

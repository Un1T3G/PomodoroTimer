import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_timer_task_management/core/extensions/color.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';
import 'package:pomodoro_timer_task_management/cubit/statistics_logic/statistics_cubit.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';
import 'package:pomodoro_timer_task_management/views/widgets/action_button.dart';
import 'package:pomodoro_timer_task_management/views/widgets/card_title.dart';
import 'package:pomodoro_timer_task_management/views/widgets/page_title.dart';
import 'package:pomodoro_timer_task_management/views/widgets/rouned_card.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit>(
      create: (context) => StatisticsCubit()..init(),
      child: CupertinoPageScaffold(
        child: SafeArea(child: BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, state) {
            if (state is StatisticsLoadedState) {
              return const _Body();
            }

            return const _Loading();
          },
        )),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultMargin),
      children: const [
        _Title(),
        _Segment(),
        Center(
          child: CupertinoActivityIndicator(),
        )
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultMargin),
      children: const [
        _Title(),
        _Segment(),
        _Statistics(),
        _TopProjects(),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PageTitle(title: 'Statistics');
  }
}

class _Segment extends StatelessWidget {
  const _Segment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RounedCard(
      padding: const EdgeInsets.all(2),
      child: Row(
        children: const [
          _SegmentItem(
            title: 'Week',
            statisticsType: StatisticsType.week,
          ),
          _SegmentItem(
            title: 'Month',
            statisticsType: StatisticsType.month,
          ),
          _SegmentItem(
            title: 'All time',
            statisticsType: StatisticsType.all,
          ),
        ],
      ),
    );
  }
}

class _SegmentItem extends StatelessWidget {
  const _SegmentItem({
    Key? key,
    required this.title,
    required this.statisticsType,
  }) : super(key: key);

  final String title;
  final StatisticsType statisticsType;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<StatisticsCubit>();

    return Expanded(
      child: ActionButton.withChildText(
        title: title,
        color:
            cubit.statisticsType == statisticsType ? kIndigoColor : kCardColor,
        onPressed: () => cubit.changeStatisticsType(statisticsType),
        padding: const EdgeInsets.symmetric(vertical: 4),
      ),
    );
  }
}

class _Statistics extends StatelessWidget {
  const _Statistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultMargin * 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          _Diagram(),
          _Information(),
        ],
      ),
    );
  }
}

class _Slider extends StatelessWidget {
  const _Slider({
    Key? key,
    required this.color,
    required this.value,
    required this.radiusFactor,
  }) : super(key: key);

  final Color color;
  final double value;
  final double radiusFactor;

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      axes: [
        RadialAxis(
          startAngle: 270,
          endAngle: 270,
          minimum: 0,
          maximum: 1,
          radiusFactor: radiusFactor,
          showLabels: false,
          showTicks: false,
          axisLineStyle: AxisLineStyle(
            thickness: 10,
            color: color.withOpacity(0.3),
          ),
          pointers: [
            MarkerPointer(
              value: 0,
              markerWidth: 10,
              markerHeight: 10,
              markerType: MarkerType.circle,
              color: color,
            ),
            RangePointer(
              value: value,
              width: 10,
              color: color,
            ),
            MarkerPointer(
              value: value,
              markerWidth: 10,
              markerHeight: 10,
              markerType: MarkerType.circle,
              color: color,
            ),
          ],
        )
      ],
    );
  }
}

class _Diagram extends StatelessWidget {
  const _Diagram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<StatisticsCubit>();
    final state = cubit.state as StatisticsLoadedState;

    return Flexible(
      child: Center(
        child: Container(
          padding: const EdgeInsets.only(right: 20),
          constraints: const BoxConstraints(
            maxWidth: 350,
            maxHeight: 350,
          ),
          child: LayoutBuilder(
            builder: (_, size) {
              return SizedBox(
                width: size.maxWidth,
                height: size.maxWidth,
                child: Stack(
                  children: [
                    _Slider(
                      color: kIndigoColor,
                      value: state.workedTime / state.totalWorkTime,
                      radiusFactor: 1,
                    ),
                    _Slider(
                      color: kRedColor,
                      value:
                          state.completedProjectCount / state.totalProjectCount,
                      radiusFactor: 0.75,
                    ),
                    _Slider(
                      color: kYellowColor,
                      value: state.completedTaskCount / state.totalTaskCount,
                      radiusFactor: 0.50,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _InformationCard extends StatelessWidget {
  const _InformationCard({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
  }) : super(key: key);

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          alignment: Alignment.center,
          child: Icon(
            CupertinoIcons.circle_fill,
            color: color,
            size: 14,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: kGreyColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: kTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _Information extends StatelessWidget {
  const _Information({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<StatisticsCubit>();
    final state = cubit.state as StatisticsLoadedState;

    return Flexible(
      child: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InformationCard(
              color: kIndigoColor,
              title: 'Фокусировка',
              value: '${state.workedTime} часов',
            ),
            const SizedBox(height: 12),
            _InformationCard(
              color: kRedColor,
              title: 'Проекты',
              value: '${state.completedProjectCount} завершено',
            ),
            const SizedBox(height: 12),
            _InformationCard(
              color: kYellowColor,
              title: 'Задача',
              value: '${state.completedTaskCount} завершено',
            ),
          ],
        ),
      ),
    );
  }
}

class _TopProjects extends StatelessWidget {
  const _TopProjects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<StatisticsCubit>();
    final state = cubit.state as StatisticsLoadedState;
    final projects = state.topProjects;

    return projects.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardTitle(title: 'Top projects'),
              ...List.generate(projects.length,
                  (index) => _ProjectCard(project: projects[index])),
            ],
          );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    Key? key,
    required this.project,
  }) : super(key: key);

  final Project project;

  Widget _buildTitle({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 25,
          color: kTextColor,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildSubTitle({required String text}) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 100,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: kGreyColor,
        ),
      ),
    );
  }

  Widget _buildVerticalLine() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 1,
      color: kGreyColor,
    );
  }

  String _numberFormat(double value) {
    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StatisticsCubit>();

    return RounedCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.circle_fill,
                color: HexColor.fromHex(project.color),
                size: 15,
              ),
              const SizedBox(width: 8),
              Text(
                project.title,
                style: const TextStyle(
                  fontSize: 18,
                  color: kTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: kDefaultMargin),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitle(
                      text: _numberFormat(cubit.getProjectWorkedTime(project))),
                  _buildSubTitle(text: 'Worked time(h)'),
                ],
              ),
              _buildVerticalLine(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitle(
                      text: '${cubit.getProjectCompletedTaskCount(project)}'),
                  _buildSubTitle(text: 'Complete tasks'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
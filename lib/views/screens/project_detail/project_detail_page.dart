import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';
import 'package:pomodoro_timer_task_management/views/widgets/back_button.dart';
import 'package:pomodoro_timer_task_management/views/widgets/card_title.dart';
import 'package:pomodoro_timer_task_management/views/widgets/page_title.dart';
import 'package:pomodoro_timer_task_management/views/widgets/rouned_card.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({
    Key? key,
    required this.boxName,
    required this.project,
  }) : super(key: key);

  final String boxName;
  final Project project;

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: SafeArea(
        child: _HasTasksBody(),
      ),
    );
  }
}

class _HasTasksBody extends StatelessWidget {
  const _HasTasksBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: const [
        _Header(),
        _Title(),
        _ProjectInformation(),
        _TaskList(),
        _CompletedTaskList(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          BackButton(),
          _MoreButton(),
        ],
      ),
    );
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.zero,
      child: const Icon(
        CupertinoIcons.plus_circled,
        color: kTextColor,
        size: 25,
      ),
      onPressed: () {},
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTitle.withHorizontalMargin(title: 'Project');
  }
}

class _ProjectInformation extends StatelessWidget {
  const _ProjectInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const fristCard = _TaskStatisticsCard(
      fristTitle: '3.3',
      fristSubTitle: 'Work time(h)',
      secondTitle: '4',
      secondSubTitle: 'All tasks in project',
    );

    const secondCard = _TaskStatisticsCard(
      fristTitle: '2.1',
      fristSubTitle: 'Worked time(h)',
      secondTitle: '3',
      secondSubTitle: 'Completed tasks',
    );

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultMargin),
        child: IntrinsicHeight(
          child: MediaQuery.of(context).size.width < 700
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      fristCard,
                      SizedBox(width: kDefaultMargin),
                      secondCard,
                    ],
                  ),
                )
              : Row(
                  children: const [
                    Flexible(child: fristCard),
                    SizedBox(width: kDefaultMargin),
                    Flexible(child: secondCard),
                  ],
                ),
        ));
  }
}

class _TaskStatisticsCard extends StatelessWidget {
  const _TaskStatisticsCard({
    Key? key,
    required this.fristTitle,
    required this.fristSubTitle,
    required this.secondTitle,
    required this.secondSubTitle,
  }) : super(key: key);

  final String fristTitle;
  final String fristSubTitle;
  final String secondTitle;
  final String secondSubTitle;

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

  @override
  Widget build(BuildContext context) {
    return RounedCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(text: fristTitle),
              _buildSubTitle(text: fristSubTitle),
            ],
          ),
          _buildVerticalLine(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(text: secondTitle),
              _buildSubTitle(text: secondSubTitle),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final flag = 15 > 3;

    return flag
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardTitle.withHorizontalMargin(title: 'Tasks'),
              const _TaskCard(),
              const _TaskCard(),
            ],
          )
        : const SizedBox();
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RounedCard.withHorizontalMargin(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _CircleBordered(color: kYellowColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Title',
                      style: TextStyle(
                        fontSize: 18,
                        color: kTextColor,
                      ),
                    ),
                    Text(
                      '0/6',
                      style: TextStyle(
                        fontSize: 18,
                        color: kTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '0 minute',
                      style: TextStyle(
                        fontSize: 18,
                        color: kGreyColor,
                      ),
                    ),
                    Text(
                      '25 min',
                      style: TextStyle(
                        fontSize: 18,
                        color: kGreyColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const _CircleBordered(
            color: kIndigoColor,
            child: Icon(
              CupertinoIcons.play,
              color: kIndigoColor,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedTaskList extends StatelessWidget {
  const _CompletedTaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final flag = 15 > 3;

    return flag
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardTitle.withHorizontalMargin(title: 'Completed Tasks'),
              const _TaskCard(),
              const _TaskCard(),
            ],
          )
        : const SizedBox();
  }
}

class _CircleBordered extends StatelessWidget {
  const _CircleBordered({
    Key? key,
    required this.color,
    this.child,
  }) : super(key: key);

  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        shape: BoxShape.circle,
        border: Border.all(color: color),
      ),
      child: child,
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_timer_task_management/components/popup_modal.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';
import 'package:pomodoro_timer_task_management/cubit/task_work_logic/task_work_cubit.dart';
import 'package:pomodoro_timer_task_management/cubit/timer_logic/timer_cubit.dart';
import 'package:pomodoro_timer_task_management/models/task.dart';
import 'package:pomodoro_timer_task_management/models/task_priority.dart';
import 'package:pomodoro_timer_task_management/views/widgets/action_button.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  void initState() {
    super.initState();
    final timerCubit = context.read<TimerCubit>();
    final taskWorkCubit = context.read<TaskWorkCubit>();
    final task = taskWorkCubit.state.task;

    if (task != null) {
      timerCubit.setPomodoroTimer(task.pomodoroTimer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: SafeArea(
        child: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        _TaskCardBody(),
        _TimerBody(),
        _TimerActionButton(),
      ],
    );
  }
}

class _TaskCardBody extends StatelessWidget {
  const _TaskCardBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final task = context.select((TaskWorkCubit cubit) => cubit.state.task);

    return task != null
        ? Positioned(
            top: kDefaultMargin,
            left: kDefaultMargin,
            right: kDefaultMargin,
            child: SizedBox(
              child: _TaskCard(task: task),
            ),
          )
        : const SizedBox();
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  void _openTimerStopModal(BuildContext context) async {
    final cubit = context.read<TimerCubit>();

    await showPopupModal(
      context: context,
      title: 'Are you sure you want to stop timer?',
      onConiform: () {
        cubit.stop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      minSize: 0,
      padding: const EdgeInsets.all(kDefaultMargin / 2),
      color: kCardColor,
      borderRadius: BorderRadius.circular(kDefaultRadius),
      onPressed: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _CircleBordered(
            color: task.priority.color,
            child: task.isDone == true
                ? const Icon(
                    CupertinoIcons.checkmark_alt,
                    color: kTextColor,
                    size: 16,
                  )
                : null,
            onPressed: () {},
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: kTextColor,
                      ),
                    ),
                    Text(
                      '${task.workedInterval ?? 0}/${task.pomodoroTimer.workCycle}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: kTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kDefaultMargin / 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${task.workedTime ?? 0} minute',
                      style: const TextStyle(
                        fontSize: 18,
                        color: kGreyColor,
                      ),
                    ),
                    Text(
                      '${task.pomodoroTimer.workTime} min',
                      style: const TextStyle(
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
          CupertinoButton(
            minSize: 0,
            padding: EdgeInsets.zero,
            child: task.isDone == true
                ? const Icon(
                    CupertinoIcons.trash_circle,
                    color: kRedColor,
                    size: 32,
                  )
                : const Icon(
                    CupertinoIcons.play_circle,
                    color: kIndigoColor,
                    size: 32,
                  ),
            onPressed: () => _openTimerStopModal(context),
          )
        ],
      ),
    );
  }
}

class _CircleBordered extends StatelessWidget {
  const _CircleBordered({
    Key? key,
    required this.color,
    this.child,
    required this.onPressed,
  }) : super(key: key);

  final Color color;
  final Widget? child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed.call,
      child: Container(
        width: 25,
        height: 25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(color: color),
        ),
        child: child,
      ),
    );
  }
}

class _TimerBody extends StatelessWidget {
  const _TimerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: const [
          _TimerSlider(),
          _TimerTitle(),
        ],
      ),
    );
  }
}

class _TimerSlider extends StatelessWidget {
  const _TimerSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TimerCubit>();
    final state = cubit.state;
    final color = state.mode.isWork ? kIndigoColor : kGreenColor;
    final value = state.currentDuration / state.duration;

    return Container(
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 350,
      ),
      child: SfRadialGauge(
        axes: [
          RadialAxis(
            startAngle: 270,
            endAngle: 270,
            minimum: 0,
            maximum: 1,
            showLabels: false,
            showTicks: false,
            axisLineStyle: AxisLineStyle(
              thickness: 10,
              color: color.withOpacity(0.5),
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
      ),
    );
  }
}

class _TimerTitle extends StatelessWidget {
  const _TimerTitle({Key? key}) : super(key: key);

  String _numberFormat(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TimerCubit>();
    final state = cubit.state;

    final minutes = _numberFormat(state.currentDuration ~/ 60);
    final seconds = _numberFormat(state.currentDuration % 60);

    return Center(
      child: Text(
        '$minutes:$seconds',
        style: const TextStyle(
          fontSize: 85,
          color: kTextColor,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _TimerActionButton extends StatelessWidget {
  const _TimerActionButton({Key? key}) : super(key: key);

  void _openTimerStopModal(BuildContext context) async {
    final cubit = context.read<TimerCubit>();

    cubit.pause();

    await showPopupModal(
      context: context,
      title: 'Are you sure you want to stop timer?',
      onConiform: cubit.stop,
    );
  }

  Widget _buildStartButton(BuildContext context) {
    final cubit = context.read<TimerCubit>();

    return ActionButton.withChildText(
      title: 'Start',
      onPressed: () => cubit.start(),
    );
  }

  Widget _buildToggleButton(BuildContext context) {
    final cubit = context.read<TimerCubit>();

    return Row(
      children: [
        Flexible(
          child: ActionButton.withChildText(
            title: 'Stop',
            onPressed: () => _openTimerStopModal(context),
          ),
        ),
        const SizedBox(width: kDefaultMargin),
        Flexible(
          child: ActionButton.withChildText(
            title: 'Pause',
            onPressed: () => cubit.pause(),
          ),
        ),
      ],
    );
  }

  Widget _buildSkipBreakButton(BuildContext context) {
    final cubit = context.read<TimerCubit>();

    return ActionButton.withChildText(
      title: 'Skip Break',
      onPressed: () => cubit.nextCycle(),
    );
  }

  Widget _buildResumeButton(BuildContext context) {
    final cubit = context.read<TimerCubit>();

    return ActionButton.withChildText(
      title: 'Resume',
      onPressed: () => cubit.resume(),
    );
  }

  Widget _buildCrossFade(
      Widget firstChild, Widget secondChild, bool showFristChild) {
    return AnimatedCrossFade(
      firstChild: firstChild,
      secondChild: secondChild,
      crossFadeState:
          showFristChild ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TimerCubit>();
    final state = cubit.state;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(
          kDefaultMargin,
        ),
        child: _buildCrossFade(
          _buildStartButton(context),
          _buildCrossFade(
            _buildCrossFade(
              _buildToggleButton(context),
              _buildSkipBreakButton(context),
              state.mode.isWork,
            ),
            _buildResumeButton(context),
            state.status.isPaused == false,
          ),
          state.status.isStopped,
        ),
      ),
    );
  }
}

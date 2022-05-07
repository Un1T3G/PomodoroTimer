import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:pomodoro_timer_task_management/cubit/timer_logic/timer_cubit.dart';
import 'package:pomodoro_timer_task_management/cubit/timer_logic/timer_event.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';
import 'package:pomodoro_timer_task_management/models/task.dart';
import 'package:pomodoro_timer_task_management/models/timer_task.dart';

import '../../core/values/keys.dart';

part 'task_work_state.dart';

class TaskWorkCubit extends Cubit<TaskWorkState> {
  TaskWorkCubit() : super(TaskWorkState.initial());

  TimerTask? _timerTask;
  late final Box<TimerTask> _timerTaskBox;

  void init() async {
    _timerTaskBox = await Hive.openBox<TimerTask>(kTimerTaskBox);

    if (_timerTaskBox.isNotEmpty) {
      _timerTask = _timerTaskBox.values.first;
      emit(state.copyWith(task: _timerTask!.task));
    }
  }

  void lisenStream(Stream<TimerEvent> stream) async {
    stream.listen(_mapTimerEventToState);
  }

  Future<bool> trySetTimerTask(TimerTask timerTask) async {
    if (_timerTask != null) {
      return false;
    }

    _timerTask = timerTask;
    await _timerTaskBox.put(kTimerTaskBox, timerTask);

    emit(state.copyWith(task: timerTask.task));

    return true;
  }

  bool isEqual(TimerTask timerTask) {
    return _timerTask == timerTask;
  }

  void _mapTimerEventToState(TimerEvent event) {
    if (event is TimerStoppedEvent) {
      _saveChanges();
    } else if (event is TimerCycleCompletedEvent) {
      if (event.mode.isWork == false) {
        return;
      }

      final task = state.task;

      final workTime = state.workTime + event.duration;
      final workCycle = state.workCycle + 1;

      emit(
        state.copyWith(
          workTime: workTime,
          workCycle: workCycle,
          task: task?.copyWith(
            workedTime: workTime,
            workedInterval: workCycle,
          ),
        ),
      );
    } else if (event is TimerCompletedEvent) {
      _saveChanges(taskIsDone: true);
    }
  }

  Future<void> _updateTask(bool taskIsDone) async {
    final box = await Hive.openBox<Project>(_timerTask!.boxName);
    final project = box.get(_timerTask!.projectKey)!;

    final tasks = project.tasks ?? [];
    final taskIndex = tasks.indexOf(_timerTask!.task);

    tasks.removeAt(taskIndex);

    final task = _timerTask!.task;

    tasks.insert(
      taskIndex,
      task.copyWith(
        workedTime: (task.workedTime ?? 0) + state.workTime,
        workedInterval: (task.workedInterval ?? 0) + state.workCycle,
        isDone: taskIsDone,
      ),
    );

    await box.put(_timerTask!.projectKey, project.copyWith(tasks: tasks));
  }

  void _saveChanges({bool taskIsDone = false}) async {
    if (_timerTask != null) {
      await _updateTask(taskIsDone);
    }

    if (_timerTaskBox.isNotEmpty) {
      await _timerTaskBox.delete(kTimerTaskBox);
    }

    _timerTask = null;
    emit(TaskWorkState.initial());
  }
}
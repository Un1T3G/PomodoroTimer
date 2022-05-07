import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:pomodoro_timer_task_management/core/ticker.dart';
import 'package:pomodoro_timer_task_management/cubit/timer_logic/timer_event.dart';
import 'package:pomodoro_timer_task_management/models/pomodoro_timer.dart';
import 'package:pomodoro_timer_task_management/services/pomodoro_timer_storage_service.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(TimerState.initial());

  late final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;
  late PomodoroTimer _pomodoroTimer;
  late final PomodoroTimerStorageService _pomodoroTimerStorageService;

  late final StreamController<TimerEvent> _streamController;
  Stream<TimerEvent> get timerStream => _streamController.stream;

  void init() async {
    _ticker = Ticker();
    _streamController = StreamController<TimerEvent>.broadcast();

    _pomodoroTimerStorageService = PomodoroTimerStorageService();
    await _pomodoroTimerStorageService.init();

    setPomodoroTimer(_pomodoroTimerStorageService.getPomodoroTimer());
  }

  void setPomodoroTimer(PomodoroTimer pomodoroTimer) {
    _pomodoroTimer = pomodoroTimer;

    final duration = _pomodoroTimer.workTime;
    emit(
      state.copyWith(
        duration: duration,
        currentDuration: duration,
      ),
    );
  }

  void start() async {
    _tickerSubscription = _ticker
        .tick(ticks: state.duration)
        .listen(_mapTickerEventToState)
      ..resume();

    emit(
      state.copyWith(
        status: TimerStatus.running,
      ),
    );

    _streamController.add(TimerStartedEvent());
  }

  void resume() {
    _tickerSubscription?.resume();

    emit(
      state.copyWith(
        status: TimerStatus.running,
      ),
    );

    _streamController.add(TimerResumedEvent());
  }

  void pause() {
    _tickerSubscription?.pause();

    emit(
      state.copyWith(
        status: TimerStatus.paused,
      ),
    );

    _streamController.add(TimerPausedEvent());
  }

  void nextCycle() {
    _tickerSubscription?.cancel();

    _streamController.add(
      TimerCycleCompletedEvent(
        mode: state.mode,
        duration: state.duration,
      ),
    );

    if (state.currentCycle >= _pomodoroTimer.workCycle * 2 - 1) {
      _timerCompleted();
      return;
    }

    final mode = state.mode.isWork ? TimerMode.relax : TimerMode.work;
    final cycle = state.currentCycle + 1;
    final duration = _getDuration(mode, cycle);

    emit(
      state.copyWith(
        mode: mode,
        status: TimerStatus.paused,
        currentCycle: cycle,
        duration: duration,
        currentDuration: duration,
      ),
    );

    _tickerSubscription = _ticker
        .tick(ticks: state.duration)
        .listen(_mapTickerEventToState)
      ..pause();

    if (_pomodoroTimer.autoStart) {
      _tickerSubscription?.resume();
      emit(state.copyWith(status: TimerStatus.running));
    }
  }

  void stop() {
    _tickerSubscription?.cancel();

    final duration = _pomodoroTimer.workTime;

    emit(
      state.copyWith(
        duration: duration,
        status: TimerStatus.stopped,
        currentDuration: duration,
      ),
    );

    _streamController.add(TimerStoppedEvent());
  }

  void _mapTickerEventToState(int event) {
    if (event > 0) {
      emit(
        state.copyWith(
          status: TimerStatus.running,
          currentDuration: event,
        ),
      );
    } else {
      nextCycle();
    }
  }

  void _timerCompleted() {
    _tickerSubscription?.cancel();

    final duration = _pomodoroTimer.workTime;

    emit(
      state.copyWith(
        duration: duration,
        status: TimerStatus.stopped,
        mode: TimerMode.work,
        currentDuration: duration,
      ),
    );

    _streamController.add(TimerCompletedEvent());
  }

  int _getDuration(TimerMode mode, int cycle) {
    if (mode.isWork) {
      return _pomodoroTimer.workTime;
    }

    if (cycle ~/ 2 % _pomodoroTimer.longInterval == 0) {
      return _pomodoroTimer.longBreakTime;
    }

    return _pomodoroTimer.shortBreakTime;
  }
}

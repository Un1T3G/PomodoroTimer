part of 'timer_cubit.dart';

enum TimerStatus {
  stopped,
  running,
  paused,
  completed,
}

extension TimerStatisExtension on TimerStatus {
  bool get isPaused => this == TimerStatus.paused;
  bool get isStopped => this == TimerStatus.stopped;
}

enum TimerMode {
  work,
  relax,
}

extension TimerModeExtension on TimerMode {
  bool get isWork => this == TimerMode.work;
  String get asString => toString().split('.').last;
}

class TimerState {
  final int duration;
  final int currentDuration;
  final TimerMode mode;
  final TimerStatus status;
  final int currentCycle;

  TimerState({
    required this.duration,
    required this.currentDuration,
    required this.mode,
    required this.status,
    required this.currentCycle,
  });

  factory TimerState.initial() {
    return TimerState(
      duration: 0,
      currentDuration: 0,
      mode: TimerMode.work,
      status: TimerStatus.stopped,
      currentCycle: 0,
    );
  }

  TimerState copyWith({
    int? duration,
    int? currentDuration,
    TimerMode? mode,
    TimerStatus? status,
    int? currentCycle,
  }) {
    return TimerState(
      duration: duration ?? this.duration,
      currentDuration: currentDuration ?? this.currentDuration,
      mode: mode ?? this.mode,
      status: status ?? this.status,
      currentCycle: currentCycle ?? this.currentCycle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimerState &&
        other.duration == duration &&
        other.currentDuration == currentDuration &&
        other.mode == mode &&
        other.status == status &&
        other.currentCycle == currentCycle;
  }

  @override
  int get hashCode =>
      duration.hashCode ^
      currentDuration.hashCode ^
      mode.hashCode ^
      status.hashCode ^
      currentCycle.hashCode;
}

import 'package:hive_flutter/hive_flutter.dart';

part 'pomodoro_timer.g.dart';

@HiveType(typeId: 3)
class PomodoroTimer {
  @HiveField(0)
  final int workTime;
  @HiveField(1)
  final int shortBreakTime;
  @HiveField(2)
  final int longBreakTime;
  @HiveField(3)
  final int longInterval;
  @HiveField(4)
  final int workCycle;

  PomodoroTimer({
    required this.workTime,
    required this.shortBreakTime,
    required this.longBreakTime,
    required this.longInterval,
    required this.workCycle,
  });

  PomodoroTimer copyWith({
    int? workTime,
    int? shortBreakTime,
    int? longBreakTime,
    int? longInterval,
    int? workCycle,
  }) {
    return PomodoroTimer(
      workTime: workTime ?? this.workTime,
      shortBreakTime: shortBreakTime ?? this.shortBreakTime,
      longBreakTime: longBreakTime ?? this.longBreakTime,
      longInterval: longInterval ?? this.longInterval,
      workCycle: workCycle ?? this.workCycle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PomodoroTimer &&
        other.workTime == workTime &&
        other.shortBreakTime == shortBreakTime &&
        other.longBreakTime == longBreakTime &&
        other.longInterval == longInterval &&
        other.workCycle == workCycle;
  }

  @override
  int get hashCode {
    return workTime.hashCode ^
        shortBreakTime.hashCode ^
        longBreakTime.hashCode ^
        longInterval.hashCode ^
        workCycle.hashCode;
  }
}

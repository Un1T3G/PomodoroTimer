import 'package:hive_flutter/hive_flutter.dart';

part 'task_priority.g.dart';

@HiveType(typeId: 2)
enum TaskPriority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
}

import 'package:hive_ce/hive_ce.dart';

part 'assignment_model.g.dart';

@HiveType(typeId: 5)
class Assignment extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String module;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  DateTime? startTime;

  @HiveField(4)
  DateTime? deadline;

  @HiveField(5)
  String description;

  @HiveField(6)
  String location;

  @HiveField(7)
  String bookType;

  @HiveField(8)
  String assignmentType;

  Assignment({
    required this.title,
    required this.module,
    required this.date,
    required this.startTime,
    required this.deadline,
    required this.description,
    required this.location,
    required this.bookType,
    required this.assignmentType,
  });
}

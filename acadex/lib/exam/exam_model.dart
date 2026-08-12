import 'package:hive_ce/hive_ce.dart';

part 'exam_model.g.dart';

@HiveType(typeId: 8)
class Exam extends HiveObject {
  @HiveField(0)
  String module;

  @HiveField(1)
  DateTime? date;

  @HiveField(2)
  String location;

  @HiveField(3)
  DateTime? startTime;

  @HiveField(4)
  DateTime? endTime;

  Exam({
    required this.module,
    required this.date,
    required this.location,
    required this.startTime,
    required this.endTime,
  });
}

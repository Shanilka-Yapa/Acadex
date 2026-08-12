import 'package:hive_ce/hive_ce.dart';

part 'timetable_model.g.dart';

@HiveType(typeId: 6)
class TimetableModule extends HiveObject {
  @HiveField(0)
  int semesterNo;

  @HiveField(1)
  String code;

  @HiveField(2)
  String name;

  @HiveField(3)
  int colorValue;

  TimetableModule({
    required this.semesterNo,
    required this.code,
    required this.name,
    required this.colorValue,
  });
}

@HiveType(typeId: 7)
class TimetableSlot extends HiveObject {
  @HiveField(0)
  int moduleKey;

  @HiveField(1)
  String day;

  @HiveField(2)
  DateTime startTime;

  @HiveField(3)
  DateTime endTime;

  TimetableSlot({
    required this.moduleKey,
    required this.day,
    required this.startTime,
    required this.endTime,
  });
}

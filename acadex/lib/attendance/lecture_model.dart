import 'package:hive_ce/hive.dart';

part 'lecture_model.g.dart';

@HiveType(typeId: 2)
class Lecture extends HiveObject {
  @HiveField(0)
  int moduleKey;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  DateTime startTime;

  @HiveField(3)
  DateTime endTime;

  @HiveField(4)
  bool attended;

  Lecture({
    required this.moduleKey,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.attended,
  });

  double get durationHours => endTime.difference(startTime).inMinutes / 60.0;

  void update({
    required DateTime newStart,
    required DateTime newEnd,
    required bool status,
  }) {
    startTime = newStart;
    endTime = newEnd;
    attended = status;
    save();
  }
}

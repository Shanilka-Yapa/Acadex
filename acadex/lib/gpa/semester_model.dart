import 'package:hive_ce/hive.dart';

part 'semester_model.g.dart';

@HiveType(typeId: 3)
class Semester extends HiveObject {
  @HiveField(0)
  int semesterNo;

  @HiveField(1)
  double weight;

  Semester({required this.semesterNo, required this.weight});
}

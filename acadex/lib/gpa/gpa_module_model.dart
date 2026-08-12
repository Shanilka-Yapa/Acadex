import 'package:hive_ce/hive.dart';

part 'gpa_module_model.g.dart';

@HiveType(typeId: 4)
class GpaModule extends HiveObject {
  @HiveField(0)
  int semesterKey;

  @HiveField(1)
  String moduleCode;

  @HiveField(2)
  String moduleName;

  @HiveField(3)
  double credits;

  @HiveField(4)
  String grade;

  @HiveField(5)
  bool isGpa;

  GpaModule({
    required this.semesterKey,
    required this.moduleCode,
    required this.moduleName,
    required this.credits,
    required this.grade,
    required this.isGpa,
  });
}

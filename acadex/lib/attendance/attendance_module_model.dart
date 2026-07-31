import 'package:hive_ce/hive.dart';

part 'attendance_module_model.g.dart';

@HiveType(typeId: 1)
class AttendanceModule extends HiveObject {
  @HiveField(0)
  String moduleCode;

  @HiveField(1)
  String moduleName;

  AttendanceModule({required this.moduleCode, required this.moduleName});

  void update({required String code, required String name}) {
    moduleCode = code;
    moduleName = name;
    save();
  }
}

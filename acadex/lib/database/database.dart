import 'package:hive_ce_flutter/hive_flutter.dart';

import '../attendance/attendance_module_model.dart';
import '../profile/profile_model.dart';

class DatabaseService {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ProfileAdapter());
    Hive.registerAdapter(AttendanceModuleAdapter());

    await Hive.openBox<Profile>('profile');
    await Hive.openBox<AttendanceModule>('attendance');
  }
}

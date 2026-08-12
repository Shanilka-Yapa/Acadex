import 'package:hive_ce_flutter/hive_flutter.dart';

import '../attendance/attendance_module_model.dart';
import '../profile/profile_model.dart';
import '../attendance/lecture_model.dart';
import '../gpa/semester_model.dart';
import '../gpa/gpa_module_model.dart';
import '../timetable/timetable_model.dart';
import '../assignment/assignment_model.dart';

class DatabaseService {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ProfileAdapter());
    Hive.registerAdapter(AttendanceModuleAdapter());
    Hive.registerAdapter(LectureAdapter());
    Hive.registerAdapter(SemesterAdapter());
    Hive.registerAdapter(GpaModuleAdapter());
    Hive.registerAdapter(TimetableModuleAdapter());
    Hive.registerAdapter(TimetableSlotAdapter());
    Hive.registerAdapter(AssignmentAdapter());

    await Hive.openBox<Profile>('profile');
    await Hive.openBox<AttendanceModule>('attendance');
    await Hive.openBox<Lecture>('lectures');
    await Hive.openBox<Semester>('semesters');
    await Hive.openBox<GpaModule>('gpaModules');
    await Hive.openBox<TimetableModule>('timetableModules');
    await Hive.openBox<TimetableSlot>('timetableSlots');
    await Hive.openBox<Assignment>('assignments');
  }
}

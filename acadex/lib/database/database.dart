import 'package:hive_ce_flutter/hive_flutter.dart';

import '../profile/profile_model.dart';

class DatabaseService {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ProfileAdapter());

    await Hive.openBox<Profile>('profile');
  }
}

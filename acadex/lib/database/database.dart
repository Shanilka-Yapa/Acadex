import 'package:hive_ce_flutter/adapters.dart';

class DatabaseService {
  static Future<void> initialize() async {
    await Hive.initFlutter();
  }
}

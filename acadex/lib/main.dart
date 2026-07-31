import 'package:flutter/material.dart';

import 'app.dart';
import 'database/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseService.initialize();

  runApp(const AcadexApp());
}

import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'dashboard/dashboard.dart';
import 'profile/profile_model.dart';
import 'profile/profile_page.dart';

class AcadexApp extends StatelessWidget {
  const AcadexApp({super.key});

  @override
  Widget build(BuildContext context) {
    final profileBox = Hive.box<Profile>('profile');

    return MaterialApp(
      title: 'Acadex',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),

      themeMode: ThemeMode.system,

      home: profileBox.isNotEmpty ? const DashboardPage() : const ProfilePage(),
    );
  }
}

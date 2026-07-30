import 'package:flutter/material.dart';

class AcadexApp extends StatelessWidget {
  const AcadexApp({super.key});

  @override
  Widget build(BuildContext context) {
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

      home: const Placeholder(),
    );
  }
}

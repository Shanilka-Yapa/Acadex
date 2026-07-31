import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'attendance_module_model.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final moduleController = TextEditingController();

  void addModule() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Module"),
          content: TextField(
            controller: moduleController,
            decoration: const InputDecoration(labelText: "Module Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                final name = moduleController.text.trim();

                if (name.isEmpty) return;

                final box = Hive.box<AttendanceModule>('attendance');

                await box.add(AttendanceModule(moduleName: name));

                moduleController.clear();

                if (!mounted) return;

                Navigator.pop(context);
                setState(() {});
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<AttendanceModule>('attendance');

    return Scaffold(
      appBar: AppBar(title: const Text("Attendance")),

      floatingActionButton: FloatingActionButton(
        onPressed: addModule,
        child: const Icon(Icons.add),
      ),

      body: box.isEmpty
          ? const Center(child: Text("No modules added"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: box.length,
              itemBuilder: (context, index) {
                final module = box.getAt(index)!;

                return Card(
                  child: ListTile(
                    title: Text(module.moduleName),
                    subtitle: const Text("Attendance: 0%"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'attendance_module_model.dart';
import 'module_page.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final moduleController = TextEditingController();

  void addModule() {
    final codeController = TextEditingController();
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Module"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeController,
                decoration: const InputDecoration(labelText: "Module Code"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Module Name"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final code = codeController.text.trim();
                final name = nameController.text.trim();

                if (code.isEmpty || name.isEmpty) return;

                await Hive.box<AttendanceModule>(
                  'attendance',
                ).add(AttendanceModule(moduleCode: code, moduleName: name));

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
                    title: Text(module.moduleCode),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(module.moduleName),
                        const SizedBox(height: 4),
                        const Text("Attendance: 0%"),
                        const Text("0 / 0 Hours"),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ModulePage(
                            module: module,
                            moduleKey: box.keyAt(index) as int,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

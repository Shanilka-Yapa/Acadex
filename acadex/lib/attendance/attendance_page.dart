import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../app.dart';
import '../ui/acadex_visuals.dart';
import 'attendance_module_model.dart';
import 'lecture_model.dart';
import 'module_page.dart';
import '../timetable/timetable_model.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  TimetableModule? selectedTimetableModule;
  bool useOtherModule = false;

  void addModule() {
    final codeController = TextEditingController();
    final nameController = TextEditingController();

    final timetableBox = Hive.box<TimetableModule>('timetableModules');

    final attendanceBox = Hive.box<AttendanceModule>('attendance');

    final timetableModules = timetableBox.values.toList();

    TimetableModule? selectedModule = timetableModules.isNotEmpty
        ? timetableModules.first
        : null;

    bool otherModule = timetableModules.isEmpty;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Add Module"),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (timetableModules.isNotEmpty)
                      DropdownButtonFormField<String>(
                        initialValue: otherModule
                            ? "other"
                            : selectedModule!.key.toString(),

                        decoration: const InputDecoration(
                          labelText: "Select Module",
                        ),

                        items: [
                          ...timetableModules.map((module) {
                            return DropdownMenuItem<String>(
                              value: module.key.toString(),
                              child: Text("${module.code} - ${module.name}"),
                            );
                          }),

                          const DropdownMenuItem<String>(
                            value: "other",
                            child: Text("Other"),
                          ),
                        ],

                        onChanged: (value) {
                          setDialogState(() {
                            if (value == "other") {
                              otherModule = true;
                              selectedModule = null;
                            } else {
                              otherModule = false;

                              selectedModule = timetableModules.firstWhere(
                                (module) => module.key.toString() == value,
                              );

                              codeController.text = selectedModule!.code;

                              nameController.text = selectedModule!.name;
                            }
                          });
                        },
                      ),

                    if (timetableModules.isNotEmpty) const SizedBox(height: 16),

                    if (otherModule) ...[
                      TextField(
                        controller: codeController,
                        decoration: const InputDecoration(
                          labelText: "Module Code",
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Module Name",
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    String code;
                    String name;

                    if (otherModule) {
                      code = codeController.text.trim();
                      name = nameController.text.trim();

                      if (code.isEmpty || name.isEmpty) {
                        return;
                      }
                    } else {
                      code = selectedModule!.code;
                      name = selectedModule!.name;
                    }

                    await attendanceBox.add(
                      AttendanceModule(moduleCode: code, moduleName: name),
                    );

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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<AttendanceModule>('attendance');
    final lectureBox = Hive.box<Lecture>('lectures');

    return Scaffold(
      appBar: AppBar(title: const Text("Attendance")),

      floatingActionButton: FloatingActionButton(
        onPressed: addModule,
        child: const Icon(Icons.add),
      ),

      body: box.isEmpty
          ? const AcadexEmptyState(
              icon: Icons.how_to_reg_rounded,
              title: "No modules added",
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: box.length,

              itemBuilder: (context, index) {
                final module = box.getAt(index)!;

                double totalHours = 0;
                double presentHours = 0;

                final lectures = lectureBox.values
                    .where((lecture) => lecture.moduleKey == box.keyAt(index))
                    .toList();

                for (var lecture in lectures) {
                  totalHours += lecture.durationHours;

                  if (lecture.attended) {
                    presentHours += lecture.durationHours;
                  }
                }

                final percentage = totalHours == 0
                    ? 0
                    : (presentHours / totalHours) * 100;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),

                  child: ListTile(
                    leading: AcadexIconChip(
                      icon: Icons.fact_check_rounded,
                      backgroundColor: percentage >= 75
                          ? AcadexApp.success
                          : AcadexApp.primaryBlue,
                      size: 44,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      module.moduleCode,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(module.moduleName),

                        const SizedBox(height: 4),

                        Text("Attendance: ${percentage.toStringAsFixed(1)}%"),

                        Text(
                          "${presentHours.toStringAsFixed(1)} / "
                          "${totalHours.toStringAsFixed(1)} Hours",
                        ),
                      ],
                    ),

                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: "edit", child: Text("Edit")),

                        const PopupMenuItem(
                          value: "delete",
                          child: Text("Delete"),
                        ),
                      ],

                      onSelected: (value) async {
                        if (value == "delete") {
                          final lectureBox = Hive.box<Lecture>('lectures');

                          for (final lecture in lectureBox.values) {
                            if (lecture.moduleKey == box.keyAt(index)) {
                              await lecture.delete();
                            }
                          }

                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Delete Module?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text("Cancel"),
                                ),

                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await module.delete();

                            setState(() {});
                          }

                          setState(() {});
                        }

                        if (value == "edit") {
                          final codeController = TextEditingController(
                            text: module.moduleCode,
                          );

                          final nameController = TextEditingController(
                            text: module.moduleName,
                          );

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Edit Module"),

                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: codeController,
                                      decoration: const InputDecoration(
                                        labelText: "Module Code",
                                      ),
                                    ),

                                    TextField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        labelText: "Module Name",
                                      ),
                                    ),
                                  ],
                                ),

                                actions: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      module.moduleCode = codeController.text;

                                      module.moduleName = nameController.text;

                                      await module.save();

                                      if (!mounted) return;

                                      Navigator.pop(context);

                                      setState(() {});
                                    },

                                    child: const Text("Save"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),

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

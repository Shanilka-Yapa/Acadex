import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../app.dart';
import '../ui/acadex_visuals.dart';
import 'lecture_model.dart';
import 'attendance_module_model.dart';

class ModulePage extends StatefulWidget {
  final AttendanceModule module;
  final int moduleKey;

  const ModulePage({super.key, required this.module, required this.moduleKey});

  @override
  State<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  void addLecture() {
    DateTime? selectedDate;
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    bool attended = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Add Lecture"),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(
                      selectedDate == null
                          ? "Select Date"
                          : selectedDate.toString().split(" ")[0],
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                        initialDate: DateTime.now(),
                      );

                      if (date != null) {
                        setDialogState(() {
                          selectedDate = date;
                        });
                      }
                    },
                  ),

                  ListTile(
                    title: Text(
                      startTime == null
                          ? "Start Time"
                          : startTime!.format(context),
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final time = await showAcadexTimePicker(
                        context: context,
                        initialTime: startTime ?? TimeOfDay.now(),
                      );

                      if (time != null) {
                        setDialogState(() {
                          startTime = time;
                        });
                      }
                    },
                  ),

                  ListTile(
                    title: Text(
                      endTime == null ? "End Time" : endTime!.format(context),
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final time = await showAcadexTimePicker(
                        context: context,
                        initialTime: endTime ?? TimeOfDay.now(),
                      );

                      if (time != null) {
                        setDialogState(() {
                          endTime = time;
                        });
                      }
                    },
                  ),

                  SwitchListTile(
                    title: const Text("Attended"),
                    value: attended,
                    onChanged: (value) {
                      setDialogState(() {
                        attended = value;
                      });
                    },
                  ),
                ],
              ),
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
                    if (selectedDate == null ||
                        startTime == null ||
                        endTime == null) {
                      return;
                    }

                    final start = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      startTime!.hour,
                      startTime!.minute,
                    );

                    final end = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      endTime!.hour,
                      endTime!.minute,
                    );

                    await Hive.box<Lecture>('lectures').add(
                      Lecture(
                        moduleKey: widget.moduleKey,
                        date: selectedDate!,
                        startTime: start,
                        endTime: end,
                        attended: attended,
                      ),
                    );

                    if (!mounted) return;

                    Navigator.pop(context);
                  },

                  child: const Text("Save"),
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
    return Scaffold(
      appBar: AppBar(title: Text(widget.module.moduleCode)),
      floatingActionButton: AcadexGlassFab(
        onPressed: addLecture,
        tooltip: 'Add Lecture',
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Lecture>('lectures').listenable(),
        builder: (context, box, _) {
          final lectures = box.values
              .where((lecture) => lecture.moduleKey == widget.moduleKey)
              .toList();

          double totalHours = 0;
          double presentHours = 0;

          for (final lecture in lectures) {
            totalHours += lecture.durationHours;

            if (lecture.attended) {
              presentHours += lecture.durationHours;
            }
          }

          final absentHours = totalHours - presentHours;

          final attendance = totalHours == 0
              ? 0
              : (presentHours / totalHours) * 100;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        AcadexIconChip(
                          icon: Icons.event_available_rounded,
                          backgroundColor: attendance >= 75
                              ? AcadexApp.success
                              : AcadexApp.warning,
                          size: 56,
                          borderRadius: BorderRadius.circular(18),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${attendance.toStringAsFixed(2)}%",
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Present Hours : ${presentHours.toStringAsFixed(1)}",
                              ),
                              Text(
                                "Absent Hours : ${absentHours.toStringAsFixed(1)}",
                              ),
                              Text(
                                "Total Hours : ${totalHours.toStringAsFixed(1)}",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: lectures.isEmpty
                    ? const AcadexEmptyState(
                        icon: Icons.schedule_rounded,
                        title: "No lectures added",
                      )
                    : ListView.builder(
                        itemCount: lectures.length,
                        itemBuilder: (context, index) {
                          final lecture = lectures[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            child: ListTile(
                              leading: AcadexIconChip(
                                icon: lecture.attended
                                    ? Icons.check_rounded
                                    : Icons.close_rounded,
                                backgroundColor: lecture.attended
                                    ? AcadexApp.success
                                    : AcadexApp.warning,
                                size: 42,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              title: Text(
                                lecture.date.toString().split(" ")[0],
                              ),
                              subtitle: Text(
                                "${lecture.startTime.hour.toString().padLeft(2, '0')}:${lecture.startTime.minute.toString().padLeft(2, '0')} - "
                                "${lecture.endTime.hour.toString().padLeft(2, '0')}:${lecture.endTime.minute.toString().padLeft(2, '0')}",
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: "edit",
                                    child: Text("Edit"),
                                  ),

                                  const PopupMenuItem(
                                    value: "delete",
                                    child: Text("Delete"),
                                  ),
                                ],

                                onSelected: (value) async {
                                  if (value == "delete") {
                                    await lecture.delete();
                                  }

                                  if (value == "edit") {
                                    lecture.attended = !lecture.attended;

                                    await lecture.save();
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

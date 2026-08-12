import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'timetable_model.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  int? selectedSemester;
  int selectedDay = DateTime.now().weekday - 1;

  @override
  void initState() {
    super.initState();
    loadTimetable();
  }

  Future<void> loadTimetable() async {
    final box = Hive.box<TimetableModule>('timetableModules');

    if (box.isEmpty) return;

    final semesters =
        box.values.map((module) => module.semesterNo).toSet().toList()..sort();

    if (semesters.isNotEmpty) {
      setState(() {
        selectedSemester = semesters.last;
      });
    }
  }

  final days = const [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final moduleColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
  ];

  String formatTime(DateTime time) {
    return TimeOfDay.fromDateTime(time).format(context);
  }

  void selectSemester() {
    final controller = TextEditingController(
      text: selectedSemester?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Semester'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Semester Number'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text);

              if (value == null || value <= 0) return;

              setState(() {
                selectedSemester = value;
                selectedDay = 0;
              });

              Navigator.pop(context);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void addModule() {
    if (selectedSemester == null) {
      selectSemester();
      return;
    }

    final codeController = TextEditingController();
    final nameController = TextEditingController();

    final box = Hive.box<TimetableModule>('timetableModules');

    final color = moduleColors[box.length % moduleColors.length];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Module - Semester $selectedSemester'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(labelText: 'Module Code'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Module Name'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final code = codeController.text.trim();
              final name = nameController.text.trim();

              if (code.isEmpty || name.isEmpty) return;

              await box.add(
                TimetableModule(
                  semesterNo: selectedSemester!,
                  code: code,
                  name: name,
                  colorValue: color.toARGB32(),
                ),
              );

              if (!mounted) return;

              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void editModule(TimetableModule module) {
    final codeController = TextEditingController(text: module.code);

    final nameController = TextEditingController(text: module.name);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Module'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(labelText: 'Module Code'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Module Name'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final code = codeController.text.trim();
              final name = nameController.text.trim();

              if (code.isEmpty || name.isEmpty) return;

              module.code = code;
              module.name = name;

              await module.save();

              if (!mounted) return;

              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> deleteModule(TimetableModule module) async {
    final slotBox = Hive.box<TimetableSlot>('timetableSlots');

    final moduleKey = module.key as int;

    final relatedSlots = slotBox.values
        .where((slot) => slot.moduleKey == moduleKey)
        .toList();

    for (final slot in relatedSlots) {
      await slot.delete();
    }

    await module.delete();

    setState(() {});
  }

  Future<TimeOfDay?> pickTime(TimeOfDay initialTime) {
    return showTimePicker(context: context, initialTime: initialTime);
  }

  DateTime timeToDateTime(TimeOfDay time) {
    final now = DateTime.now();

    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  bool hasConflict({
    required int moduleKey,
    required String day,
    required DateTime start,
    required DateTime end,
    int? editingSlotKey,
  }) {
    final slotBox = Hive.box<TimetableSlot>('timetableSlots');

    final moduleBox = Hive.box<TimetableModule>('timetableModules');

    for (final slot in slotBox.values) {
      if (editingSlotKey != null && slot.key == editingSlotKey) {
        continue;
      }

      if (slot.day != day) continue;

      final slotModule = moduleBox.get(slot.moduleKey);

      if (slotModule == null) continue;

      if (slotModule.semesterNo != selectedSemester) {
        continue;
      }

      final overlaps =
          start.isBefore(slot.endTime) && end.isAfter(slot.startTime);

      if (overlaps) {
        return true;
      }
    }

    return false;
  }

  Future<void> addSlot() async {
    if (selectedSemester == null) {
      selectSemester();
      return;
    }

    final moduleBox = Hive.box<TimetableModule>('timetableModules');

    final slotBox = Hive.box<TimetableSlot>('timetableSlots');

    final modules = moduleBox.values
        .where((module) => module.semesterNo == selectedSemester)
        .toList();

    if (modules.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Add modules first')));
      return;
    }

    TimetableModule selectedModule = modules.first;

    String selectedDayName = days[selectedDay];

    TimeOfDay startTime = const TimeOfDay(hour: 8, minute: 0);

    TimeOfDay endTime = const TimeOfDay(hour: 10, minute: 0);

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Class'),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<TimetableModule>(
                      initialValue: selectedModule,
                      decoration: const InputDecoration(labelText: 'Module'),
                      items: modules.map((module) {
                        return DropdownMenuItem(
                          value: module,
                          child: Text('${module.code} - ${module.name}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setDialogState(() {
                          selectedModule = value;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      initialValue: selectedDayName,
                      decoration: const InputDecoration(labelText: 'Day'),
                      items: days.map((day) {
                        return DropdownMenuItem(value: day, child: Text(day));
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setDialogState(() {
                          selectedDayName = value;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    ListTile(
                      title: const Text('Start Time'),
                      subtitle: Text(startTime.format(context)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final picked = await pickTime(startTime);

                        if (picked == null) return;

                        setDialogState(() {
                          startTime = picked;
                        });
                      },
                    ),

                    ListTile(
                      title: const Text('End Time'),
                      subtitle: Text(endTime.format(context)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final picked = await pickTime(endTime);

                        if (picked == null) return;

                        setDialogState(() {
                          endTime = picked;
                        });
                      },
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    final start = timeToDateTime(startTime);

                    final end = timeToDateTime(endTime);

                    if (!end.isAfter(start)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('End time must be after start time'),
                        ),
                      );
                      return;
                    }

                    if (hasConflict(
                      moduleKey: selectedModule.key as int,
                      day: selectedDayName,
                      start: start,
                      end: end,
                    )) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'This time conflicts with another class',
                          ),
                        ),
                      );
                      return;
                    }

                    await slotBox.add(
                      TimetableSlot(
                        moduleKey: selectedModule.key as int,
                        day: selectedDayName,
                        startTime: start,
                        endTime: end,
                      ),
                    );

                    if (!mounted) return;

                    Navigator.pop(context);

                    setState(() {
                      selectedDay = days.indexOf(selectedDayName);
                    });
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> editSlot(TimetableSlot slot) async {
    final moduleBox = Hive.box<TimetableModule>('timetableModules');

    final modules = moduleBox.values
        .where((module) => module.semesterNo == selectedSemester)
        .toList();

    if (modules.isEmpty) return;

    TimetableModule selectedModule =
        moduleBox.get(slot.moduleKey) ?? modules.first;

    String selectedDayName = slot.day;

    TimeOfDay startTime = TimeOfDay.fromDateTime(slot.startTime);

    TimeOfDay endTime = TimeOfDay.fromDateTime(slot.endTime);

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Class'),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<TimetableModule>(
                      initialValue: selectedModule,
                      decoration: const InputDecoration(labelText: 'Module'),
                      items: modules.map((module) {
                        return DropdownMenuItem(
                          value: module,
                          child: Text('${module.code} - ${module.name}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setDialogState(() {
                          selectedModule = value;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      initialValue: selectedDayName,
                      decoration: const InputDecoration(labelText: 'Day'),
                      items: days.map((day) {
                        return DropdownMenuItem(value: day, child: Text(day));
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setDialogState(() {
                          selectedDayName = value;
                        });
                      },
                    ),

                    ListTile(
                      title: const Text('Start Time'),
                      subtitle: Text(startTime.format(context)),
                      onTap: () async {
                        final picked = await pickTime(startTime);

                        if (picked == null) return;

                        setDialogState(() {
                          startTime = picked;
                        });
                      },
                    ),

                    ListTile(
                      title: const Text('End Time'),
                      subtitle: Text(endTime.format(context)),
                      onTap: () async {
                        final picked = await pickTime(endTime);

                        if (picked == null) return;

                        setDialogState(() {
                          endTime = picked;
                        });
                      },
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    final start = timeToDateTime(startTime);

                    final end = timeToDateTime(endTime);

                    if (!end.isAfter(start)) {
                      return;
                    }

                    if (hasConflict(
                      moduleKey: selectedModule.key as int,
                      day: selectedDayName,
                      start: start,
                      end: end,
                      editingSlotKey: slot.key as int,
                    )) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'This time conflicts with another class',
                          ),
                        ),
                      );
                      return;
                    }

                    slot.moduleKey = selectedModule.key as int;
                    slot.day = selectedDayName;
                    slot.startTime = start;
                    slot.endTime = end;

                    await slot.save();

                    if (!mounted) return;

                    Navigator.pop(context);

                    setState(() {
                      selectedDay = days.indexOf(selectedDayName);
                    });
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> deleteSlot(TimetableSlot slot) async {
    await slot.delete();
    setState(() {});
  }

  Widget moduleCard(TimetableModule module) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Color(module.colorValue)),
        title: Text(module.code),
        subtitle: Text(module.name),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              editModule(module);
            }

            if (value == 'delete') {
              deleteModule(module);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }

  Widget slotCard(TimetableSlot slot, TimetableModule module) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Color(module.colorValue)),
        title: Text(
          module.code,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${module.name}\n'
          '${formatTime(slot.startTime)} - '
          '${formatTime(slot.endTime)}',
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              editSlot(slot);
            }

            if (value == 'delete') {
              deleteSlot(slot);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final moduleBox = Hive.box<TimetableModule>('timetableModules');

    final slotBox = Hive.box<TimetableSlot>('timetableSlots');

    final modules = selectedSemester == null
        ? <TimetableModule>[]
        : moduleBox.values
              .where((module) => module.semesterNo == selectedSemester)
              .toList();

    final selectedDayName = days[selectedDay];

    final slots =
        selectedSemester == null
              ? <TimetableSlot>[]
              : slotBox.values.where((slot) {
                  final module = moduleBox.get(slot.moduleKey);

                  return module != null &&
                      module.semesterNo == selectedSemester &&
                      slot.day == selectedDayName;
                }).toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
        actions: [
          IconButton(onPressed: selectSemester, icon: const Icon(Icons.school)),
        ],
      ),

      floatingActionButton: selectedSemester == null
          ? null
          : FloatingActionButton(
              onPressed: addSlot,
              child: const Icon(Icons.add),
            ),

      body: selectedSemester == null
          ? Center(
              child: ElevatedButton.icon(
                onPressed: selectSemester,
                icon: const Icon(Icons.school),
                label: const Text('Select Semester'),
              ),
            )
          : ValueListenableBuilder(
              valueListenable: moduleBox.listenable(),
              builder: (context, _, __) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Semester $selectedSemester',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: addModule,
                            icon: const Icon(Icons.add),
                            label: const Text('Module'),
                          ),
                        ],
                      ),
                    ),

                    if (modules.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: modules.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: 180,
                              child: moduleCard(modules[index]),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 8),

                    SizedBox(
                      height: 52,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: days.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(days[index]),
                              selected: selectedDay == index,
                              onSelected: (_) {
                                setState(() {
                                  selectedDay = index;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    const Divider(),

                    Expanded(
                      child: slots.isEmpty
                          ? Center(
                              child: Text(
                                'No classes on '
                                '$selectedDayName',
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: slots.length,
                              itemBuilder: (context, index) {
                                final slot = slots[index];

                                final module = moduleBox.get(slot.moduleKey);

                                if (module == null) {
                                  return const SizedBox();
                                }

                                return slotCard(slot, module);
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

import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../app.dart';
import '../ui/acadex_visuals.dart';
import 'exam_model.dart';
import '../timetable/timetable_model.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final examBox = Hive.box<Exam>('exams');

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String formatTime(DateTime time) {
    return TimeOfDay.fromDateTime(time).format(context);
  }

  String dateHeading(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final target = DateTime(date.year, date.month, date.day);

    final difference = target.difference(today).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';

    return formatDate(date);
  }

  Future<DateTime?> selectDate({DateTime? initialDate}) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
  }

  Future<TimeOfDay?> selectTime({TimeOfDay? initialTime}) {
    return showTimePicker(
      context: context,
      initialTime: initialTime ?? const TimeOfDay(hour: 8, minute: 0),
    );
  }

  Future<void> addExam() async {
    final timetableBox = Hive.box<TimetableModule>('timetableModules');

    final modules = timetableBox.values.toList();

    TimetableModule? selectedModule = modules.isNotEmpty ? modules.first : null;

    final otherModuleController = TextEditingController();

    final locationController = TextEditingController();

    DateTime? selectedDate;
    DateTime? startTime;
    DateTime? endTime;

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Exam'),

              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<TimetableModule?>(
                        initialValue: selectedModule,
                        decoration: const InputDecoration(labelText: 'Module'),
                        items: [
                          ...modules.map((module) {
                            return DropdownMenuItem<TimetableModule?>(
                              value: module,
                              child: Text('${module.code} - ${module.name}'),
                            );
                          }),
                          const DropdownMenuItem<TimetableModule?>(
                            value: null,
                            child: Text('Other'),
                          ),
                        ],
                        onChanged: (value) {
                          setDialogState(() {
                            selectedModule = value;
                          });
                        },
                      ),

                      if (selectedModule == null) ...[
                        const SizedBox(height: 12),

                        TextField(
                          controller: otherModuleController,
                          decoration: const InputDecoration(
                            labelText: 'Other Module',
                            hintText: 'Enter module name',
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),

                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Date'),
                        subtitle: Text(
                          selectedDate == null
                              ? 'Optional'
                              : formatDate(selectedDate!),
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await selectDate(
                            initialDate: selectedDate ?? DateTime.now(),
                          );

                          if (!mounted || picked == null) {
                            return;
                          }

                          setDialogState(() {
                            selectedDate = picked;
                          });
                        },
                      ),

                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Start Time'),
                        subtitle: Text(
                          startTime == null
                              ? 'Optional'
                              : formatTime(startTime!),
                        ),
                        trailing: const Icon(Icons.access_time),
                        onTap: () async {
                          final picked = await selectTime(
                            initialTime: const TimeOfDay(hour: 8, minute: 0),
                          );

                          if (!mounted || picked == null) {
                            return;
                          }

                          setDialogState(() {
                            startTime = DateTime(
                              2000,
                              1,
                              1,
                              picked.hour,
                              picked.minute,
                            );
                          });
                        },
                      ),

                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('End Time'),
                        subtitle: Text(
                          endTime == null ? 'Optional' : formatTime(endTime!),
                        ),
                        trailing: const Icon(Icons.access_time),
                        onTap: () async {
                          final picked = await selectTime(
                            initialTime: const TimeOfDay(hour: 10, minute: 0),
                          );

                          if (!mounted || picked == null) {
                            return;
                          }

                          setDialogState(() {
                            endTime = DateTime(
                              2000,
                              1,
                              1,
                              picked.hour,
                              picked.minute,
                            );
                          });
                        },
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          hintText: 'Optional',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    final moduleName = selectedModule == null
                        ? otherModuleController.text.trim()
                        : '${selectedModule!.code} - '
                              '${selectedModule!.name}';

                    if (moduleName.isEmpty) return;

                    await examBox.add(
                      Exam(
                        module: moduleName,
                        date: selectedDate,
                        location: locationController.text.trim(),
                        startTime: startTime,
                        endTime: endTime,
                      ),
                    );

                    if (!mounted) return;

                    Navigator.pop(context);
                    setState(() {});
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

  Future<void> deleteExam(Exam exam) async {
    await exam.delete();
    setState(() {});
  }

  Future<void> completeExam(Exam exam) async {
    await exam.delete();
    setState(() {});
  }

  List<Exam> examsForDate(DateTime date) {
    return examBox.values.where((exam) {
      if (exam.date == null) return false;

      return exam.date!.year == date.year &&
          exam.date!.month == date.month &&
          exam.date!.day == date.day;
    }).toList()..sort((a, b) {
      if (a.startTime == null && b.startTime == null) {
        return 0;
      }

      if (a.startTime == null) return 1;
      if (b.startTime == null) return -1;

      return a.startTime!.compareTo(b.startTime!);
    });
  }

  Widget examCard(Exam exam) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: SizedBox(
          width: 88,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AcadexIconChip(
                icon: Icons.menu_book_rounded,
                backgroundColor: exam.date == null
                    ? AcadexApp.warning
                    : AcadexApp.primaryBlue,
                size: 40,
                borderRadius: BorderRadius.circular(14),
              ),
              const SizedBox(width: 6),
              Checkbox(
                value: false,
                onChanged: (_) {
                  completeExam(exam);
                },
              ),
            ],
          ),
        ),

        title: Text(exam.module, style: Theme.of(context).textTheme.titleLarge),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (exam.startTime != null)
              Text('Start: ${formatTime(exam.startTime!)}'),

            if (exam.endTime != null) Text('End: ${formatTime(exam.endTime!)}'),

            if (exam.location.isNotEmpty) Text(exam.location),
          ],
        ),

        isThreeLine: true,

        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              deleteExam(exam);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }

  Widget undatedExamCard(Exam exam) {
    return examCard(exam);
  }

  @override
  Widget build(BuildContext context) {
    final allExams = examBox.values.toList();

    final datedExams = allExams.where((exam) => exam.date != null).toList();

    final undatedExams = allExams.where((exam) => exam.date == null).toList();

    final dates =
        datedExams
            .map(
              (exam) =>
                  DateTime(exam.date!.year, exam.date!.month, exam.date!.day),
            )
            .toSet()
            .toList()
          ..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Exams')),

      floatingActionButton: FloatingActionButton(
        onPressed: addExam,
        child: const Icon(Icons.add),
      ),

      body: allExams.isEmpty
          ? const AcadexEmptyState(
              icon: Icons.event_busy_rounded,
              title: 'No exams',
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...dates.map((date) {
                  final exams = examsForDate(date);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Text(
                          dateHeading(date),
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(letterSpacing: 0.8),
                        ),
                      ),

                      const Divider(),

                      ...exams.map(examCard),
                    ],
                  );
                }),

                if (undatedExams.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'No Date',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const Divider(),

                  ...undatedExams.map(undatedExamCard),
                ],
              ],
            ),
    );
  }
}

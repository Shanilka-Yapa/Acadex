import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../app.dart';
import '../ui/acadex_visuals.dart';
import 'assignment_model.dart';
import '../timetable/timetable_model.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({super.key});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  final box = Hive.box<Assignment>('assignments');

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

    if (difference == 0) {
      return 'Today';
    }

    if (difference == 1) {
      return 'Tomorrow';
    }

    if (difference == -1) {
      return 'Yesterday';
    }

    return formatDate(date);
  }

  Future<DateTime?> selectDate({DateTime? initialDate}) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
  }

  Future<TimeOfDay?> selectTime({TimeOfDay? initialTime}) async {
    return showAcadexTimePicker(
      context: context,
      initialTime: initialTime ?? const TimeOfDay(hour: 8, minute: 0),
    );
  }

  Future<void> addAssignment() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();

    final timetableBox = Hive.box<TimetableModule>('timetableModules');

    final timetableModules = timetableBox.values.toList();

    TimetableModule? selectedModule = timetableModules.isNotEmpty
        ? timetableModules.first
        : null;

    final otherModuleController = TextEditingController();

    DateTime selectedDate = DateTime.now();

    DateTime? startTime;
    DateTime? deadline;

    String bookType = 'Open Book';
    String assignmentType = 'Take Home';

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Assignment'),

              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Assignment Name *',
                        ),
                      ),

                      const SizedBox(height: 12),

                      DropdownButtonFormField<TimetableModule?>(
                        initialValue: selectedModule,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Module'),
                        items: [
                          ...timetableModules.map(
                            (module) => DropdownMenuItem<TimetableModule?>(
                              value: module,
                              child: Text(
                                '${module.code} - ${module.name}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
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
                        subtitle: Text(formatDate(selectedDate)),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await selectDate(
                            initialDate: selectedDate,
                          );

                          if (picked == null) return;

                          setDialogState(() {
                            selectedDate = picked;
                          });
                        },
                      ),

                      const SizedBox(height: 8),

                      DropdownButtonFormField<String>(
                        initialValue: assignmentType,
                        decoration: const InputDecoration(labelText: 'Type'),
                        items: const [
                          DropdownMenuItem(
                            value: 'Take Home',
                            child: Text('Take Home'),
                          ),
                          DropdownMenuItem(value: 'Quiz', child: Text('Quiz')),
                          DropdownMenuItem(
                            value: 'Essay Exam',
                            child: Text('Essay Exam'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;

                          setDialogState(() {
                            assignmentType = value;

                            if (value == 'Take Home') {
                              startTime = null;
                            } else {
                              deadline = null;
                            }
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      if (assignmentType == 'Take Home')
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Deadline'),
                          subtitle: deadline == null
                              ? const Text('Select deadline')
                              : Text(
                                  '${formatDate(deadline!)} '
                                  '${formatTime(deadline!)}',
                                ),
                          trailing: const Icon(Icons.event),
                          onTap: () async {
                            final pickedDate = await selectDate(
                              initialDate: deadline ?? selectedDate,
                            );

                            if (pickedDate == null) return;

                            final pickedTime = await selectTime(
                              initialTime: deadline == null
                                  ? const TimeOfDay(hour: 23, minute: 59)
                                  : TimeOfDay.fromDateTime(deadline!),
                            );

                            if (pickedTime == null) return;

                            setDialogState(() {
                              deadline = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          },
                        ),

                      if (assignmentType != 'Take Home')
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Start Time'),
                          subtitle: startTime == null
                              ? const Text('Select start time')
                              : Text(formatTime(startTime!)),
                          trailing: const Icon(Icons.access_time),
                          onTap: () async {
                            final picked = await selectTime(
                              initialTime: startTime == null
                                  ? const TimeOfDay(hour: 8, minute: 0)
                                  : TimeOfDay.fromDateTime(startTime!),
                            );

                            if (picked == null) return;

                            setDialogState(() {
                              startTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                picked.hour,
                                picked.minute,
                              );
                            });
                          },
                        ),

                      const SizedBox(height: 8),

                      DropdownButtonFormField<String>(
                        initialValue: bookType,
                        decoration: const InputDecoration(
                          labelText: 'Book Type',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Open Book',
                            child: Text('Open Book'),
                          ),
                          DropdownMenuItem(
                            value: 'Closed Book',
                            child: Text('Closed Book'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;

                          setDialogState(() {
                            bookType = value;
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: descriptionController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Description / Parts to Cover',
                          alignLabelWithHint: true,
                          hintText: 'Topics, chapters, parts to cover...',
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
                    final title = titleController.text.trim();

                    if (title.isEmpty) return;

                    await box.add(
                      Assignment(
                        title: title,
                        module: selectedModule == null
                            ? otherModuleController.text.trim()
                            : '${selectedModule!.code} - ${selectedModule!.name}',
                        date: selectedDate,
                        startTime: startTime,
                        deadline: deadline,
                        description: descriptionController.text.trim(),
                        location: locationController.text.trim(),
                        bookType: bookType,
                        assignmentType: assignmentType,
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

  Future<void> editAssignment(Assignment assignment) async {
    final titleController = TextEditingController(text: assignment.title);

    final moduleController = TextEditingController(text: assignment.module);

    final descriptionController = TextEditingController(
      text: assignment.description,
    );

    final locationController = TextEditingController(text: assignment.location);

    DateTime selectedDate = assignment.date;

    DateTime? startTime = assignment.startTime;

    DateTime? deadline = assignment.deadline;

    String bookType = assignment.bookType;

    String assignmentType = assignment.assignmentType;

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Assignment'),

              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Assignment Name *',
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: moduleController,
                        decoration: const InputDecoration(labelText: 'Module'),
                      ),

                      const SizedBox(height: 12),

                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Date'),
                        subtitle: Text(formatDate(selectedDate)),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await selectDate(
                            initialDate: selectedDate,
                          );

                          if (picked == null) return;

                          setDialogState(() {
                            selectedDate = picked;
                          });
                        },
                      ),

                      DropdownButtonFormField<String>(
                        initialValue: assignmentType,
                        decoration: const InputDecoration(labelText: 'Type'),
                        items: const [
                          DropdownMenuItem(
                            value: 'Take Home',
                            child: Text('Take Home'),
                          ),
                          DropdownMenuItem(value: 'Quiz', child: Text('Quiz')),
                          DropdownMenuItem(
                            value: 'Essay Exam',
                            child: Text('Essay Exam'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;

                          setDialogState(() {
                            assignmentType = value;

                            if (value == 'Take Home') {
                              startTime = null;
                            } else {
                              deadline = null;
                            }
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      if (assignmentType == 'Take Home')
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Deadline'),
                          subtitle: deadline == null
                              ? const Text('Select deadline')
                              : Text(
                                  '${formatDate(deadline!)} '
                                  '${formatTime(deadline!)}',
                                ),
                          trailing: const Icon(Icons.event),
                          onTap: () async {
                            final pickedDate = await selectDate(
                              initialDate: deadline ?? selectedDate,
                            );

                            if (pickedDate == null) {
                              return;
                            }

                            final pickedTime = await selectTime(
                              initialTime: deadline == null
                                  ? const TimeOfDay(hour: 23, minute: 59)
                                  : TimeOfDay.fromDateTime(deadline!),
                            );

                            if (pickedTime == null) {
                              return;
                            }

                            setDialogState(() {
                              deadline = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          },
                        ),

                      if (assignmentType != 'Take Home')
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Start Time'),
                          subtitle: startTime == null
                              ? const Text('Select start time')
                              : Text(formatTime(startTime!)),
                          trailing: const Icon(Icons.access_time),
                          onTap: () async {
                            final picked = await selectTime(
                              initialTime: startTime == null
                                  ? const TimeOfDay(hour: 8, minute: 0)
                                  : TimeOfDay.fromDateTime(startTime!),
                            );

                            if (picked == null) return;

                            setDialogState(() {
                              startTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                picked.hour,
                                picked.minute,
                              );
                            });
                          },
                        ),

                      const SizedBox(height: 8),

                      DropdownButtonFormField<String>(
                        initialValue: bookType,
                        decoration: const InputDecoration(
                          labelText: 'Book Type',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Open Book',
                            child: Text('Open Book'),
                          ),
                          DropdownMenuItem(
                            value: 'Closed Book',
                            child: Text('Closed Book'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;

                          setDialogState(() {
                            bookType = value;
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: descriptionController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Description / Parts to Cover',
                          alignLabelWithHint: true,
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
                    assignment.title = titleController.text.trim();

                    assignment.module = moduleController.text.trim();

                    assignment.date = selectedDate;

                    assignment.startTime = startTime;

                    assignment.deadline = deadline;

                    assignment.description = descriptionController.text.trim();

                    assignment.location = locationController.text.trim();

                    assignment.bookType = bookType;

                    assignment.assignmentType = assignmentType;

                    await assignment.save();

                    if (!mounted) return;

                    Navigator.pop(context);
                    setState(() {});
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

  Future<void> deleteAssignment(Assignment assignment) async {
    await assignment.delete();
    setState(() {});
  }

  Future<void> completeAssignment(Assignment assignment) async {
    await assignment.delete();
    setState(() {});
  }

  List<Assignment> assignmentsForDate(DateTime date) {
    return box.values.where((assignment) {
      return assignment.date.year == date.year &&
          assignment.date.month == date.month &&
          assignment.date.day == date.day;
    }).toList()..sort((a, b) {
      final aTime = a.startTime ?? a.deadline ?? a.date;

      final bTime = b.startTime ?? b.deadline ?? b.date;

      return aTime.compareTo(bTime);
    });
  }

  Widget assignmentCard(Assignment assignment) {
    final eventTime = assignment.startTime ?? assignment.deadline;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AcadexIconChip(
              icon: assignment.assignmentType == 'Take Home'
                  ? Icons.event_note_rounded
                  : Icons.quiz_rounded,
              backgroundColor: assignment.assignmentType == 'Take Home'
                  ? AcadexApp.secondaryPurple
                  : AcadexApp.accentCyan,
              size: 38,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(width: 4),
            Transform.scale(
              scale: 0.9,
              child: Checkbox(
                value: false,
                visualDensity: VisualDensity.compact,
                onChanged: (_) {
                  completeAssignment(assignment);
                },
              ),
            ),
          ],
        ),

        title: Text(
          assignment.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (assignment.module.isNotEmpty) Text(assignment.module),

            if (eventTime != null)
              Text(
                '${assignment.assignmentType} • '
                '${formatTime(eventTime)}',
              ),

            if (assignment.location.isNotEmpty) Text(assignment.location),
          ],
        ),

        isThreeLine: true,

        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              editAssignment(assignment);
            }

            if (value == 'delete') {
              deleteAssignment(assignment);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),

        onTap: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(assignment.title),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (assignment.module.isNotEmpty)
                      Text('Module: ${assignment.module}'),

                    const SizedBox(height: 8),

                    Text('Type: ${assignment.assignmentType}'),

                    const SizedBox(height: 8),

                    Text('Book: ${assignment.bookType}'),

                    const SizedBox(height: 8),

                    if (assignment.location.isNotEmpty)
                      Text('Location: ${assignment.location}'),

                    if (assignment.description.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Description:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(assignment.description),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget dateSection(DateTime date) {
    final assignments = assignmentsForDate(date);

    if (assignments.isEmpty) {
      return const SizedBox();
    }

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

        ...assignments.map(assignmentCard),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final assignments = box.values.toList();

    final dates =
        assignments
            .map(
              (assignment) => DateTime(
                assignment.date.year,
                assignment.date.month,
                assignment.date.day,
              ),
            )
            .toSet()
            .toList()
          ..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),

      floatingActionButton: AcadexGlassFab(
        onPressed: addAssignment,
        tooltip: 'Add Assignment',
      ),

      body: assignments.isEmpty
          ? const AcadexEmptyState(
              icon: Icons.assignment_outlined,
              title: 'No assignments',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dates.length,
              itemBuilder: (context, index) {
                return dateSection(dates[index]);
              },
            ),
    );
  }
}

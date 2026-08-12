import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'semester_model.dart';
import 'gpa_module_model.dart';
import 'grade_points.dart';
import 'semester_page.dart';

class GpaPage extends StatefulWidget {
  const GpaPage({super.key});

  @override
  State<GpaPage> createState() => _GpaPageState();
}

class _GpaPageState extends State<GpaPage> {
  void addSemester() {
    final semesterController = TextEditingController();
    final weightController = TextEditingController(text: "1.0");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Semester"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: semesterController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Semester Number"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: "Weight"),
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
              final sem = int.tryParse(semesterController.text);
              final weight = double.tryParse(weightController.text);

              if (sem == null || weight == null) return;

              await Hive.box<Semester>(
                'semesters',
              ).add(Semester(semesterNo: sem, weight: weight));

              if (!mounted) return;

              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final semesterBox = Hive.box<Semester>('semesters');
    final moduleBox = Hive.box<GpaModule>('gpaModules');

    double overallNum = 0;
    double overallDen = 0;

    return Scaffold(
      appBar: AppBar(title: const Text("GPA")),

      floatingActionButton: FloatingActionButton(
        onPressed: addSemester,
        child: const Icon(Icons.add),
      ),

      body: ValueListenableBuilder(
        valueListenable: semesterBox.listenable(),
        builder: (context, _, __) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Overall GPA Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Builder(
                    builder: (_) {
                      overallNum = 0;
                      overallDen = 0;

                      for (int i = 0; i < semesterBox.length; i++) {
                        final semester = semesterBox.getAt(i)!;
                        final semesterKey = semesterBox.keyAt(i);

                        final modules = moduleBox.values.where(
                          (m) => m.semesterKey == semesterKey && m.isGpa,
                        );

                        for (final module in modules) {
                          overallNum +=
                              semester.weight *
                              module.credits *
                              gradePoints[module.grade]!;

                          overallDen += semester.weight * module.credits;
                        }
                      }

                      final cgpa = overallDen == 0
                          ? 0
                          : overallNum / overallDen;

                      return Column(
                        children: [
                          const Text(
                            "Overall GPA",
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            cgpa.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ...List.generate(semesterBox.length, (index) {
                final semester = semesterBox.getAt(index)!;
                final semesterKey = semesterBox.keyAt(index);

                double num = 0;
                double den = 0;

                final modules = moduleBox.values.where(
                  (m) => m.semesterKey == semesterKey && m.isGpa,
                );

                for (final module in modules) {
                  num +=
                      semester.weight *
                      module.credits *
                      gradePoints[module.grade]!;

                  den += semester.weight * module.credits;
                }

                final gpa = den == 0 ? 0 : num / den;

                return Card(
                  child: ListTile(
                    title: Text("Semester ${semester.semesterNo}"),
                    subtitle: Text(
                      "Weight: ${semester.weight}\nGPA: ${gpa.toStringAsFixed(2)}",
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: "edit", child: Text("Edit")),
                        PopupMenuItem(value: "delete", child: Text("Delete")),
                      ],
                      onSelected: (value) async {
                        if (value == "edit") {
                          final semesterController = TextEditingController(
                            text: semester.semesterNo.toString(),
                          );

                          final weightController = TextEditingController(
                            text: semester.weight.toString(),
                          );

                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Edit Semester"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: semesterController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: "Semester Number",
                                    ),
                                  ),
                                  TextField(
                                    controller: weightController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    decoration: const InputDecoration(
                                      labelText: "Weight",
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () async {
                                    semester.semesterNo = int.parse(
                                      semesterController.text,
                                    );

                                    semester.weight = double.parse(
                                      weightController.text,
                                    );

                                    await semester.save();

                                    if (!mounted) return;

                                    Navigator.pop(context);

                                    setState(() {});
                                  },
                                  child: const Text("Save"),
                                ),
                              ],
                            ),
                          );
                        }

                        if (value == "delete") {
                          final modules = Hive.box<GpaModule>('gpaModules');

                          for (final module in modules.values) {
                            if (module.semesterKey == semesterKey) {
                              await module.delete();
                            }
                          }

                          await semester.delete();

                          setState(() {});
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SemesterPage(
                            semester: semester,
                            semesterKey: semesterKey as int,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../app.dart';
import '../ui/acadex_visuals.dart';
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
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: semesterController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Semester Number"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: "Weight"),
              ),
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

      floatingActionButton: AcadexGlassFab(
        onPressed: addSemester,
        tooltip: 'Add Semester',
      ),

      body: ValueListenableBuilder(
        valueListenable: semesterBox.listenable(),
        builder: (context, _, __) {
          return ValueListenableBuilder(
            valueListenable: moduleBox.listenable(),
            builder: (context, _, __) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Overall GPA Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(22),
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

                          return Row(
                            children: [
                              AcadexIconChip(
                                icon: Icons.analytics_rounded,
                                backgroundColor: AcadexApp.accentCyan,
                                size: 56,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Overall GPA",
                                      style: Theme.of(context).textTheme.titleMedium
                                          ?.copyWith(
                                            letterSpacing: 1.1,
                                            color: AcadexApp.textSecondary,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      cgpa.toStringAsFixed(2),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineLarge,
                                    ),
                                  ],
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
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: AcadexIconChip(
                          icon: Icons.school_rounded,
                          backgroundColor: AcadexApp.primaryBlue,
                          size: 44,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        title: Text(
                          "Semester ${semester.semesterNo}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "Weight: ${semester.weight}  •  GPA: ${gpa.toStringAsFixed(2)}",
                            style: const TextStyle(color: AcadexApp.secondaryText),
                          ),
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
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: semesterController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            labelText: "Semester Number",
                                          ),
                                        ),
                                        const SizedBox(height: 16),
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
                                      },
                                      child: const Text("Save"),
                                    ),
                                  ],
                                ),
                              );
                            }

                            if (value == "delete") {
                              final related = moduleBox.values
                                  .where((m) => m.semesterKey == semesterKey)
                                  .toList();

                              for (final m in related) {
                                await m.delete();
                              }

                              await semester.delete();
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
          );
        },
      ),
    );
  }
}

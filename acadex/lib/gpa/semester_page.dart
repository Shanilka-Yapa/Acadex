import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'semester_model.dart';
import 'gpa_module_model.dart';
import 'grade_points.dart';

class SemesterPage extends StatefulWidget {
  final Semester semester;
  final int semesterKey;

  const SemesterPage({
    super.key,
    required this.semester,
    required this.semesterKey,
  });

  @override
  State<SemesterPage> createState() => _SemesterPageState();
}

class _SemesterPageState extends State<SemesterPage> {
  final moduleBox = Hive.box<GpaModule>('gpaModules');

  void addModule() {
    final codeController = TextEditingController();
    final nameController = TextEditingController();
    final creditController = TextEditingController();

    String grade = "A";
    bool isGpa = true;

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

                    TextField(
                      controller: creditController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Credits"),
                    ),

                    DropdownButtonFormField(
                      initialValue: grade,

                      items: gradePoints.keys
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),

                      onChanged: (value) {
                        setDialogState(() {
                          grade = value!;
                        });
                      },

                      decoration: const InputDecoration(labelText: "Grade"),
                    ),

                    SwitchListTile(
                      title: const Text("Include in GPA"),

                      value: isGpa,

                      onChanged: (value) {
                        setDialogState(() {
                          isGpa = value;
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
                    final credits = double.tryParse(creditController.text);

                    if (codeController.text.isEmpty ||
                        nameController.text.isEmpty ||
                        credits == null) {
                      return;
                    }

                    await moduleBox.add(
                      GpaModule(
                        semesterKey: widget.semesterKey,

                        moduleCode: codeController.text,

                        moduleName: nameController.text,

                        credits: credits,

                        grade: grade,

                        isGpa: isGpa,
                      ),
                    );

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
      },
    );
  }

  double calculateGpa() {
    double num = 0;
    double den = 0;

    final modules = moduleBox.values.where(
      (m) => m.semesterKey == widget.semesterKey && m.isGpa,
    );

    for (final module in modules) {
      num +=
          widget.semester.weight * module.credits * gradePoints[module.grade]!;

      den += widget.semester.weight * module.credits;
    }

    return den == 0 ? 0 : num / den;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Semester ${widget.semester.semesterNo}")),

      floatingActionButton: FloatingActionButton(
        onPressed: addModule,

        child: const Icon(Icons.add),
      ),

      body: ValueListenableBuilder(
        valueListenable: moduleBox.listenable(),

        builder: (context, box, _) {
          final modules = box.values
              .where((m) => m.semesterKey == widget.semesterKey)
              .toList();

          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(16),

                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [
                      const Text(
                        "Semester GPA",
                        style: TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        calculateGpa().toStringAsFixed(2),

                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: modules.isEmpty
                    ? const Center(child: Text("No modules added"))
                    : ListView.builder(
                        itemCount: modules.length,

                        itemBuilder: (context, index) {
                          final module = modules[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),

                            child: ListTile(
                              title: Text(module.moduleCode),

                              subtitle: Text(
                                "${module.moduleName}\n"
                                "${module.credits} Credits | ${module.grade}",
                              ),

                              trailing: PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == "delete") {
                                    await module.delete();
                                    return;
                                  }

                                  if (value == "edit") {
                                    final codeController =
                                        TextEditingController(
                                          text: module.moduleCode,
                                        );

                                    final nameController =
                                        TextEditingController(
                                          text: module.moduleName,
                                        );

                                    final creditController =
                                        TextEditingController(
                                          text: module.credits.toString(),
                                        );

                                    String grade = module.grade;
                                    bool isGpa = module.isGpa;

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setDialogState) {
                                            return AlertDialog(
                                              title: const Text("Edit Module"),

                                              content: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          codeController,
                                                      decoration:
                                                          const InputDecoration(
                                                            labelText:
                                                                "Module Code",
                                                          ),
                                                    ),

                                                    TextField(
                                                      controller:
                                                          nameController,
                                                      decoration:
                                                          const InputDecoration(
                                                            labelText:
                                                                "Module Name",
                                                          ),
                                                    ),

                                                    TextField(
                                                      controller:
                                                          creditController,
                                                      keyboardType:
                                                          const TextInputType.numberWithOptions(
                                                            decimal: true,
                                                          ),
                                                      decoration:
                                                          const InputDecoration(
                                                            labelText:
                                                                "Credits",
                                                          ),
                                                    ),

                                                    DropdownButtonFormField<
                                                      String
                                                    >(
                                                      initialValue: grade,
                                                      items: gradePoints.keys
                                                          .map(
                                                            (g) =>
                                                                DropdownMenuItem(
                                                                  value: g,
                                                                  child: Text(
                                                                    g,
                                                                  ),
                                                                ),
                                                          )
                                                          .toList(),
                                                      onChanged: (value) {
                                                        setDialogState(() {
                                                          grade = value!;
                                                        });
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                            labelText: "Grade",
                                                          ),
                                                    ),

                                                    SwitchListTile(
                                                      title: const Text(
                                                        "Include in GPA",
                                                      ),
                                                      value: isGpa,
                                                      onChanged: (value) {
                                                        setDialogState(() {
                                                          isGpa = value;
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
                                                    final credits =
                                                        double.tryParse(
                                                          creditController.text,
                                                        );

                                                    if (credits == null) return;

                                                    module.moduleCode =
                                                        codeController.text;

                                                    module.moduleName =
                                                        nameController.text;

                                                    module.credits = credits;

                                                    module.grade = grade;

                                                    module.isGpa = isGpa;

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
                                      },
                                    );
                                  }
                                },

                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                    value: "edit",
                                    child: Text("Edit"),
                                  ),
                                  PopupMenuItem(
                                    value: "delete",
                                    child: Text("Delete"),
                                  ),
                                ],
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

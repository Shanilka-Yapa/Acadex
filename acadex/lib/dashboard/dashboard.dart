import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../app.dart';
import '../assignment/assignment.dart';
import '../assignment/assignment_model.dart';
import '../attendance/attendance_page.dart';
import '../attendance/attendance_module_model.dart';
import '../attendance/lecture_model.dart';
import '../exam/exam.dart';
import '../exam/exam_model.dart';
import '../gpa/gpa.dart';
import '../gpa/gpa_module_model.dart';
import '../gpa/semester_model.dart';
import '../profile/profile_model.dart';
import '../profile/profile_page.dart';
import '../timetable/timetable_model.dart';
import '../timetable/timetable.dart';
import '../ui/acadex_visuals.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Hive.box<Profile>('profile').getAt(0);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: AcadexAppLogo(size: 38, radius: 12),
        ),
        title: const Text('Acadex'),
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle_outlined),
            onSelected: (value) {
              if (value == 'delete-profile') {
                _confirmDeleteProfile(context);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'delete-profile',
                child: Text('Delete Profile'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AcadexApp.background,
              AcadexApp.surface.withValues(alpha: 0.65),
              AcadexApp.background,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
          children: [
            Text(
              'Hello, ${profile?.name ?? "User"}',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),
            _dashboardCard(
              context: context,
              icon: Icons.school_rounded,
              title: 'GPA',
              subtitle: 'No semesters added',
              page: const GpaPage(),
            ),
            _dashboardCard(
              context: context,
              icon: Icons.check_circle_outline,
              title: 'Attendance',
              subtitle: 'No attendance records',
              page: const AttendancePage(),
            ),
            _dashboardCard(
              context: context,
              icon: Icons.assignment_outlined,
              title: 'Assignments',
              subtitle: 'No assignments',
              page: const AssignmentPage(),
            ),
            _dashboardCard(
              context: context,
              icon: Icons.menu_book_outlined,
              title: 'Exams',
              subtitle: 'No exams',
              page: const ExamPage(),
            ),
            _dashboardCard(
              context: context,
              icon: Icons.schedule,
              title: 'Timetable',
              subtitle: 'No timetable',
              page: const TimetablePage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? page,
  }) {
    final accent = switch (title) {
      'GPA' => AcadexApp.primaryBlue,
      'Attendance' => AcadexApp.accentCyan,
      'Assignments' => AcadexApp.secondaryPurple,
      'Exams' => AcadexApp.warning,
      'Timetable' => AcadexApp.success,
      _ => AcadexApp.primaryBlue,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: page == null
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => page),
                );
              },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              AcadexIconChip(
                icon: icon,
                backgroundColor: accent,
                size: 48,
                borderRadius: BorderRadius.circular(16),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.72),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDeleteProfile(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Profile?'),
        content: const Text(
          'This will remove your profile and all saved Acadex data from the app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    await Hive.box<Profile>('profile').clear();
    await Hive.box<AttendanceModule>('attendance').clear();
    await Hive.box<Lecture>('lectures').clear();
    await Hive.box<Semester>('semesters').clear();
    await Hive.box<GpaModule>('gpaModules').clear();
    await Hive.box<TimetableModule>('timetableModules').clear();
    await Hive.box<TimetableSlot>('timetableSlots').clear();
    await Hive.box<Assignment>('assignments').clear();
    await Hive.box<Exam>('exams').clear();

    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const ProfilePage()),
      (route) => false,
    );
  }
}

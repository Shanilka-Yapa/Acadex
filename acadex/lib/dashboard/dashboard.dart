import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../attendance/attendance_page.dart';
import '../gpa/gpa.dart';
import '../profile/profile_model.dart';
import '../timetable/timetable.dart';
import '../assignment/assignment.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Hive.box<Profile>('profile').getAt(0);

    return Scaffold(
      appBar: AppBar(title: const Text('Acadex')),
      drawer: const Drawer(child: Center(child: Text('Menu'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Hello, ${profile?.name ?? "User"} 👋',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 24),

          _dashboardCard(
            context: context,
            icon: Icons.school,
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
    );
  }

 Widget _dashboardCard({
  required BuildContext context,
  required IconData icon,
  required String title,
  required String subtitle,
  Widget? page,
}) {
  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: page == null
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => page,
                ),
              );
            },
    ),
  );
  }
}

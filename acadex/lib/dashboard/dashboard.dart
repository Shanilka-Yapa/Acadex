import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../app.dart';
import '../assignment/assignment.dart';
import '../assignment/assignment_model.dart';
import '../attendance/attendance_module_model.dart';
import '../attendance/attendance_page.dart';
import '../attendance/lecture_model.dart';
import '../exam/exam.dart';
import '../exam/exam_model.dart';
import '../gpa/gpa.dart';
import '../gpa/gpa_module_model.dart';
import '../gpa/grade_points.dart';
import '../gpa/semester_model.dart';
import '../profile/profile_model.dart';
import '../profile/profile_page.dart';
import '../timetable/timetable.dart';
import '../timetable/timetable_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeTab(context),
      const TimetablePage(),
      const AttendancePage(),
      const GpaPage(),
      _buildMoreTab(context),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF071422).withValues(alpha: 0.85),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: AcadexApp.primaryAccent.withValues(alpha: 0.28),
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: AcadexApp.primaryAccent.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              backgroundColor: Colors.transparent,
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  );
                }
                return const TextStyle(
                  color: Color(0xFF8A99A8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                );
              }),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(color: Colors.white, size: 22);
                }
                return const IconThemeData(
                  color: Color(0xFF8A99A8),
                  size: 22,
                );
              }),
            ),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.access_time_outlined),
                  selectedIcon: Icon(Icons.access_time_filled),
                  label: 'Timetable',
                ),
                NavigationDestination(
                  icon: Icon(Icons.how_to_reg_outlined),
                  selectedIcon: Icon(Icons.how_to_reg),
                  label: 'Attendance',
                ),
                NavigationDestination(
                  icon: Icon(Icons.school_outlined),
                  selectedIcon: Icon(Icons.school),
                  label: 'GPA',
                ),
                NavigationDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(Icons.grid_view_rounded),
                  label: 'More',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // HOME TAB
  // ===========================================================================

  Widget _buildHomeTab(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: Hive.box<Profile>('profile').listenable(),
        builder: (context, profileBox, _) {
          final profile = profileBox.isNotEmpty ? profileBox.getAt(0) : null;
          final userName = profile?.name ?? 'Student';
          final firstLetter = userName.isNotEmpty
              ? userName[0].toUpperCase()
              : 'S';

          return ValueListenableBuilder(
            valueListenable: Hive.box<Semester>('semesters').listenable(),
            builder: (context, semesterBox, _) {
              return ValueListenableBuilder(
                valueListenable: Hive.box<GpaModule>('gpaModules').listenable(),
                builder: (context, gpaBox, _) {
                  return ValueListenableBuilder(
                    valueListenable:
                        Hive.box<AttendanceModule>('attendance').listenable(),
                    builder: (context, attendanceBox, _) {
                      return ValueListenableBuilder(
                        valueListenable:
                            Hive.box<Lecture>('lectures').listenable(),
                        builder: (context, lectureBox, _) {
                          return ValueListenableBuilder(
                            valueListenable:
                                Hive.box<Assignment>('assignments')
                                    .listenable(),
                            builder: (context, assignmentBox, _) {
                              return ValueListenableBuilder(
                                valueListenable:
                                    Hive.box<Exam>('exams').listenable(),
                                builder: (context, examBox, _) {
                                  return _buildHomeContent(
                                    context: context,
                                    userName: userName,
                                    firstLetter: firstLetter,
                                    semesterBox: semesterBox,
                                    gpaBox: gpaBox,
                                    attendanceBox: attendanceBox,
                                    lectureBox: lectureBox,
                                    assignmentBox: assignmentBox,
                                    examBox: examBox,
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHomeContent({
    required BuildContext context,
    required String userName,
    required String firstLetter,
    required Box<Semester> semesterBox,
    required Box<GpaModule> gpaBox,
    required Box<AttendanceModule> attendanceBox,
    required Box<Lecture> lectureBox,
    required Box<Assignment> assignmentBox,
    required Box<Exam> examBox,
  }) {
    // 1. Calculate GPA
    double totalQualityPoints = 0;
    double totalCredits = 0;

    final semesters = semesterBox.values.toList();
    final allModules = gpaBox.values.toList();

    for (final semester in semesters) {
      final semKey = semester.key as int?;
      final semModules = allModules.where(
        (m) => m.semesterKey == semKey && m.isGpa,
      );

      for (final m in semModules) {
        final gp = gradePoints[m.grade] ?? 0.0;
        totalQualityPoints += m.credits * gp * semester.weight;
        totalCredits += m.credits * semester.weight;
      }
    }

    final currentGpa = totalCredits > 0
        ? (totalQualityPoints / totalCredits)
        : 0.0;

    // 2. Calculate Attendance
    final lectures = lectureBox.values.toList();
    final totalLectures = lectures.length;
    final attendedLectures = lectures.where((l) => l.attended).length;
    final attendancePercent = totalLectures > 0
        ? ((attendedLectures / totalLectures) * 100).round()
        : 0;

    // 3. Calculate Tasks / Assignments & Exams
    final pendingAssignments = assignmentBox.values.toList();
    final pendingExams = examBox.values.toList();
    final taskCount = pendingAssignments.length + pendingExams.length;

    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning,'
        : hour < 17
            ? 'Good Afternoon,'
            : 'Good Evening,';

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        // Top Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: const TextStyle(
                    color: Color(0xFF8A99A8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userName,
                  style: const TextStyle(
                    color: AcadexApp.mainText,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            GestureMapAvatar(
              firstLetter: firstLetter,
              onTap: () => _showProfileMenu(context),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // GPA Banner Card
        InkWell(
          onTap: () => setState(() => _selectedIndex = 3),
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF0D3349),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AcadexApp.primaryAccent.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overall GPA',
                      style: TextStyle(
                        color: Color(0xFF8EC4D6),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      currentGpa.toStringAsFixed(2),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 2 Mini Stat Cards (Attendance & Tasks)
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _selectedIndex = 2),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F2636),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF1B3B52),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AcadexApp.primaryAccent
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.how_to_reg_rounded,
                          color: AcadexApp.primaryAccent,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '$attendancePercent%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Attendance',
                        style: TextStyle(
                          color: Color(0xFF8A99A8),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AssignmentPage(),
                  ),
                ),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F2636),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF1B3B52),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AcadexApp.primaryAccent
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.assignment_rounded,
                          color: AcadexApp.primaryAccent,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '$taskCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Tasks',
                        style: TextStyle(
                          color: Color(0xFF8A99A8),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 26),

        // Coming Up Section
        const Text(
          'Coming Up',
          style: TextStyle(
            color: AcadexApp.mainText,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF0F2636),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF1B3B52), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Assignments Item
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AssignmentPage()),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AcadexApp.primaryAccent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.assignment_rounded,
                        color: AcadexApp.primaryAccent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'ASSIGNMENTS',
                                style: TextStyle(
                                  color: AcadexApp.primaryAccent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                '${pendingAssignments.length} pending',
                                style: const TextStyle(
                                  color: Color(0xFF8A99A8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            pendingAssignments.isNotEmpty
                                ? pendingAssignments.first.title
                                : 'No pending assignments',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            pendingAssignments.isNotEmpty
                                ? (pendingAssignments.first.module.isNotEmpty
                                    ? pendingAssignments.first.module
                                    : 'Tap to view assignments')
                                : "You're all caught up!",
                            style: const TextStyle(
                              color: Color(0xFF8A99A8),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(
                  color: Color(0xFF1B3B52),
                  height: 1,
                  thickness: 1,
                ),
              ),

              // 2. Exams Item
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExamPage()),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AcadexApp.warning.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: AcadexApp.warning,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'EXAMS',
                                style: TextStyle(
                                  color: AcadexApp.warning,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                '${pendingExams.length} upcoming',
                                style: const TextStyle(
                                  color: Color(0xFF8A99A8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            pendingExams.isNotEmpty
                                ? pendingExams.first.module
                                : 'No upcoming exams',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            pendingExams.isNotEmpty
                                ? (pendingExams.first.date != null
                                    ? 'Date: ${pendingExams.first.date!.toString().split(" ")[0]}'
                                    : 'Date not set')
                                : "No exams scheduled",
                            style: const TextStyle(
                              color: Color(0xFF8A99A8),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 26),

        // Quick Actions Section
        const Text(
          'Quick Actions',
          style: TextStyle(
            color: AcadexApp.mainText,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),

        const SizedBox(height: 14),

        // 2x2 Grid of Quick Actions
        Row(
          children: [
            Expanded(
              child: _quickActionButton(
                icon: Icons.access_time_rounded,
                label: 'Timetable',
                onTap: () => setState(() => _selectedIndex = 1),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _quickActionButton(
                icon: Icons.how_to_reg_rounded,
                label: 'Attendance',
                onTap: () => setState(() => _selectedIndex = 2),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: _quickActionButton(
                icon: Icons.school_rounded,
                label: 'GPA',
                onTap: () => setState(() => _selectedIndex = 3),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _quickActionButton(
                icon: Icons.assignment_rounded,
                label: 'Assignments',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AssignmentPage(),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Exams Card
        Row(
          children: [
            Expanded(
              child: _quickActionButton(
                icon: Icons.event_note_rounded,
                label: 'Exams',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ExamPage(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: SizedBox.shrink(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF0F2636),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF1B3B52), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AcadexApp.primaryAccent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AcadexApp.primaryAccent,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // MORE TAB
  // ===========================================================================

  Widget _buildMoreTab(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        children: [
          const Text(
            'More',
            style: TextStyle(
              color: AcadexApp.mainText,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Manage your academic work',
            style: TextStyle(
              color: Color(0xFF8A99A8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          _moreMenuCard(
            context: context,
            icon: Icons.assignment_rounded,
            title: 'Assignments',
            subtitle: 'Manage tasks and deadlines',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AssignmentPage()),
            ),
          ),
          const SizedBox(height: 14),
          _moreMenuCard(
            context: context,
            icon: Icons.menu_book_rounded,
            title: 'Exams',
            subtitle: 'View upcoming examinations',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ExamPage()),
            ),
          ),
          const SizedBox(height: 14),
          _moreMenuCard(
            context: context,
            icon: Icons.account_circle_outlined,
            title: 'Profile Settings',
            subtitle: 'Update name or reset all data',
            onTap: () => _showProfileMenu(context),
          ),
        ],
      ),
    );
  }

  Widget _moreMenuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF0F2636),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1B3B52), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AcadexApp.primaryAccent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: AcadexApp.primaryAccent,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF8A99A8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF8A99A8),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F2636),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.white),
                  title: const Text(
                    'Edit Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    'Delete All Data & Reset',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    await _confirmDeleteProfile(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
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

class GestureMapAvatar extends StatelessWidget {
  final String firstLetter;
  final VoidCallback onTap;

  const GestureMapAvatar({
    super.key,
    required this.firstLetter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF0D3349),
          shape: BoxShape.circle,
          border: Border.all(
            color: AcadexApp.primaryAccent.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          firstLetter,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:student_app/announcement_page.dart';
import 'package:student_app/studentdrawer.dart';
import 'package:student_app/full_day_timetable.dart';
import 'package:student_app/theme_controller.dart';
import 'package:student_app/upcoming_exams_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentDrawerPage()),
              );
            },
          ),
        ),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeController.themeMode,
            builder: (context, themeMode, _) {
              final isDark = themeMode == ThemeMode.dark;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: Material(
                  color: isDark
                      ? const Color(0xFF6366F1) // Light purple for dark mode
                      : const Color(0xFFEFEFEF), // Light gray for light mode
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () {
                      ThemeController.toggleTheme();
                    },
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: Icon(
                        isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        color: isDark
                            ? Colors.white
                            : const Color(
                                0xFF333333,
                              ), // Dark gray for moon icon
                        size: 20,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Student Dashboard",
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              "Dashboards  >  Student Dashboard",
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 20),

            // Attendance Card
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Attendance",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),

                  _AttendanceTile(
                    icon: Icons.calendar_today,
                    iconColor: Colors.blue,
                    title: "Total Days",
                    value: "334",
                  ),
                  _AttendanceTile(
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                    title: "Present",
                    value: "111",
                  ),
                  _AttendanceTile(
                    icon: Icons.directions_run,
                    iconColor: Colors.cyan,
                    title: "Outings",
                    value: "2",
                  ),
                  _AttendanceTile(
                    icon: Icons.cancel,
                    iconColor: Colors.red,
                    title: "Absent",
                    value: "8",
                  ),
                  _AttendanceTile(
                    icon: Icons.event,
                    iconColor: Colors.amber,
                    title: "Holidays",
                    value: "0",
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Exam Stats Card
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Exam Stats",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),

                  _AttendanceTile(
                    icon: Icons.assignment,
                    iconColor: Colors.blue,
                    title: "Total Exam Questions",
                    value: "200",
                  ),
                  _AttendanceTile(
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                    title: "Total Attempted Questions",
                    value: "150",
                  ),
                  _AttendanceTile(
                    icon: Icons.close,
                    iconColor: Colors.amber,
                    title: "Total Not Attempted",
                    value: "50",
                  ),
                  _AttendanceTile(
                    icon: Icons.add_circle,
                    iconColor: Colors.cyan,
                    title: "Total +ve Questions",
                    value: "120",
                  ),
                  _AttendanceTile(
                    icon: Icons.remove_circle,
                    iconColor: Colors.red,
                    title: "Total -ve Questions",
                    value: "30",
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Rank Stats Card
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Rank Stats",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),

                  _RankTile(
                    icon: Icons.emoji_events,
                    iconColor: Colors.blue,
                    title: "Overall Rank",
                    value: "12",
                  ),
                  _RankTile(
                    icon: Icons.account_tree,
                    iconColor: Colors.green,
                    title: "Branch Wise Rank",
                    value: "3",
                  ),
                  _RankTile(
                    icon: Icons.groups,
                    iconColor: Colors.cyan,
                    title: "Group Wise Rank",
                    value: "5",
                  ),
                  _RankTile(
                    icon: Icons.menu_book,
                    iconColor: Colors.amber,
                    title: "Course Wise Rank",
                    value: "8",
                  ),
                  _RankTile(
                    icon: Icons.layers,
                    iconColor: Colors.red,
                    title: "Batch Wise Rank",
                    value: "2",
                    isLast: true,
                    isHighlighted: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Time Table Card
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade400
                              : Colors.grey.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Time Table",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Subject Cards
                  _TimeTableCard(
                    subject: "Maths",
                    time: "09:00 - 09:45",
                    instructor: "Mr. Ramesh",
                  ),
                  _TimeTableCard(
                    subject: "Physics",
                    time: "09:50 - 10:35",
                    instructor: "Ms. Anjali",
                  ),
                  _TimeTableCard(
                    subject: "Chemistry",
                    time: "10:40 - 11:25",
                    instructor: "Dr. Suresh",
                  ),
                  _TimeTableCard(
                    subject: "English",
                    time: "11:30 - 12:15",
                    instructor: "Mrs. Kavitha",
                    isLast: true,
                  ),

                  // View All Button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const FullDayTimetablePage(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Color(0xFF2563EB),
                          size: 18,
                        ),
                        label: const Text(
                          "View All",
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF2563EB),
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Class Attendance Chart Card
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Class Attendance (Month-wise Days)",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade800
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Last 6 M",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.more_vert, size: 20),
                          color: Colors.grey.shade700,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: _AttendanceChart(
                      months: ['Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'],
                      maxValue: 29,
                      data: [
                        {
                          'present': 15,
                          'absent': 3,
                          'outings': 2,
                          'holidays': 2,
                        },
                        {
                          'present': 18,
                          'absent': 2,
                          'outings': 1,
                          'holidays': 1,
                        },
                        {
                          'present': 20,
                          'absent': 1,
                          'outings': 1,
                          'holidays': 1,
                        },
                        {
                          'present': 17,
                          'absent': 4,
                          'outings': 2,
                          'holidays': 0,
                        },
                        {
                          'present': 19,
                          'absent': 2,
                          'outings': 1,
                          'holidays': 1,
                        },
                        {
                          'present': 16,
                          'absent': 3,
                          'outings': 2,
                          'holidays': 2,
                        },
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _LegendItem(
                          color: Colors.green,
                          label: "Present (Days)",
                        ),
                        _LegendItem(color: Colors.red, label: "Absent (Days)"),
                        _LegendItem(
                          color: Colors.amber,
                          label: "Outings (Days)",
                        ),
                        _LegendItem(color: Colors.blue, label: "Holidays"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Hostel Attendance Chart Card
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Hostel Attendance (Month-wise Days)",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade800
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Last 6 M",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.more_vert, size: 20),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade400
                              : Colors.grey.shade700,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: _AttendanceChart(
                      months: ['Aug', 'Sep', 'Oct', 'Nov'],
                      maxValue: 19,
                      data: [
                        {'present': 15, 'absent': 2},
                        {'present': 17, 'absent': 1},
                        {'present': 19, 'absent': 0},
                        {'present': 16, 'absent': 3},
                      ],
                      isHostel: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _LegendItem(
                          color: Colors.green,
                          label: "Present (Days)",
                        ),
                        _LegendItem(color: Colors.red, label: "Absent (Days)"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Remarks Card
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Remarks",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.blue.shade700,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "No remarks found",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Announcements Card
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Announcements",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                  _AnnouncementItem(
                    iconColor: Colors.blue,
                    text:
                        "Unit Test-2 will be conducted from 22nd July. Students are advised to...",
                    source: "Academic Office",
                  ),
                  _AnnouncementItem(
                    iconColor: Colors.cyan,
                    text:
                        "Hostel students must return to campus before 8:00 PM during....",
                    source: "Hostel Warden",
                  ),
                  _AnnouncementItem(
                    iconColor: Colors.green,
                    text:
                        "Tomorrow is a holiday on account of local festival celebrations.",
                    source: "Administration",
                  ),
                  _AnnouncementItem(
                    iconColor: Colors.amber,
                    text:
                        "All students should submit their assignment files by Friday without...",
                    source: "English Department",
                  ),
                  _AnnouncementItem(
                    iconColor: Colors.red,
                    text:
                        "Parents-Teachers meeting scheduled on Saturday at 10:00 AM.",
                    source: "Principal Office",
                    isLast: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AnnouncementsDialog(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.visibility, size: 18),
                        label: const Text(
                          "View All Announcements",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Upcoming Exams Card
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Upcoming Exams",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                  _ExamCard(
                    iconColor: Colors.blue,
                    title: "Mathematics Unit Test",
                    date: "22nd July, 2024",
                  ),
                  _ExamCard(
                    iconColor: Colors.cyan,
                    title: "Physics Monthly Assessment",
                    date: "28th July, 2024",
                  ),
                  _ExamCard(
                    iconColor: Colors.green,
                    title: "Chemistry Laboratory Exam",
                    date: "5th August, 2024",
                  ),
                  _ExamCard(
                    iconColor: Colors.amber,
                    title: "English Mid-Term Exam",
                    date: "12th August, 2024",
                    isHighlighted: true,
                  ),
                  _ExamCard(
                    iconColor: Colors.red,
                    title: "Computer Science Practical",
                    date: "18th August, 2024",
                    isLast: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UpcomingExams(
                                title: '',
                                date: '',
                                color: Colors.blue,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.remove_red_eye, size: 18),
                        label: const Text(
                          "View All Exams",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Student Calendar Card
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Student Calendar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                  const _CalendarWidget(),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "EVENTS THIS MONTH",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _EventListItem(
                    date: "1",
                    event: "Holiday",
                    color: Colors.green,
                  ),
                  _EventListItem(
                    date: "2",
                    event: "Math Exam",
                    color: Colors.red,
                  ),
                  _EventListItem(
                    date: "5",
                    event: "Nature Day",
                    color: Colors.green,
                  ),
                  _EventListItem(
                    date: "8",
                    event: "Music Fest",
                    color: Colors.orange,
                  ),
                  _EventListItem(
                    date: "8",
                    event: "Speech",
                    color: Colors.green,
                  ),
                  _EventListItem(
                    date: "12",
                    event: "Sports Meet",
                    color: Colors.blue,
                  ),
                  _EventListItem(
                    date: "15",
                    event: "Art Fair",
                    color: Colors.orange,
                  ),
                  _EventListItem(
                    date: "20",
                    event: "Plantation",
                    color: Colors.green,
                  ),
                  _EventListItem(
                    date: "25",
                    event: "Unit Test",
                    color: Colors.red,
                  ),
                  _EventListItem(
                    date: "28",
                    event: "Debate",
                    color: Colors.orange,
                  ),
                  _EventListItem(
                    date: "28",
                    event: "Dance",
                    color: Colors.orange,
                    isLast: true,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final bool isLast;

  const _AttendanceTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, isLast ? 16 : 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).cardColor.withOpacity(0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade700
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _RankTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final bool isLast;
  final bool isHighlighted;

  const _RankTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    this.isLast = false,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, isLast ? 16 : 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).cardColor.withOpacity(0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted
              ? iconColor
              : (Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade700
                    : Colors.grey.shade200),
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeTableCard extends StatelessWidget {
  final String subject;
  final String time;
  final String instructor;
  final bool isLast;

  const _TimeTableCard({
    required this.subject,
    required this.time,
    required this.instructor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final secondaryTextColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade400
        : Colors.grey.shade700;

    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, isLast ? 0 : 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).cardColor.withOpacity(0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assignment, color: Colors.blue, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  subject,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time, color: secondaryTextColor, size: 16),
              const SizedBox(width: 6),
              Text(
                time,
                style: TextStyle(fontSize: 14, color: secondaryTextColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person, color: secondaryTextColor, size: 16),
              const SizedBox(width: 6),
              Text(
                instructor,
                style: TextStyle(fontSize: 14, color: secondaryTextColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AttendanceChart extends StatelessWidget {
  final List<String> months;
  final int maxValue;
  final List<Map<String, int>> data;
  final bool isHostel;

  const _AttendanceChart({
    required this.months,
    required this.maxValue,
    required this.data,
    this.isHostel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Y-axis label
        Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                "No. of Days",
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 180,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Y-axis values
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        final value = maxValue - (index * (maxValue ~/ 5));
                        return Text(
                          value.toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(width: 8),
                    // Chart bars
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(months.length, (index) {
                          final monthData = data[index];
                          final total = monthData.values.reduce(
                            (a, b) => a + b,
                          );
                          final height = (total / maxValue) * 160;

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Stacked bars
                                  SizedBox(
                                    height: height,
                                    width: double.infinity,
                                    child: Stack(
                                      children: [
                                        // Present (Green) - bottom
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            height:
                                                (monthData['present']! /
                                                    maxValue) *
                                                160,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                    top: Radius.circular(4),
                                                  ),
                                            ),
                                          ),
                                        ),
                                        // Absent (Red)
                                        Positioned(
                                          bottom:
                                              (monthData['present']! /
                                                  maxValue) *
                                              160,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            height:
                                                (monthData['absent']! /
                                                    maxValue) *
                                                160,
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        // Outings (Yellow) - if exists
                                        if (!isHostel &&
                                            monthData['outings'] != null &&
                                            monthData['outings']! > 0)
                                          Positioned(
                                            bottom:
                                                ((monthData['present']! +
                                                        monthData['absent']!) /
                                                    maxValue) *
                                                160,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              height:
                                                  (monthData['outings']! /
                                                      maxValue) *
                                                  160,
                                              decoration: const BoxDecoration(
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ),
                                        // Holidays (Blue) - if exists
                                        if (!isHostel &&
                                            monthData['holidays'] != null &&
                                            monthData['holidays']! > 0)
                                          Positioned(
                                            bottom:
                                                ((monthData['present']! +
                                                        monthData['absent']! +
                                                        (monthData['outings'] ??
                                                            0)) /
                                                    maxValue) *
                                                160,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              height:
                                                  (monthData['holidays']! /
                                                      maxValue) *
                                                  160,
                                              decoration: const BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                      bottom: Radius.circular(
                                                        4,
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Month label
                                  Transform.rotate(
                                    angle: -0.3,
                                    child: Text(
                                      months[index],
                                      style: TextStyle(
                                        fontSize: 10,
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // X-axis label
        Padding(
          padding: const EdgeInsets.only(left: 38),
          child: Text(
            "Months",
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade400
                  : Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade400
                : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

class _AnnouncementItem extends StatelessWidget {
  final Color iconColor;
  final String text;
  final String source;
  final bool isLast;

  const _AnnouncementItem({
    required this.iconColor,
    required this.text,
    required this.source,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final secondaryTextColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade400
        : Colors.grey.shade600;

    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, isLast ? 0 : 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).cardColor.withOpacity(0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade700
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.campaign, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: secondaryTextColor),
                    const SizedBox(width: 4),
                    Text(
                      source,
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  final Color iconColor;
  final String title;
  final String date;
  final bool isLast;
  final bool isHighlighted;

  const _ExamCard({
    required this.iconColor,
    required this.title,
    required this.date,
    this.isLast = false,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final secondaryTextColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade400
        : Colors.grey.shade600;

    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, isLast ? 0 : 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).cardColor.withOpacity(0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted
              ? iconColor
              : (Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade700
                    : Colors.grey.shade200),
          width: isHighlighted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.edit_note, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: secondaryTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 13,
                        color: secondaryTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarWidget extends StatelessWidget {
  const _CalendarWidget();

  @override
  Widget build(BuildContext context) {
    // January 2026 - 1st is Thursday
    final month = "January 2026";
    final daysOfWeek = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

    // Events data: date -> list of colors
    final events = {
      1: [Colors.green],
      2: [Colors.red],
      5: [Colors.green],
      8: [Colors.orange, Colors.green],
      12: [Colors.blue],
      15: [Colors.orange],
      20: [Colors.green],
      25: [Colors.red],
      28: [Colors.orange, Colors.orange],
    };

    // January 2026 starts on Thursday (index 4)
    final firstDayOfWeek = 4;
    final daysInMonth = 31;

    // Generate calendar grid
    final calendarDays = <Widget>[];

    // Add empty cells for days before the 1st
    for (int i = 0; i < firstDayOfWeek; i++) {
      calendarDays.add(const SizedBox());
    }

    // Add days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final hasEvents = events.containsKey(day);
      final eventColors = events[day] ?? [];

      calendarDays.add(
        Column(
          children: [
            Text(
              day.toString(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            if (hasEvents) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: eventColors.take(2).map((color) {
                  return Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                ),
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade800
                      : Colors.grey.shade100,
                  shape: const CircleBorder(),
                ),
              ),
              Text(
                month,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                ),
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade800
                      : Colors.grey.shade100,
                  shape: const CircleBorder(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Days of week header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: daysOfWeek.map((day) {
              final isHighlighted = day == 'SAT';
              return Expanded(
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isHighlighted
                        ? const Color(0xFF2563EB)
                        : (Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade400
                              : Colors.grey.shade700),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: calendarDays.length,
            itemBuilder: (context, index) {
              return calendarDays[index];
            },
          ),
        ],
      ),
    );
  }
}

class _EventListItem extends StatelessWidget {
  final String date;
  final String event;
  final Color color;
  final bool isLast;

  const _EventListItem({
    required this.date,
    required this.event,
    required this.color,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, isLast ? 0 : 8),
      child: Row(
        children: [
          Text(
            date,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              event,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade400
                    : Colors.grey.shade700,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

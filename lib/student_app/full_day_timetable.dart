import 'package:flutter/material.dart';
import 'package:student_app/student_app/weekly_timetable.dart';
import 'package:student_app/theme_controllers.dart';

class FullDayTimetablePage extends StatelessWidget {
  const FullDayTimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeControllerWrapper(
      themeController: StudentThemeController.themeMode,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF2563EB)),
                onPressed: () => Navigator.pop(context),
              ),
              title: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Color(0xFF2563EB),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Full Day Time Table",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildTimetableItem(
                    context,
                    "Maths",
                    "09:00 - 09:45 AM",
                    "Mr. Ramesh",
                  ),
                  _buildTimetableItem(
                    context,
                    "Physics",
                    "09:50 - 10:35 AM",
                    "Ms. Anjali",
                  ),
                  _buildTimetableItem(
                    context,
                    "Chemistry",
                    "10:40 - 11:25 AM",
                    "Dr. Suresh",
                  ),
                  _buildTimetableItem(
                    context,
                    "English",
                    "11:30 - 12:15 PM",
                    "Mrs. Kavitha",
                  ),
                  _buildTimetableItem(
                    context,
                    "Biology",
                    "12:20 - 01:05 PM",
                    "Dr. Naveen",
                  ),
                  _buildTimetableItem(
                    context,
                    "Lunch Break",
                    "01:05 - 02:00 PM",
                    "-",
                    isBreak: true,
                  ),
                  _buildTimetableItem(
                    context,
                    "Social Studies",
                    "02:00 - 02:45 PM",
                    "Mr. Vikram",
                  ),
                  _buildTimetableItem(
                    context,
                    "Hindi",
                    "02:50 - 03:35 PM",
                    "Ms. Sunita",
                  ),
                  _buildTimetableItem(
                    context,
                    "Computer Science",
                    "03:40 - 04:25 PM",
                    "Mr. Arvind",
                    isLast: true,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WeeklyTimetablePage(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.calendar_view_week,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "View Weekly Time Table",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimetableItem(
    BuildContext context,
    String subject,
    String time,
    String instructor, {
    bool isBreak = false,
    bool isLast = false,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: isBreak ? Colors.grey : const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$time • $instructor",
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 28,
            color: theme.dividerColor.withOpacity(0.1),
          ),
      ],
    );
  }
}

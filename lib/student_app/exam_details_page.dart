import 'package:flutter/material.dart';
import 'package:student_app/theme_controllers.dart';

// This page displays the details of a specific exam.
class ExamDetailsPage extends StatelessWidget {
  final Map<String, dynamic> exam;

  const ExamDetailsPage({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return ThemeControllerWrapper(
      themeController: StudentThemeController.themeMode,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          final isDark = theme.brightness == Brightness.dark;

          final String examName = exam['exam_name'] ?? exam['title'] ?? 'N/A';
          final String subject = exam['subject'] ?? 'N/A';
          final String branch = exam['branch'] ?? 'SSJC-VIDHYA BHAVAN';
          final String examType = exam['exam_type'] ?? 'Online Exam';
          final String duration = exam['duration'] ?? '-';
          final String examId = exam['exam_id']?.toString() ?? 'N/A';
          final String date = exam['date'] ?? '2024-03-15 at 10:00 AM';

          return Scaffold(
            backgroundColor: isDark ? Colors.black : Colors.grey[100],
            appBar: AppBar(
              backgroundColor: isDark ? Colors.black : Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text(
                "Details: $examName",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tabs simulation
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                        child: Text(
                          "Details",
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(height: 3, width: 60, color: Colors.blue[700]),
                      const SizedBox(height: 20),
                    ],
                  ),

                  // Table Card
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? theme.cardColor : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildRow(context, "Subject", subject, isDark),
                        _buildDivider(isDark),
                        _buildRow(context, "Branch", branch, isDark),
                        _buildDivider(isDark),
                        _buildRow(context, "Exam Type", examType, isDark),
                        _buildDivider(isDark),
                        _buildRow(context, "Duration", duration, isDark),
                        _buildDivider(isDark),
                        _buildRow(
                          context,
                          "Exam ID",
                          examId,
                          isDark,
                          valueColor: const Color(0xFFD81B60),
                        ),
                        _buildDivider(isDark),
                        _buildRow(context, "Date", date, isDark, isLast: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Instructions
                  Text(
                    "Instructions",
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white70 : Colors.black87,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Standard exam instructions apply.",
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String label,
    String value,
    bool isDark, {
    Color? valueColor,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            width: 140,
            padding: const EdgeInsets.all(16),
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white60 : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          VerticalDivider(
            width: 1,
            color: isDark ? Colors.grey[800] : Colors.grey[300],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                value,
                style: TextStyle(
                  color: valueColor ?? (isDark ? Colors.white : Colors.black87),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? Colors.grey[800] : Colors.grey[300],
    );
  }
}

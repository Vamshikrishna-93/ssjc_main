import 'package:flutter/material.dart';
import 'package:student_app/student_app/model/exam_item.dart';
import 'package:student_app/student_app/marks_grades_page.dart';
import 'package:student_app/student_app/services/exams_service.dart';

class CompletedExamCard extends StatelessWidget {
  final ExamModel exam;
  final VoidCallback onViewScoreCard;

  const CompletedExamCard({
    super.key,
    required this.exam,
    required this.onViewScoreCard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Exam Name column (Title, Board, ID)
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                    children: [
                      TextSpan(text: exam.board),
                      const TextSpan(text: " • Online"),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Exam ID in pink/red
                Text(
                  "Exam ID: ${exam.id}",
                  style: TextStyle(
                    color: isDark
                        ? Colors.pinkAccent.shade100
                        : Colors.pink[300],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 2. Marks
          Expanded(
            flex: 1,
            child: Text(
              exam.marks ?? "-",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),

          // 3. Percentage
          Expanded(
            flex: 2,
            child: Text(
              exam.percentage ?? "-",
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),

          // 4. Grade & Rank
          Expanded(
            flex: 2,
            child: Row(
              children: [
                // Grade Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    exam.grade ?? "-",
                    style: TextStyle(
                      color: isDark
                          ? Colors.amber.shade200
                          : Colors.amber.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Rank Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.cyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "Rank: ${exam.rank ?? 'N/A'}",
                    style: TextStyle(
                      color: isDark
                          ? Colors.cyan.shade200
                          : Colors.cyan.shade800,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 5. Performance
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  exam.performance ?? "Good",
                  style: TextStyle(
                    color: isDark
                        ? Colors.orange.shade200
                        : Colors.orange.shade800,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),

          // 6. Actions
          Expanded(
            flex: 3,
            child: Row(
              children: [
                // Marks
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MarksGradesPage(examId: exam.id, exam: {}),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bar_chart,
                            size: 14,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Marks",
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Score Card (Color Button)
                Expanded(
                  child: InkWell(
                    onTap: onViewScoreCard,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Score Card",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Download
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      try {
                        final data = await ExamsService.downloadExamReport(
                          exam.id,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Report downloaded (${(data.length / 1024).toStringAsFixed(2)} KB)",
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Failed to download: $e"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.download,
                            size: 14,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Download",
                            style: TextStyle(
                              fontSize: 10,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

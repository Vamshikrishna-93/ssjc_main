import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HeaderCell extends StatelessWidget {
  final String title;
  final int flex;
  final bool centered;
  final bool alignRight;

  const HeaderCell({
    super.key,
    required this.title,
    required this.flex,
    this.centered = false,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignRight
            ? Alignment.centerRight
            : centered
            ? Alignment.center
            : Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min, // 🔑 prevents overflow
          children: [
            Flexible(
              // 🔑 allows text to shrink
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.swap_vert,
              size: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade400
                  : Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }
}

class MarksStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final String description;

  const MarksStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.valueColor,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class PerformanceTrendChart extends StatelessWidget {
  const PerformanceTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [75.0, 80.0, 88.0, 85.0, 87.0, 90.0];
    const maxValue = 100.0;
    const minValue = 0.0;

    return CustomPaint(
      painter: LineChartPainter(data, maxValue, minValue),
      child: Container(),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> data;
  final double maxValue;
  final double minValue;

  LineChartPainter(this.data, this.maxValue, this.minValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    // Draw grid lines
    for (int i = 0; i <= 4; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw data points and line
    if (data.isNotEmpty) {
      final points = <Offset>[];
      for (int i = 0; i < data.length; i++) {
        final x = (size.width / (data.length - 1)) * i;
        final normalizedValue = (data[i] - minValue) / (maxValue - minValue);
        final y = size.height - (normalizedValue * size.height);
        points.add(Offset(x, y));
      }

      // Draw line
      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);

      // Draw points
      for (final point in points) {
        canvas.drawCircle(point, 5, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GradeDistributionChart extends StatelessWidget {
  const GradeDistributionChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 0,
        startDegreeOffset: -90,
        sections: _sections(),
      ),
    );
  }

  List<PieChartSectionData> _sections() {
    return [
      PieChartSectionData(
        value: 38,
        color: const Color(0xFF7ED33C), // A
        radius: 70,
        title: "A: 38%",
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF7ED33C),
        ),
        titlePositionPercentageOffset: 1.3,
      ),
      PieChartSectionData(
        value: 25,
        color: const Color(0xFF58C313), // A+
        radius: 70,
        title: "A+: 25%",
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF58C313),
        ),
        titlePositionPercentageOffset: 1.3,
      ),
      PieChartSectionData(
        value: 12,
        color: const Color(0xFFFF6B6B), // C+
        radius: 70,
        title: "C+: 12%",
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFFFF6B6B),
        ),
        titlePositionPercentageOffset: 1.3,
      ),
      PieChartSectionData(
        value: 13,
        color: const Color(0xFFFFC066), // B
        radius: 70,
        title: "B: 13%",
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFFFFC066),
        ),
        titlePositionPercentageOffset: 1.3,
      ),
      PieChartSectionData(
        value: 12,
        color: const Color(0xFFFFA63A), // B+
        radius: 70,
        title: "B+: 12%",
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFFFFA63A),
        ),
        titlePositionPercentageOffset: 1.3,
      ),
    ];
  }
}

class SubjectRow extends StatelessWidget {
  final String subject;
  final String marks;
  final int percentage;
  final String grade;
  final Color gradeColor;
  final bool isExcellent;

  const SubjectRow({
    super.key,
    required this.subject,
    required this.marks,
    required this.percentage,
    required this.grade,
    required this.gradeColor,
    this.isExcellent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          // Subject
          Expanded(
            flex: 3,
            child: Text(
              subject,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Marks Obtained (FIXED)
          Expanded(
            flex: 3,
            child: Center(
              child: FittedBox(
                // 🔑 prevents overflow
                fit: BoxFit.scaleDown,
                child: Text(
                  marks,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),

          // Percentage (FIXED)
          Expanded(
            flex: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isExcellent ? Colors.green : Colors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isExcellent)
                      const Icon(
                        Icons.check_circle,
                        size: 14,
                        color: Colors.green,
                      ),
                    if (isExcellent) const SizedBox(width: 4),
                    Text(
                      "$percentage%",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Grade
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: gradeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  grade,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: gradeColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExamHistoryRow extends StatelessWidget {
  final String examName;
  final String marks;
  final String percentage;
  final String grade;
  final String rank;
  final Color gradeColor;
  final Color rankColor;

  const ExamHistoryRow({
    super.key,
    required this.examName,
    required this.marks,
    required this.percentage,
    required this.grade,
    required this.rank,
    required this.gradeColor,
    required this.rankColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade700
              : Colors.grey.shade200,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              examName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              marks,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              percentage,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: gradeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                grade,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: gradeColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              rank,
              style: TextStyle(fontSize: 12, color: rankColor),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class AchievementCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final Color backgroundColor;

  const AchievementCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? iconColor.withValues(alpha: 0.1) : backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
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

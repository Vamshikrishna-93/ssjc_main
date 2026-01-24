import 'package:flutter/material.dart';

class HostelMonthDetailPage extends StatefulWidget {
  final Map<String, dynamic> monthData;

  const HostelMonthDetailPage({super.key, required this.monthData});

  @override
  State<HostelMonthDetailPage> createState() => _HostelMonthDetailPageState();
}

class _HostelMonthDetailPageState extends State<HostelMonthDetailPage> {
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  // Sample data - replace with actual data from widget.monthData
  final String hostelName = "ADARSA";
  final String floor = "2ND FLOOR A&B BLOCKS";
  final String room = "B-204";
  final String warden = "JENNIPOGU ABHI RAM";

  List<Map<String, dynamic>> get attendanceDetails {
    // Generate attendance details from month data
    // For now, return sample data - you can replace this with actual API data
    final monthData = widget.monthData;
    final int presentNights = monthData['present'] ?? 0;

    if (presentNights == 0) {
      return [];
    }

    // Sample data - replace with actual data from API
    return [
      {
        'date': '30 Saturday',
        'checkType': 'Hostel Stay',
        'time': 'Night Roll Call',
        'warden': 'Hostel Incharge',
        'status': 'Present',
        'remark': 'Stayed in hostel',
      },
    ];
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  int _calculatePerformanceStars(double percentage) {
    if (percentage >= 90) return 5;
    if (percentage >= 80) return 4;
    if (percentage >= 70) return 3;
    if (percentage >= 60) return 2;
    return 1;
  }

  String _getPerformanceText(double percentage) {
    if (percentage >= 90) return 'Excellent';
    if (percentage >= 80) return 'Very Good';
    if (percentage >= 70) return 'Good';
    if (percentage >= 60) return 'Average';
    return 'Needs Improvement';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final monthData = widget.monthData;

    final int totalRecordedNights = monthData['total'] ?? 0;
    final int presentNights = monthData['present'] ?? 0;
    final int absentNights = monthData['absent'] ?? 0;
    final int leaveNights = monthData['leaves'] ?? 0;
    final int holidayNights = monthData['holidays'] ?? 0;
    final int nightOuts = monthData['nightOuts'] ?? 0;
    final double attendancePercentage = monthData['percentage'] ?? 0.0;
    final int totalNights = monthData['total'] ?? 0;

    final int performanceStars = _calculatePerformanceStars(
      attendancePercentage,
    );
    final String performanceText = _getPerformanceText(attendancePercentage);

    return Scaffold(
      backgroundColor: isDark
          ? Colors.grey.shade900.withValues(alpha: 0.95)
          : Colors.grey.shade300.withValues(alpha: 0.95),
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 900, maxHeight: 850),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header with title
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Night-wise hostel stay breakdown',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                // Scrollable content
                Expanded(
                  child: Scrollbar(
                    controller: _verticalScrollController,
                    thumbVisibility: true,
                    thickness: 8,
                    radius: const Radius.circular(4),
                    child: SingleChildScrollView(
                      controller: _verticalScrollController,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hostel Information Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E3A5F)
                                  : const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? Colors.blue.shade700
                                    : const Color(0xFFBFDBFE),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hostel Information',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? Colors.blue.shade200
                                        : const Color(0xFF1E3A5F),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildInfoRow('Hostel', hostelName, isDark),
                                const SizedBox(height: 12),
                                _buildInfoRow('Floor', floor, isDark),
                                const SizedBox(height: 12),
                                _buildInfoRow('Room', room, isDark),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  'Warden',
                                  warden,
                                  isDark,
                                  isLast: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Attendance Summary Cards
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _buildSummaryCard(
                                value: presentNights.toString(),
                                label: 'Present Nights',
                                accent: isDark
                                    ? Colors.green.shade600
                                    : const Color(0xFF10B981),
                                background: isDark
                                    ? Colors.green.shade900.withOpacity(0.25)
                                    : const Color(0xFFD1FAE5),
                                isDark: isDark,
                              ),
                              _buildSummaryCard(
                                value: absentNights.toString(),
                                label: 'Absent Nights',
                                accent: isDark
                                    ? Colors.red.shade600
                                    : const Color(0xFFEF4444),
                                background: isDark
                                    ? Colors.red.shade900.withOpacity(0.25)
                                    : const Color(0xFFFEE2E2),
                                isDark: isDark,
                              ),
                              _buildSummaryCard(
                                value: leaveNights.toString(),
                                label: 'Leave Nights',
                                accent: isDark
                                    ? Colors.orange.shade600
                                    : const Color(0xFFF97316),
                                background: isDark
                                    ? Colors.orange.shade900.withOpacity(0.25)
                                    : const Color(0xFFFFF7ED),
                                isDark: isDark,
                              ),
                              _buildSummaryCard(
                                value:
                                    '${attendancePercentage.toStringAsFixed(0)}%',
                                label: 'Attendance',
                                accent: isDark
                                    ? Colors.blue.shade600
                                    : const Color(0xFF2563EB),
                                background: isDark
                                    ? Colors.blue.shade900.withOpacity(0.25)
                                    : const Color(0xFFDBEAFE),
                                isDark: isDark,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Month Performance Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey.shade800
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Month Performance: $performanceText',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge?.color,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Total Nights: $totalNights | Recorded Nights: $totalRecordedNights',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark
                                              ? Colors.grey.shade400
                                              : const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: attendancePercentage >= 90
                                        ? (isDark
                                              ? Colors.green.shade900
                                                    .withValues(alpha: 0.5)
                                              : const Color(0xFFD1FAE5))
                                        : attendancePercentage >= 70
                                        ? (isDark
                                              ? Colors.orange.shade900
                                                    .withValues(alpha: 0.5)
                                              : const Color(0xFFFFF7ED))
                                        : (isDark
                                              ? Colors.red.shade900.withValues(
                                                  alpha: 0.5,
                                                )
                                              : const Color(0xFFFEE2E2)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${attendancePercentage.toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: attendancePercentage >= 90
                                          ? (isDark
                                                ? Colors.green.shade300
                                                : const Color(0xFF10B981))
                                          : attendancePercentage >= 70
                                          ? (isDark
                                                ? Colors.orange.shade300
                                                : const Color(0xFFF97316))
                                          : (isDark
                                                ? Colors.red.shade300
                                                : const Color(0xFFEF4444)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Night-wise Attendance Details Section
                          Row(
                            children: [
                              Icon(
                                Icons.description,
                                size: 20,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.color,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Night-wise Attendance Details',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Show "No data" if attendance details is empty
                          if (attendanceDetails.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.grey.shade800
                                    : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.grey.shade700
                                      : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.inbox_outlined,
                                    size: 48,
                                    color: isDark
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No data',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else ...[
                            // Horizontal Scrollbar (top)
                            _buildHorizontalScrollbar(isDark),
                            const SizedBox(height: 8),

                            // Table with horizontal scroll
                            Scrollbar(
                              controller: _horizontalScrollController,
                              thumbVisibility: true,
                              thickness: 8,
                              radius: const Radius.circular(4),
                              child: SingleChildScrollView(
                                controller: _horizontalScrollController,
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 800,
                                  ),
                                  child: _buildAttendanceTable(isDark),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Horizontal Scrollbar (bottom)
                            _buildHorizontalScrollbar(isDark),
                          ],
                          const SizedBox(height: 24),

                          // Monthly Statistics Section
                          Text(
                            'Monthly Statistics',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Statistics Grid
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey.shade800
                                  : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatItem(
                                        'Total Recorded Nights',
                                        totalRecordedNights.toString(),
                                        null,
                                        isDark,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildStatItem(
                                        'Present Nights',
                                        presentNights.toString(),
                                        null,
                                        isDark,
                                        iconColor: isDark
                                            ? Colors.green.shade400
                                            : const Color(0xFF10B981),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatItem(
                                        'Absent Nights',
                                        absentNights.toString(),
                                        null,
                                        isDark,
                                        iconColor: isDark
                                            ? Colors.red.shade400
                                            : const Color(0xFFEF4444),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildStatItem(
                                        'Leave Nights',
                                        leaveNights.toString(),
                                        null,
                                        isDark,
                                        iconColor: isDark
                                            ? Colors.orange.shade400
                                            : const Color(0xFFF97316),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatItem(
                                        'Holiday Nights',
                                        holidayNights.toString(),
                                        null,
                                        isDark,
                                        iconColor: isDark
                                            ? Colors.blue.shade400
                                            : const Color(0xFF2563EB),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildStatItem(
                                        'Night Outs',
                                        nightOuts.toString(),
                                        Icons.home,
                                        isDark,
                                        iconColor: isDark
                                            ? Colors.purple.shade400
                                            : const Color(0xFF7C3AED),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatItem(
                                        'Attendance Percentage',
                                        '${attendancePercentage.toStringAsFixed(1)}%',
                                        null,
                                        isDark,
                                        valueColor: attendancePercentage >= 90
                                            ? (isDark
                                                  ? Colors.green.shade400
                                                  : const Color(0xFF10B981))
                                            : attendancePercentage >= 70
                                            ? (isDark
                                                  ? Colors.orange.shade400
                                                  : const Color(0xFFF97316))
                                            : (isDark
                                                  ? Colors.red.shade400
                                                  : const Color(0xFFEF4444)),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildStatItem(
                                        'Performance Rating',
                                        '',
                                        null,
                                        isDark,
                                        showStars: true,
                                        starCount: performanceStars,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Action Buttons
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          side: BorderSide(
                            color: isDark
                                ? Colors.grey.shade600
                                : Colors.grey.shade400,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'PDF download functionality coming soon',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.download, size: 14),
                        label: const Text(
                          'Download Month Report (PDF)',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C3AED),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    bool isDark, {
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey.shade400 : const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String value,
    required String label,
    required Color accent,
    required Color background,
    required bool isDark,
  }) {
    return Container(
      width: 150, // fixed modern card width (prevents overflow)
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData? icon,
    bool isDark, {
    Color? iconColor,
    bool showStars = false,
    int starCount = 0,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 6),
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? Colors.grey.shade400
                      : const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (showStars)
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < starCount ? Icons.star : Icons.star_border,
                size: 20,
                color: index < starCount
                    ? (isDark ? Colors.yellow.shade400 : Colors.amber)
                    : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
              );
            }),
          )
        else
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
      ],
    );
  }

  Widget _buildHorizontalScrollbar(bool isDark) {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (_horizontalScrollController.hasClients) {
                _horizontalScrollController.animateTo(
                  (_horizontalScrollController.offset - 200).clamp(
                    0.0,
                    _horizontalScrollController.position.maxScrollExtent,
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Container(
              width: 24,
              height: 20,
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_ios,
                size: 12,
                color: isDark ? Colors.grey.shade400 : const Color(0xFF94A3B8),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade700 : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_horizontalScrollController.hasClients) {
                _horizontalScrollController.animateTo(
                  (_horizontalScrollController.offset + 200).clamp(
                    0.0,
                    _horizontalScrollController.position.maxScrollExtent,
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Container(
              width: 24,
              height: 20,
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: isDark ? Colors.grey.shade400 : const Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTable(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : const Color(0xFFE2E8F0),
        ),
      ),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(120),
          1: FixedColumnWidth(140),
          2: FixedColumnWidth(140),
          3: FixedColumnWidth(140),
          4: FixedColumnWidth(120),
          5: FixedColumnWidth(140),
        },
        children: [
          // Header Row
          TableRow(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade700 : const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            children: [
              _buildTableCell('Date', true, isDark),
              _buildTableCell('Check Type', true, isDark),
              _buildTableCell('Time', true, isDark),
              _buildTableCell('Warden', true, isDark),
              _buildTableCell('Status', true, isDark),
              _buildTableCell('Remarks', true, isDark),
            ],
          ),
          // Data Rows
          ...attendanceDetails.map((detail) {
            return TableRow(
              children: [
                _buildTableCell(detail['date'] ?? '', false, isDark),
                _buildTableCell(
                  detail['checkType'] ?? '',
                  false,
                  isDark,
                  isButton: true,
                ),
                _buildTableCell(
                  detail['time'] ?? '',
                  false,
                  isDark,
                  hasClockIcon: true,
                ),
                _buildTableCell(detail['warden'] ?? '', false, isDark),
                _buildTableCell(
                  detail['status'] ?? '',
                  false,
                  isDark,
                  hasIcon: true,
                  iconColor: detail['status'] == 'Present'
                      ? (isDark
                            ? Colors.green.shade400
                            : const Color(0xFF10B981))
                      : null,
                ),
                _buildTableCell(detail['remark'] ?? '', false, isDark),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTableCell(
    String text,
    bool isHeader,
    bool isDark, {
    bool isButton = false,
    bool hasIcon = false,
    bool hasClockIcon = false,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: isButton
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.blue.shade900.withValues(alpha: 0.3)
                    : const Color(0xFFDBEAFE),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: isHeader ? 12 : 11,
                  fontWeight: isHeader ? FontWeight.w600 : FontWeight.w500,
                  color: isHeader
                      ? (isDark
                            ? Colors.grey.shade300
                            : const Color(0xFF1E293B))
                      : (isDark
                            ? Colors.blue.shade300
                            : const Color(0xFF2563EB)),
                ),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasClockIcon) ...[
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: isDark
                        ? Colors.grey.shade400
                        : const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 4),
                ],
                if (hasIcon && iconColor != null) ...[
                  Icon(Icons.check_circle, size: 16, color: iconColor),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: isHeader ? 12 : 11,
                      fontWeight: isHeader ? FontWeight.w600 : FontWeight.w500,
                      color: isHeader
                          ? (isDark
                                ? Colors.grey.shade300
                                : const Color(0xFF1E293B))
                          : (isDark
                                ? Colors.grey.shade400
                                : const Color(0xFF64748B)),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

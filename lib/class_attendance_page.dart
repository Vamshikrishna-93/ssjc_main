import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:student_app/studentdrawer.dart';
import 'package:student_app/theme_controller.dart';

import 'attendence_month_details_page.dart';
import 'package:student_app/services/attendance_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String selectedPeriod = "All Months";
  int currentPage = 1;
  final int itemsPerPage = 10;
  bool _isLoading = true;

  // Dynamic data
  double overallAttendance = 0.0;
  int daysAttended = 0;
  int totalDays = 0;
  int daysAbsent = 0;
  int currentStreak = 0;
  int bestStreak = 0;
  int leavesTaken = 0;
  int leavesRemaining = 0;

  List<Map<String, dynamic>> monthlyData = [];
  List<double> trendData = [];

  final ScrollController _horizontalScrollController = ScrollController();
  double _maxScrollExtent = 0.0;
  double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController.addListener(_updateScrollMetrics);
    _fetchAttendanceData();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _updateScrollMetrics() {
    setState(() {
      _maxScrollExtent = _horizontalScrollController.position.maxScrollExtent;
      _scrollPosition = _horizontalScrollController.position.pixels;
    });
  }

  Future<void> _fetchAttendanceData() async {
    try {
      final responseData = await AttendanceService.getAttendance();

      if (mounted) {
        setState(() {
          final data = responseData.containsKey('data')
              ? responseData['data']
              : responseData;

          if (data is Map<String, dynamic>) {
            if (data.containsKey('overallAttendance') ||
                data.containsKey('present_days')) {
              overallAttendance =
                  (data['overallAttendance'] ??
                          data['attendance_percentage'] ??
                          0.0)
                      .toDouble();
              daysAttended = data['daysAttended'] ?? data['present_days'] ?? 0;
              totalDays = data['totalDays'] ?? data['total_working_days'] ?? 0;
              daysAbsent = data['daysAbsent'] ?? data['absent_days'] ?? 0;
              currentStreak = data['currentStreak'] ?? 0;
              bestStreak = data['bestStreak'] ?? 0;
              leavesTaken = data['leavesTaken'] ?? data['leave_days'] ?? 0;
              leavesRemaining = data['leavesRemaining'] ?? 0;
            }

            var mData = data['monthlyData'] ?? data['months'];
            if (mData != null && mData is List) {
              monthlyData = mData
                  .map<Map<String, dynamic>>((m) => _normalizeMonthData(m))
                  .toList();
            }

            if (data['trendData'] != null) {
              trendData = List<double>.from(
                data['trendData'].map((x) => x.toDouble()),
              );
            }
          } else if (data is List) {
            monthlyData = data
                .map<Map<String, dynamic>>((m) => _normalizeMonthData(m))
                .toList();
          }

          if (totalDays == 0 && monthlyData.isNotEmpty) {
            _calculateStats();
          }

          if (trendData.isEmpty && monthlyData.isNotEmpty) {
            trendData = monthlyData
                .map((m) => (m['percentage'] as num).toDouble())
                .toList();
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Map<String, dynamic> _normalizeMonthData(dynamic m) {
    return {
      'month': m['month'] ?? m['month_name'] ?? '',
      'attended': m['attended'] ?? m['present_days'] ?? m['present'] ?? 0,
      'total': m['total'] ?? m['total_working_days'] ?? m['total_days'] ?? 0,
      'present': m['present'] ?? m['present_days'] ?? 0,
      'absent': m['absent'] ?? m['absent_days'] ?? 0,
      'leaves': m['leaves'] ?? m['leave_days'] ?? 0,
      'percentage': (m['percentage'] ?? m['attendance_percentage'] ?? 0.0)
          .toDouble(),
      'details':
          m['details'] ??
          m['attendance_details'] ??
          m['day_wise_details'] ??
          [],
    };
  }

  void _calculateStats() {
    int p = 0;
    int t = 0;
    int a = 0;
    int l = 0;
    for (var m in monthlyData) {
      p += (m['present'] as int);
      t += (m['total'] as int);
      a += (m['absent'] as int);
      l += (m['leaves'] as int);
    }
    daysAttended = p;
    totalDays = t;
    daysAbsent = a;
    leavesTaken = l;
    if (t > 0) {
      overallAttendance = double.parse(((p / t) * 100).toStringAsFixed(1));
    }
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;
                final padding = isMobile ? 12.0 : 16.0;

                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Attendance Dashboard Header Card
                        _buildDashboardHeader(isMobile),
                        SizedBox(height: isMobile ? 12 : 16),

                        // Overall Attendance Card
                        _buildOverallAttendanceCard(isMobile),
                        SizedBox(height: isMobile ? 12 : 16),

                        // Days Attended Card
                        _buildDaysAttendedCard(isMobile),
                        SizedBox(height: isMobile ? 12 : 16),

                        // Current Streak Card
                        _buildCurrentStreakCard(isMobile),
                        SizedBox(height: isMobile ? 12 : 16),

                        // Leaves Taken Card
                        _buildLeavesTakenCard(isMobile),
                        SizedBox(height: isMobile ? 12 : 16),

                        // Attendance Trend Card
                        _buildAttendanceTrendCard(isMobile),
                        SizedBox(height: isMobile ? 12 : 16),

                        // Performance Summary Card
                        _buildPerformanceSummaryCard(isMobile),
                        SizedBox(height: isMobile ? 12 : 16),

                        // Monthly Attendance Overview Card
                        _buildMonthlyOverviewCard(isMobile),
                        SizedBox(height: isMobile ? 12 : 16),

                        // Recent Activity Card
                        _buildRecentActivityCard(isMobile),
                        SizedBox(height: isMobile ? 12 : 16),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildDashboardHeader(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Container(
                width: isMobile ? 40 : 48,
                height: isMobile ? 40 : 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: isMobile ? 24 : 28,
                ),
              ),
              SizedBox(width: isMobile ? 12 : 16),
              Expanded(
                child: Text(
                  'Attendance Dashboard',
                  style: TextStyle(
                    fontSize: isMobile ? 22 : 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF7C3AED),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 8 : 12),
          Text(
            'Track, analyze, and improve your attendance performance.',
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: const Color(0xFF64748B),
              height: 1.5,
            ),
          ),
          SizedBox(height: isMobile ? 16 : 20),
          isMobile
              ? Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text(
                          'Refresh Data',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C3AED),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.print,
                          size: 18,
                          color: Colors.black87,
                        ),
                        label: const Text(
                          'Print Report',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(
                            color: Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text(
                          'Refresh Data',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C3AED),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.print,
                          size: 18,
                          color: Colors.black87,
                        ),
                        label: const Text(
                          'Print Report',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(
                            color: Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildOverallAttendanceCard(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Attendance',
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '%',
                style: TextStyle(
                  fontSize: isMobile ? 24 : 32,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF10B981),
                ),
              ),
              SizedBox(width: isMobile ? 4 : 8),
              Flexible(
                child: Text(
                  '$overallAttendance',
                  style: TextStyle(
                    fontSize: isMobile ? 36 : 48,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 10 : 12,
              vertical: isMobile ? 6 : 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: isMobile ? 14 : 16,
                  color: const Color(0xFF10B981),
                ),
                SizedBox(width: isMobile ? 4 : 6),
                Flexible(
                  child: Text(
                    'Based on $totalDays recorded days',
                    style: TextStyle(
                      fontSize: isMobile ? 11 : 12,
                      color: const Color(0xFF059669),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysAttendedCard(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Container(
                width: isMobile ? 36 : 40,
                height: isMobile ? 36 : 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF2563EB),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: isMobile ? 20 : 24,
                ),
              ),
              SizedBox(width: isMobile ? 10 : 12),
              Text(
                'Days Attended',
                style: TextStyle(
                  fontSize: isMobile ? 12 : 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            '$daysAttended/$totalDays',
            style: TextStyle(
              fontSize: isMobile ? 36 : 48,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2563EB),
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 10 : 12,
              vertical: isMobile ? 6 : 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person_off,
                  size: isMobile ? 14 : 16,
                  color: const Color(0xFF2563EB),
                ),
                SizedBox(width: isMobile ? 4 : 6),
                Flexible(
                  child: Text(
                    '$daysAbsent days absent',
                    style: TextStyle(
                      fontSize: isMobile ? 11 : 12,
                      color: const Color(0xFF1E40AF),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStreakCard(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Container(
                width: isMobile ? 36 : 40,
                height: isMobile ? 36 : 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: isMobile ? 20 : 24,
                ),
              ),
              SizedBox(width: isMobile ? 10 : 12),
              Text(
                'Current Streak',
                style: TextStyle(
                  fontSize: isMobile ? 12 : 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            '$currentStreak days',
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF7C3AED),
            ),
          ),
          SizedBox(height: isMobile ? 10 : 12),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 10 : 12,
              vertical: isMobile ? 6 : 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_events,
                  size: isMobile ? 14 : 16,
                  color: const Color(0xFF7C3AED),
                ),
                SizedBox(width: isMobile ? 4 : 6),
                Flexible(
                  child: Text(
                    'Best streak: $bestStreak days',
                    style: TextStyle(
                      fontSize: isMobile ? 11 : 12,
                      color: const Color(0xFF6D28D9),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeavesTakenCard(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Container(
                width: isMobile ? 36 : 40,
                height: isMobile ? 36 : 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF97316),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: isMobile ? 20 : 24,
                ),
              ),
              SizedBox(width: isMobile ? 10 : 12),
              Text(
                'Leaves Taken',
                style: TextStyle(
                  fontSize: isMobile ? 12 : 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            '$leavesTaken days',
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFF97316),
            ),
          ),
          SizedBox(height: isMobile ? 10 : 12),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 10 : 12,
              vertical: isMobile ? 6 : 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  size: isMobile ? 14 : 16,
                  color: const Color(0xFFF97316),
                ),
                SizedBox(width: isMobile ? 4 : 6),
                Flexible(
                  child: Text(
                    '$leavesRemaining leaves remaining',
                    style: TextStyle(
                      fontSize: isMobile ? 11 : 12,
                      color: const Color(0xFFD97706),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTrendCard(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.bar_chart,
                          size: 18,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Attendance Trend',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              selectedPeriod,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1E293B),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_drop_down,
                            size: 16,
                            color: Color(0xFF1E293B),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.bar_chart,
                          size: 20,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Attendance Trend',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedPeriod,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_drop_down,
                            size: 18,
                            color: Color(0xFF1E293B),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          SizedBox(height: isMobile ? 16 : 24),
          SizedBox(
            height: isMobile ? 160 : 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xFFE2E8F0),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 25,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: trendData.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value);
                    }).toList(),
                    isCurved: true,
                    color: const Color(0xFF2563EB),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF2563EB).withOpacity(0.1),
                    ),
                  ),
                ],
                minY: 0,
                maxY: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSummaryCard(bool isMobile) {
    final gaugeSize = isMobile ? 100.0 : 140.0;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                size: isMobile ? 18 : 20,
                color: const Color(0xFFF59E0B),
              ),
              SizedBox(width: isMobile ? 6 : 8),
              Text(
                'Performance Summary',
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 24),
          isMobile
              ? Column(
                  children: [
                    SizedBox(
                      width: gaugeSize,
                      height: gaugeSize,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: gaugeSize,
                            height: gaugeSize,
                            child: CircularProgressIndicator(
                              value: overallAttendance / 100,
                              strokeWidth: isMobile ? 10 : 12,
                              backgroundColor: const Color(0xFFE2E8F0),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                overallAttendance >= 90
                                    ? const Color(0xFF10B981)
                                    : overallAttendance >= 75
                                    ? const Color(0xFF2563EB)
                                    : const Color(0xFFEF4444),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$overallAttendance%',
                                style: TextStyle(
                                  fontSize: isMobile ? 24 : 32,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF2563EB),
                                ),
                              ),
                              Text(
                                'Overall Score',
                                style: TextStyle(
                                  fontSize: isMobile ? 10 : 12,
                                  color: const Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Excellent',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    SizedBox(
                      width: gaugeSize,
                      height: gaugeSize,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: gaugeSize,
                            height: gaugeSize,
                            child: CircularProgressIndicator(
                              value: overallAttendance / 100,
                              strokeWidth: 12,
                              backgroundColor: const Color(0xFFE2E8F0),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                overallAttendance >= 90
                                    ? const Color(0xFF10B981)
                                    : overallAttendance >= 75
                                    ? const Color(0xFF2563EB)
                                    : const Color(0xFFEF4444),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$overallAttendance%',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                              const Text(
                                'Overall Score',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Excellent',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
          SizedBox(height: isMobile ? 16 : 24),
          Text(
            'Quick Stats',
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: isMobile ? 10 : 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickStatCard(
                  '111',
                  'Present Days',
                  const Color(0xFF10B981),
                  isMobile,
                ),
              ),
              SizedBox(width: isMobile ? 8 : 12),
              Expanded(
                child: _buildQuickStatCard(
                  '7',
                  'Absent Days',
                  const Color(0xFFEF4444),
                  isMobile,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 10 : 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickStatCard(
                  '0',
                  'Leave Days',
                  const Color(0xFFF97316),
                  isMobile,
                ),
              ),
              SizedBox(width: isMobile ? 8 : 12),
              Expanded(
                child: _buildQuickStatCard(
                  '8',
                  'Current Streak',
                  const Color(0xFF7C3AED),
                  isMobile,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatCard(
    String value,
    String label,
    Color color,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: isMobile ? 2 : 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 11 : 12,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyOverviewCard(bool isMobile) {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = math.min(startIndex + itemsPerPage, monthlyData.length);
    final currentData = monthlyData.sublist(startIndex, endIndex);
    final totalPages = (monthlyData.length / itemsPerPage).ceil();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Monthly Class Attendance Overview',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            size: 14,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Search months...',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                hintStyle: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 20,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Monthly Class Attendance Overview',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.search,
                            size: 16,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          SizedBox(
                            width: 120,
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Search months...',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          SizedBox(height: isMobile ? 6 : 8),
          Text(
            'Showing ${monthlyData.length} months of attendance data.',
            style: TextStyle(
              fontSize: isMobile ? 11 : 12,
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          // Horizontal Scrollbar with arrows
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (_horizontalScrollController.hasClients) {
                      _horizontalScrollController.animateTo(
                        math.max(0, _horizontalScrollController.offset - 200),
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
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final scrollRatio = _maxScrollExtent > 0
                          ? _scrollPosition / _maxScrollExtent
                          : 0.0;
                      final trackWidth = constraints.maxWidth - 8;
                      final thumbWidth = math.max(20.0, trackWidth * 0.3);
                      final thumbPosition =
                          (trackWidth - thumbWidth) * scrollRatio;

                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          if (_maxScrollExtent > 0)
                            Positioned(
                              left: thumbPosition + 4,
                              child: Container(
                                width: thumbWidth,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF64748B),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_horizontalScrollController.hasClients) {
                      _horizontalScrollController.animateTo(
                        math.min(
                          _horizontalScrollController.position.maxScrollExtent,
                          _horizontalScrollController.offset + 200,
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
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isMobile ? 8 : 12),
          // Table - horizontally scrollable
          Scrollbar(
            controller: _horizontalScrollController,
            thumbVisibility: true,
            thickness: 8,
            radius: const Radius.circular(4),
            child: SingleChildScrollView(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: isMobile ? 700 : 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Table Header
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: isMobile ? 10 : 12,
                        horizontal: isMobile ? 12 : 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: _buildTableHeader('Month', isMobile),
                          ),
                          SizedBox(width: 140),
                          SizedBox(
                            width: 140,
                            child: _buildTableHeader(
                              'Attendance Days',
                              isMobile,
                            ),
                          ),
                          SizedBox(width: 100),
                          SizedBox(
                            width: 140,
                            child: _buildTableHeader('Status', isMobile),
                          ),
                          SizedBox(width: 100),
                          SizedBox(
                            width: 80,
                            child: _buildTableHeader('%', isMobile),
                          ),
                          SizedBox(width: 120),
                          SizedBox(
                            width: 120,
                            child: _buildTableHeader('Actions', isMobile),
                          ),
                        ],
                      ),
                    ),
                    // Table Rows
                    ...currentData.map(
                      (data) => _buildMonthlyRow(data, isMobile),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          // Pagination - wrap on mobile
          isMobile
              ? Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        IconButton(
                          onPressed: currentPage > 1
                              ? () {
                                  setState(() {
                                    currentPage--;
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.chevron_left),
                          color: currentPage > 1
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF94A3B8),
                        ),
                        Text(
                          '${startIndex + 1}-${endIndex} of ${monthlyData.length}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        ...List.generate(math.min(totalPages, 3), (index) {
                          final pageNum = index + 1;
                          final isActive = pageNum == currentPage;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                currentPage = pageNum;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFF2563EB)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '$pageNum',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isActive
                                      ? Colors.white
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          );
                        }),
                        IconButton(
                          onPressed: currentPage < totalPages
                              ? () {
                                  setState(() {
                                    currentPage++;
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.chevron_right),
                          color: currentPage < totalPages
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF94A3B8),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: currentPage > 1
                          ? () {
                              setState(() {
                                currentPage--;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.chevron_left),
                      color: currentPage > 1
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF94A3B8),
                    ),
                    Text(
                      '${startIndex + 1}-${endIndex} of ${monthlyData.length} months',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    ...List.generate(totalPages, (index) {
                      final pageNum = index + 1;
                      final isActive = pageNum == currentPage;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentPage = pageNum;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFF2563EB)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$pageNum',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      );
                    }),
                    IconButton(
                      onPressed: currentPage < totalPages
                          ? () {
                              setState(() {
                                currentPage++;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.chevron_right),
                      color: currentPage < totalPages
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF94A3B8),
                    ),
                  ],
                ),
          SizedBox(height: isMobile ? 12 : 16),
          // Status Legend - wrap on mobile
          Container(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Legend',
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: isMobile ? 6 : 8),
                Wrap(
                  spacing: isMobile ? 12 : 16,
                  runSpacing: isMobile ? 8 : 0,
                  children: [
                    _buildLegendItem('Present (P)', const Color(0xFF10B981)),
                    _buildLegendItem('Absent (A)', const Color(0xFFEF4444)),
                    _buildLegendItem('Leave (L)', const Color(0xFFF97316)),
                    _buildLegendItem('No Data', const Color(0xFF94A3B8)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text, bool isMobile) {
    return Text(
      text,
      style: TextStyle(
        fontSize: isMobile ? 10 : 12,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1E293B),
      ),
    );
  }

  Widget _buildMonthlyRow(Map<String, dynamic> data, bool isMobile) {
    final percentage = data['percentage'] as double;
    final attended = data['attended'] as int;
    final total = data['total'] as int;
    final progress = total > 0 ? attended / total : 0.0;
    final status = percentage >= 90
        ? 'Excellent'
        : percentage >= 75
        ? 'Good'
        : 'Needs Improvement';

    Color percentageColor;
    Color progressColor;
    if (percentage >= 90) {
      percentageColor = const Color(0xFF10B981);
      progressColor = const Color(0xFF10B981);
    } else if (percentage >= 75) {
      percentageColor = const Color(0xFFF97316);
      progressColor = const Color(0xFFF97316);
    } else {
      percentageColor = const Color(0xFFEF4444);
      progressColor = const Color(0xFFEF4444);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 12 : 16,
        horizontal: isMobile ? 12 : 16,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: isMobile ? 14 : 16,
                  color: const Color(0xFF10B981),
                ),
                SizedBox(width: isMobile ? 4 : 8),
                Expanded(
                  child: Text(
                    data['month'] as String,
                    style: TextStyle(
                      fontSize: isMobile ? 10 : 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1E293B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 140),
          SizedBox(
            width: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: isMobile ? 6 : 8,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                ),
                SizedBox(height: isMobile ? 2 : 4),
                Text(
                  '$attended/$total days',
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 11,
                    color: const Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 100),
          SizedBox(
            width: 140,
            child: Wrap(
              spacing: isMobile ? 4 : 6,
              runSpacing: 4,
              children: [
                _buildStatusIcon(
                  Icons.check_circle,
                  data['present'] as int,
                  const Color(0xFF10B981),
                  isMobile,
                ),
                _buildStatusIcon(
                  Icons.cancel,
                  data['absent'] as int,
                  const Color(0xFFEF4444),
                  isMobile,
                ),
                _buildStatusIcon(
                  Icons.calendar_today,
                  data['leaves'] as int,
                  const Color(0xFFF59E0B),
                  isMobile,
                ),
              ],
            ),
          ),
          SizedBox(width: 100),
          SizedBox(
            width: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    fontWeight: FontWeight.w600,
                    color: percentageColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isMobile ? 2 : 4),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 12,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 120),
          SizedBox(
            width: 120,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceMonthDetailPage(
                      monthData: data,
                      month: data['month'] as String,
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.visibility,
                size: isMobile ? 14 : 16,
                color: Colors.white,
              ),
              label: Text(
                isMobile ? 'View' : 'View Details',
                style: TextStyle(
                  fontSize: isMobile ? 10 : 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 8 : 12,
                  vertical: isMobile ? 6 : 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(
    IconData icon,
    int count,
    Color color,
    bool isMobile,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: isMobile ? 14 : 16, color: color),
        SizedBox(width: isMobile ? 2 : 4),
        Text(
          '$count',
          style: TextStyle(
            fontSize: isMobile ? 10 : 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
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
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildRecentActivityCard(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Icon(
                Icons.access_time,
                size: isMobile ? 18 : 20,
                color: const Color(0xFF7C3AED),
              ),
              SizedBox(width: isMobile ? 6 : 8),
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 12 : 16),
          _buildActivityItem(
            Icons.check_circle,
            const Color(0xFF10B981),
            'Overall Attendance',
            '94.1% attendance rate',
            'Updated just now',
            '94.1%',
            isMobile,
          ),
          _buildActivityItem(
            Icons.emoji_events,
            const Color(0xFFF97316),
            'Best Attendance Streak',
            '69 consecutive days present',
            'Previous record',
            null,
            isMobile,
          ),
          _buildActivityItem(
            Icons.local_fire_department,
            const Color(0xFF7C3AED),
            'Current Attendance Streak',
            '8 consecutive days present',
            'Active now',
            null,
            isMobile,
          ),
          _buildActivityItem(
            Icons.cancel,
            const Color(0xFFEF4444),
            'Apr 26 Performance',
            '0 present, 0 absent, 0 leaves',
            '— No change',
            '0',
            isMobile,
            date: 'End of Apr 26',
            showViewDetails: true,
          ),
          _buildActivityItem(
            Icons.cancel,
            const Color(0xFFEF4444),
            'Mar 26 Performance',
            '0 present, 0 absent, 0 leaves',
            '— No change',
            '0',
            isMobile,
            date: 'End of Mar 26',
            showViewDetails: true,
            isLast: true,
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.refresh,
                size: 16,
                color: Color(0xFF2563EB),
              ),
              label: const Text(
                'Refresh Activities',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    IconData icon,
    Color color,
    String title,
    String details,
    String status,
    String? value,
    bool isMobile, {
    String? date,
    bool showViewDetails = false,
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : (isMobile ? 12 : 16)),
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isMobile ? 36 : 40,
            height: isMobile ? 36 : 40,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: isMobile ? 18 : 20),
          ),
          SizedBox(width: isMobile ? 10 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: isMobile ? 2 : 4),
                Text(
                  details,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 12,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isMobile ? 2 : 4),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 11,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                if (date != null) ...[
                  SizedBox(height: isMobile ? 2 : 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: isMobile ? 10 : 11,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
                if (showViewDetails) ...[
                  SizedBox(height: isMobile ? 6 : 8),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 12,
                        color: const Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (value != null)
            Text(
              value,
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
        ],
      ),
    );
  }
}

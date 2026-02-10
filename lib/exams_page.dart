import 'package:flutter/material.dart';
import 'package:student_app/exam_writing_page.dart';
import 'package:student_app/services/attendance_service.dart';
import 'package:student_app/services/exams_service.dart';
import 'package:student_app/studentdrawer.dart';
import 'package:student_app/theme_controller.dart';

class ExamsPage extends StatefulWidget {
  const ExamsPage({super.key});

  @override
  State<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic> _onlineExams = [];

  // Stats
  int _upcomingCount = 0;
  int _completedCount = 0;
  String _avgScore = "N/A";
  Map<String, dynamic> _attendanceData = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _fetchExams();
  }

  Future<void> _fetchExams() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ExamsService.getOnlineExams();
      final summary = await AttendanceService.getAttendanceSummary();
      if (mounted) {
        setState(() {
          _onlineExams = data;
          _attendanceData = summary;
          final now = DateTime.now();
          _upcomingCount = _onlineExams.where((e) {
            if (e is! Map) return false;
            final date = DateTime.tryParse(
              (e['start_date'] ?? e['date'] ?? '').toString(),
            );
            return date != null && date.isAfter(now);
          }).length;
          _completedCount =
              _onlineExams.length - _upcomingCount; // Simplified logic

          // Calculate Avg Score dynamically
          double totalMarks = 0;
          double obtainedMarks = 0;
          int scoredCount = 0;

          for (var exam in _onlineExams) {
            if (exam is! Map) continue;
            final obtained = double.tryParse(
              exam['marks_obtained']?.toString() ?? '',
            );
            final total = double.tryParse(
              exam['total_marks']?.toString() ?? '',
            );

            if (obtained != null && total != null && total > 0) {
              obtainedMarks += obtained;
              totalMarks += total;
              scoredCount++;
            }
          }

          _avgScore = (scoredCount > 0 && totalMarks > 0)
              ? "${((obtainedMarks / totalMarks) * 100).toStringAsFixed(1)}%"
              : "N/A";
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- HEADER ----------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Exams",
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Manage your exams and view results",
                          style: textTheme.bodySmall?.copyWith(
                            color: textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Wrap(
                    spacing: 12,
                    children: [
                      _OutlinedBtn(
                        icon: Icons.refresh,
                        label: "Refresh",
                        onTap: _fetchExams,
                        theme: theme,
                      ),
                      _PrimaryBtn(
                        icon: Icons.calendar_month,
                        label: "Open Calendar",
                        onTap: () {},
                        theme: theme,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ---------------- STATS ----------------
              _StatCard(
                title: "Upcoming Exams",
                value: _upcomingCount.toString(),
                subtitle: null,
                icon: Icons.calendar_today,
                color: colorScheme.primary,
                theme: theme,
              ),
              const SizedBox(height: 16),
              _StatCard(
                title: "Avg. Score",
                value: _avgScore,
                subtitle: "Based on $_completedCount completed exams",
                icon: Icons.emoji_events_outlined,
                color: colorScheme.error,
                theme: theme,
              ),
              const SizedBox(height: 16),
              _StatCard(
                title: "Class Rank",
                value: _attendanceData['overall_rank']?.toString() ?? "N/A",
                subtitle: _attendanceData['overall_rank'] != null ? "Top ${_attendanceData['overall_rank']} of the class" : "Rank not available",
                icon: Icons.emoji_events,
                color: colorScheme.secondary,
                theme: theme,
              ),
              const SizedBox(height: 16),
              _StatCard(
                title: "Study Hours",
                value: "N/A",
                subtitle: "Sync with your study planner",
                icon: Icons.access_time,
                color: colorScheme.tertiary,
                theme: theme,
              ),

              const SizedBox(height: 24),

              // ---------------- TABS CARD ----------------
              Container(
                decoration: _cardDecoration(theme),
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    // TAB BAR
                    Row(
                      children: [
                        Expanded(
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            indicatorColor: colorScheme.primary,
                            indicatorWeight: 3,
                            labelColor: colorScheme.primary,
                            unselectedLabelColor: textTheme.bodyLarge?.color,
                            labelStyle: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            tabs: const [
                              Tab(
                                icon: Icon(Icons.calendar_today, size: 18),
                                text: "Upcoming",
                              ),
                              Tab(
                                icon: Icon(
                                  Icons.check_circle_outline,
                                  size: 18,
                                ),
                                text: "Completed",
                              ),
                              Tab(
                                icon: Icon(Icons.list_alt, size: 18),
                                text: "All Exams",
                              ),
                              Tab(
                                icon: Icon(Icons.computer, size: 18),
                                text: "Online",
                              ),
                              Tab(
                                icon: Icon(Icons.school, size: 18),
                                text: "Offline",
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<int>(
                          icon: Icon(
                            Icons.more_horiz,
                            color: textTheme.bodyLarge?.color,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (index) {
                            _tabController.animateTo(index);
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 0,
                              child: _MenuItem(
                                icon: Icons.calendar_today,
                                label: "Upcoming",
                              ),
                            ),
                            PopupMenuItem(
                              value: 3,
                              child: _MenuItem(
                                icon: Icons.computer,
                                label: "Online",
                              ),
                            ),
                            PopupMenuItem(
                              value: 4,
                              child: _MenuItem(
                                icon: Icons.school,
                                label: "Offline",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const Divider(height: 1),

                    // TAB CONTENT
                    SizedBox(
                      height: 220,
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _errorMessage != null
                          ? Center(child: Text("Error: $_errorMessage"))
                          : TabBarView(
                              controller: _tabController,
                              children: [
                                // Upcoming
                                _buildExamList(
                                  _onlineExams.where((e) {
                                    if (e is! Map<String, dynamic>)
                                      return false;
                                    final rawDate =
                                        e['start_date'] ?? e['date'];
                                    final date = DateTime.tryParse(
                                      rawDate?.toString() ?? '',
                                    );
                                    return date != null &&
                                        date.isAfter(DateTime.now());
                                  }).toList(),
                                  "No upcoming exams",
                                ),

                                // Completed
                                _buildExamList(
                                  _onlineExams.where((e) {
                                    if (e is! Map<String, dynamic>)
                                      return false;
                                    final rawDate =
                                        e['start_date'] ?? e['date'];
                                    final date = DateTime.tryParse(
                                      rawDate?.toString() ?? '',
                                    );
                                    return date != null &&
                                        date.isBefore(DateTime.now());
                                  }).toList(),
                                  "No completed exams",
                                ),

                                // All
                                _buildExamList(_onlineExams, "No exams found"),

                                // Online
                                _buildExamList(_onlineExams, "No online exams"),

                                // Offline
                                const _EmptyState(
                                  icon: Icons.school,
                                  text: "No offline exams",
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
      ),
    );
  }

  Widget _buildExamList(List<dynamic> exams, String emptyText) {
    if (exams.isEmpty) {
      return _EmptyState(icon: Icons.event_busy, text: emptyText);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];
        if (exam is! Map) return const SizedBox.shrink();
        final title = (exam['exam_name'] ?? exam['name'] ?? 'Exam').toString();
        final date = (exam['start_date'] ?? exam['date'] ?? 'N/A').toString();
        final duration = (exam['duration'] ?? 'N/A').toString();
        final marks = (exam['total_marks'] ?? 'N/A').toString();
        final String examId = (exam['id'] ?? exam['exam_id'] ?? '').toString();
        return GestureDetector(
          onTap: () {
            if (examId.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ExamWritingPage(examId: examId, examName: title),
                ),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Theme.of(context).disabledColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$date  •  $duration mins  •  $marks Marks",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final ThemeData theme;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(theme),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(
                          0.7,
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

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EmptyState({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MenuItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Icon(icon, size: 18), const SizedBox(width: 12), Text(label)],
    );
  }
}

BoxDecoration _cardDecoration(ThemeData theme) => BoxDecoration(
  color: theme.cardColor,
  borderRadius: const BorderRadius.all(Radius.circular(12)),
  boxShadow: [
    BoxShadow(
      color: theme.shadowColor.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ],
);

class _PrimaryBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ThemeData theme;

  const _PrimaryBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.colorScheme.primary,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.onPrimary),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlinedBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ThemeData theme;

  const _OutlinedBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: theme.textTheme.bodyLarge?.color),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

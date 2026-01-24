import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
                        onTap: () {},
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
                value: "0",
                subtitle: null,
                icon: Icons.calendar_today,
                color: colorScheme.primary,
                theme: theme,
              ),
              const SizedBox(height: 16),
              _StatCard(
                title: "Avg. Score",
                value: "0.0%",
                subtitle: "Based on 0 completed exams",
                icon: Icons.emoji_events_outlined,
                color: colorScheme.error,
                theme: theme,
              ),
              const SizedBox(height: 16),
              _StatCard(
                title: "Class Rank",
                value: "30 / 85",
                subtitle: "Top 30 of the class",
                icon: Icons.emoji_events,
                color: colorScheme.secondary,
                theme: theme,
              ),
              const SizedBox(height: 16),
              _StatCard(
                title: "Study Hours",
                value: "0 hrs",
                subtitle: "Recommended for upcoming exams",
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
                                text: "Upcoming Exams",
                              ),
                              Tab(
                                icon: Icon(
                                  Icons.check_circle_outline,
                                  size: 18,
                                ),
                                text: "Completed Exams",
                              ),
                              Tab(
                                icon: Icon(Icons.upcoming, size: 18),
                                text: "Upcoming Exams",
                              ),
                              Tab(
                                icon: Icon(Icons.computer, size: 18),
                                text: "Online Exam",
                              ),
                              Tab(
                                icon: Icon(Icons.school, size: 18),
                                text: "Offline Exam",
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton(
                          icon: Icon(
                            Icons.more_horiz,
                            color: textTheme.bodyLarge?.color,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              child: _MenuItem(
                                icon: Icons.calendar_today,
                                label: "Upcoming Exams",
                              ),
                            ),
                            PopupMenuItem(
                              child: _MenuItem(
                                icon: Icons.computer,
                                label: "Online Exam",
                              ),
                            ),
                            PopupMenuItem(
                              child: _MenuItem(
                                icon: Icons.school,
                                label: "Offline Exam",
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
                      child: TabBarView(
                        controller: _tabController,
                        children: const [
                          _EmptyState(
                            icon: Icons.calendar_today,
                            text: "No upcoming exams",
                          ),

                          _EmptyState(
                            icon: Icons.check_circle_outline,
                            text: "No completed exams",
                          ),
                          _EmptyState(
                            icon: Icons.upcoming,
                            text: "No Upcompleted exams",
                          ),
                          _EmptyState(
                            icon: Icons.computer,
                            text: "No online exams",
                          ),
                          _EmptyState(
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

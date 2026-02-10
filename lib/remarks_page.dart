import 'package:flutter/material.dart';
import 'package:student_app/studentdrawer.dart';
import 'package:student_app/theme_controller.dart';
import 'package:student_app/services/remarks_service.dart';

class RemarksPage extends StatefulWidget {
  const RemarksPage({super.key});

  @override
  State<RemarksPage> createState() => _RemarksPageState();
}

class _RemarksPageState extends State<RemarksPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _remarks = [];
  bool _isLoading = true;
  int _positiveCount = 0;
  int _warningCount = 0;
  int _criticalCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchRemarks();
  }

  List<dynamic> _positiveRemarks = [];
  List<dynamic> _warningRemarks = [];
  List<dynamic> _criticalRemarks = [];

  Future<void> _fetchRemarks() async {
    if (!_isLoading) setState(() => _isLoading = true);
    try {
      final remarks = await RemarksService.getRemarks();
      if (mounted) {
        setState(() {
          _remarks = remarks;
          
          _positiveRemarks = _remarks.where((r) {
            final type = r['remark_type']?.toString().toLowerCase() ?? '';
            return type == 'positive' || type == 'good' || type == 'appreciation';
          }).toList();

          _warningRemarks = _remarks.where((r) {
             final type = r['remark_type']?.toString().toLowerCase() ?? '';
             return type == 'warning';
          }).toList();

          _criticalRemarks = _remarks.where((r) {
             final type = r['remark_type']?.toString().toLowerCase() ?? '';
             return type == 'critical' || type == 'bad' || type == 'severe';
          }).toList();

          _positiveCount = _positiveRemarks.length;
          _warningCount = _warningRemarks.length;
          _criticalCount = _criticalRemarks.length;
          
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
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
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Remarks",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "View remarks from hostel staff",
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _fetchRemarks,
                    icon: Icon(
                      Icons.refresh,
                      size: 18,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    label: Text(
                      "Refresh",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Stats Cards Row
              Column(
                children: [
                  _StatCard(
                    title: "Total Remarks",
                    count: _remarks.length.toString(),
                    icon: Icons.chat_bubble_outline,
                    iconColor: Colors.blue,
                    countColor: Colors.blue,
                  ),

                  const SizedBox(height: 12),

                  _StatCard(
                    title: "Positive",
                    count: _positiveCount.toString(),
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                    countColor: Colors.green,
                  ),

                  const SizedBox(height: 12),

                  _StatCard(
                    title: "Warnings",
                    count: _warningCount.toString(),
                    icon: Icons.warning_amber_rounded,
                    iconColor: Colors.orange,
                    countColor: Colors.orange,
                  ),

                  const SizedBox(height: 12),

                  _StatCard(
                    title: "Critical",
                    count: _criticalCount.toString(),
                    icon: Icons.error,
                    iconColor: Colors.red,
                    countColor: Colors.red,
                  ),
                ],
              ),

              // Main Remarks Card
              Container(
                margin: const EdgeInsets.only(top: 24),
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
                  children: [
                    // Tabs
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final isMobile = constraints.maxWidth < 360;

                                return TabBar(
                                  controller: _tabController,
                                  isScrollable:
                                      isMobile, // scroll only on very small screens
                                  indicator: const UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                      color: Color(0xFF2563EB),
                                      width: 3,
                                    ),
                                  ),
                                  labelColor: const Color(0xFF2563EB),
                                  unselectedLabelColor:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade700,
                                  labelStyle: TextStyle(
                                    fontSize: isMobile ? 12 : 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  unselectedLabelStyle: TextStyle(
                                    fontSize: isMobile ? 12 : 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  tabs: [
                                    const Tab(text: "All Remarks"),
                                    Tab(
                                      icon: Icon(
                                        Icons.check_circle,
                                        size: isMobile ? 16 : 18,
                                      ),
                                      text: "Positive",
                                    ),
                                    Tab(
                                      icon: Icon(
                                        Icons.warning_amber_rounded,
                                        size: isMobile ? 16 : 18,
                                      ),
                                      text: "Warnings",
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                          IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade700,
                            ),
                            onPressed: () {
                              // More options
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('No more options available')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Content Area
                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // All Remarks Tab
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _remarks.isEmpty
                              ? const _EmptyState()
                              : _RemarksList(remarks: _remarks),
                          // Positive Tab
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _positiveRemarks.isEmpty
                                  ? const _EmptyState()
                                  : _RemarksList(remarks: _positiveRemarks),
                          // Warnings Tab
                           _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _warningRemarks.isEmpty
                                  ? const _EmptyState()
                                  : _RemarksList(remarks: _warningRemarks),
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
  final String count;
  final IconData icon;
  final Color iconColor;
  final Color countColor;

  const _StatCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.iconColor,
    required this.countColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Icon(icon, color: iconColor, size: 24)],
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: countColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade400
                  : Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _RemarksList extends StatelessWidget {
  final List<dynamic> remarks;
  const _RemarksList({super.key, required this.remarks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: remarks.length,
      itemBuilder: (context, index) {
        final remark = remarks[index];
        // Adjust keys based on actual API response structure
        final remarkText =
            remark['remarks'] ?? remark['remark'] ?? 'No details available';
        final date = remark['created_at'] ?? remark['date'] ?? '';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  remarkText.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (date.toString().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    date.toString(),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade600
                : Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "No remarks found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade300
                  : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "There are no remarks to display at this time",
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade500
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

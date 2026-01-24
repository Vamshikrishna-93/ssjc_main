import 'package:flutter/material.dart';
import 'package:student_app/studentdrawer.dart';
import 'package:student_app/theme_controller.dart';
import 'package:student_app/upload_document_dialog.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int totalDocs = 0;
  int verifiedDocs = 0;
  int pendingDocs = 0;
  int rejectedDocs = 0;

  String selectedCategory = "Financial";

  final List<String> categories = [
    "ID Proof",
    "Academic",
    "Medical",
    "Hostel",
    "Financial",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // ================= COLORS (THEME AWARE) =================

  Color get bg => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF0F172A)
      : const Color(0xFFF8FAFC);

  Color get card => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF020617)
      : Colors.white;

  Color get border => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF1E293B)
      : const Color(0xFFE5E7EB);

  Color get textPrimary => Theme.of(context).brightness == Brightness.dark
      ? Colors.white
      : const Color(0xFF020617);

  Color get textSecondary => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF94A3B8)
      : const Color(0xFF6B7280);

  // ================= ACTIONS =================

  void _refreshData() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Documents refreshed")));
  }

  double get verificationProgress =>
      totalDocs == 0 ? 0 : verifiedDocs / totalDocs;

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 24),
              _statCard(
                title: "Total Documents",
                count: totalDocs,
                icon: Icons.folder_outlined,
                color: const Color(0xFF2563EB),
              ),
              _statCard(
                title: "Verified",
                count: verifiedDocs,
                icon: Icons.check_circle_outline,
                color: const Color(0xFF22C55E),
              ),
              _statCard(
                title: "Pending",
                count: pendingDocs,
                icon: Icons.access_time,
                color: const Color(0xFFF59E0B),
              ),
              _statCard(
                title: "Rejected",
                count: rejectedDocs,
                icon: Icons.warning_amber_rounded,
                color: const Color(0xFFEF4444),
              ),
              const SizedBox(height: 28),
              _tabsSection(),
              const SizedBox(height: 28),
              _categoriesSection(),
              const SizedBox(height: 28),
              _verificationProgress(),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.folder_outlined, size: 28, color: textPrimary),
              const SizedBox(height: 12),
              Text(
                "Documents",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Manage your student\n"
                "documents and\n"
                "verifications",
                style: TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: textSecondary,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const UploadDocumentDialog(initialCategory: ''),
                );
              },
              icon: const Icon(Icons.upload, size: 18),
              label: const Text("Upload Document"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: _refreshData,
              icon: const Icon(Icons.download, size: 18),
              label: const Text("Refresh"),
              style: OutlinedButton.styleFrom(
                foregroundColor: textPrimary,
                side: BorderSide(color: border),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= STATS =================

  Widget _statCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textPrimary,
              ),
            ),
          ),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ================= TABS =================

  Widget _tabsSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF2563EB),
            unselectedLabelColor: textSecondary,
            indicatorColor: const Color(0xFF2563EB),
            indicatorWeight: 2,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(text: "All Documents ($totalDocs)"),
              Tab(text: "Pending Verification ($pendingDocs)"),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 120,
            child: TabBarView(
              controller: _tabController,
              children: [_emptyState(), _emptyState()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox_outlined, size: 44, color: border),
        const SizedBox(height: 10),
        Text(
          "No documents found",
          style: TextStyle(fontSize: 14, color: textSecondary),
        ),
      ],
    );
  }

  // ================= CATEGORIES =================

  Widget _categoriesSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Document Categories",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ...categories.map(_categoryTile),
        ],
      ),
    );
  }

  Widget _categoryTile(String title) {
    final bool selected = title == selectedCategory;

    return GestureDetector(
      onTap: () {
        setState(() => selectedCategory = title);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => UploadDocumentDialog(initialCategory: title),
        );
      },

      child: Container(
        height: 44,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? const Color(0xFF2563EB) : border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_outlined,
              size: 18,
              color: selected ? const Color(0xFF2563EB) : textPrimary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: selected ? const Color(0xFF2563EB) : textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= PROGRESS =================

  Widget _verificationProgress() {
    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
            child: Text(
              "Verification Progress",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
          ),

          Divider(height: 1, color: border),

          // BODY
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PROGRESS ROW
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: verificationProgress,
                          minHeight: 8,
                          backgroundColor: border,
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "${(verificationProgress * 100).round()}%",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // VERIFIED TEXT
                Text(
                  "$verifiedDocs of $totalDocs documents verified",
                  style: TextStyle(fontSize: 14, color: textSecondary),
                ),

                const SizedBox(height: 10),

                // LAST UPDATED
                Text(
                  "Last updated: 11/1/2026",
                  style: TextStyle(fontSize: 12, color: textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

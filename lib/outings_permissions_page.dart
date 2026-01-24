import 'package:flutter/material.dart';
import 'package:student_app/studentdrawer.dart';
import 'package:student_app/theme_controller.dart';

class OutingsPermissionsPage extends StatelessWidget {
  const OutingsPermissionsPage({super.key});

  String _month(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= Header Row =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isMobile = constraints.maxWidth < 380;

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.directions_car,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.color,
                                size: isMobile ? 22 : 24,
                              ),
                              const SizedBox(width: 8),

                              // IMPORTANT: Expanded prevents overflow
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Outings & Permissions",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: isMobile ? 18 : 24,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "View your outing records and permissions",
                                      maxLines: isMobile ? 2 : 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: isMobile ? 12 : 14,
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    OutlinedButton.icon(
                      onPressed: () {
                        // Refresh functionality
                      },
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

                const SizedBox(height: 20),

                // ================= Info Container (Image Section) =================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(
                            0xFF1E3A5F,
                          ) // Dark blue background for dark mode
                        : const Color(0xFFEFF6FF), // light blue background
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(
                              0xFF3B82F6,
                            ) // Darker border for dark mode
                          : const Color(0xFFBFDBFE),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(
                                  0xFF3B82F6,
                                ) // Darker blue for dark mode
                              : const Color(0xFF2563EB),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "No outings this month",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : const Color(0xFF1E3A8A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "You haven't used any outings this month.",
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey.shade300
                                    : const Color(0xFF1D4ED8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Stats Cards
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // makes children fit screen width
              children: [
                _StatCard(
                  title: "Monthly Limit",
                  value: "8 outings",
                  valueColor: const Color(0xFF2563EB),
                ),

                const SizedBox(height: 16),

                _StatCard(title: "Used", value: "0", valueColor: Colors.green),

                const SizedBox(height: 16),

                _StatCard(
                  title: "Remaining",
                  value: "8 outings",
                  valueColor: Colors.orange,
                ),
                const SizedBox(height: 16),
                _StatCard(
                  title: "last outing",
                  value: "24 sep 2025",
                  valueColor: const Color(0xFF2563EB),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Outing Records
            StatefulBuilder(
              builder: (context, setState) {
                bool isAscending = false;

                final List<Map<String, dynamic>> records = [
                  {
                    "date": DateTime(2025, 9, 24),
                    "out": "12:20 PM",
                    "in": "05:23 PM",
                    "purpose": "Functions",
                    "homePass": false,
                  },
                  {
                    "date": DateTime(2025, 9, 7),
                    "out": "06:36 PM",
                    "in": "04:35 AM",
                    "purpose": "Health Problem",
                    "homePass": true,
                  },
                  {
                    "date": DateTime(2025, 8, 07),
                    "out": "12:20 PM",
                    "in": "05:23 PM",
                    "purpose": "Functions",
                    "homePass": true,
                  },
                  {
                    "date": DateTime(2025, 7, 16),
                    "out": "06:36 PM",
                    "in": "04:35 AM",
                    "purpose": "Health Problem",
                    "homePass": false,
                  },
                ];

                void sortByDate(bool asc) {
                  setState(() {
                    isAscending = asc;
                    records.sort(
                      (a, b) => asc
                          ? a["date"].compareTo(b["date"])
                          : b["date"].compareTo(a["date"]),
                    );
                  });
                }

                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withValues(alpha: 0.3)
                            : Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ================= Title =================
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "Outing Records",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),

                      // ================= Header =================
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade800.withValues(alpha: 0.5)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text(
                                    "Date",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () => sortByDate(true),
                                        child: Icon(
                                          Icons.keyboard_arrow_up,
                                          size: 18,
                                          color: isAscending
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.primary
                                              : Colors.grey,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => sortByDate(false),
                                        child: Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 18,
                                          color: !isAscending
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.primary
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Timing",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Purpose",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Status",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ================= Records =================
                      ...records.map((r) {
                        final d = r["date"] as DateTime;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      d.day.toString().padLeft(2, '0'),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                    Text(
                                      "${_month(d.month)} ${d.year}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Out: ${r["out"]}",
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "In: ${r["in"]}",
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  r["purpose"],
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: r["homePass"]
                                    ? Chip(
                                        label: const Text("Home Pass"),
                                        backgroundColor:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.blue.shade900.withValues(
                                                alpha: 0.3,
                                              )
                                            : Colors.blue.shade50,
                                      )
                                    : const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // stat section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quick Stats",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _statRow("Total Outings", "2"),
                  const SizedBox(height: 8),
                  _statRow("Approved", "2"),
                  const SizedBox(height: 8),
                  _statRow("Rejected", "0"),
                  const SizedBox(height: 8),
                  _statRow("Pending", "0"),
                  const SizedBox(height: 8),
                  _statRow("Success Rate", "100%"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recent Activity",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _activityItem("Functions", "24 Sep 2025"),
                  const SizedBox(height: 14),
                  _activityItem("Health Problem", "07 Sep 2025"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _activityItem(String title, String date) {
  return Builder(
    builder: (context) => Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.green.withValues(alpha: 0.3)
                : Colors.green.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 14, color: Colors.green),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            "$title ($date)",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _statRow(String label, String value) {
  return Builder(
    builder: (context) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$label :",
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade400
                : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    ),
  );
}

Widget _StatCard({
  required String title,
  required String value,
  required Color valueColor,
}) {
  return Builder(
    builder: (context) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).cardColor
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).dividerColor
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade400
                  : Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    ),
  );
}

// ignore: unused_element
class _OutingRecordItem extends StatelessWidget {
  final String date;
  final String outTime;
  final String inTime;
  final String purpose;
  final bool isHomePass;

  const _OutingRecordItem({
    required this.date,
    required this.outTime,
    required this.inTime,
    required this.purpose,
    required this.isHomePass,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            flex: 2,
            child: Text(
              date,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Out: $outTime",
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                Text(
                  "In: $inTime",
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              purpose,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Expanded(
            child: isHomePass
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Home Pass",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : const Icon(Icons.check_circle, color: Colors.green, size: 20),
          ),
        ],
      ),
    );
  }
}

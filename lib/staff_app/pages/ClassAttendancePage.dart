import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassAttendancePage extends StatelessWidget {
  const ClassAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("View Class Attendance"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // ✅ BACKGROUND GRADIENT
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0B132B),
                    Color(0xFF1C2541),
                    Color(0xFF3A506B),
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF5F7FA),
                    Color(0xFFE4E8F0),
                  ],
                ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 10),

                _selectionCard(
                  isDark: isDark,
                  icon: Icons.account_tree_rounded,
                  iconColor: Colors.cyan,
                  title: "Select Branch",
                  value: "SSJC - VIDHYA BHAVAN",
                ),

                _selectionCard(
                  isDark: isDark,
                  icon: Icons.groups_rounded,
                  iconColor: Colors.purple,
                  title: "Select Group",
                ),

                _selectionCard(
                  isDark: isDark,
                  icon: Icons.menu_book_rounded,
                  iconColor: Colors.blue,
                  title: "Select Course",
                ),

                _selectionCard(
                  isDark: isDark,
                  icon: Icons.class_rounded,
                  iconColor: Colors.pink,
                  title: "Select Batch",
                ),

                _selectionCard(
                  isDark: isDark,
                  icon: Icons.schedule_rounded,
                  iconColor: Colors.orange,
                  title: "Select Shift",
                ),

                const SizedBox(height: 30),

                // ✅ BUTTON (works in both themes)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.search, size: 22),
                    label: const Text(
                      "Get Students",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1FFFE0),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= SELECTION CARD =================

  Widget _selectionCard({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    String? value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      // ✅ CARD COLOR BASED ON THEME
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.2) : Colors.grey.shade300,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),

      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                if (value != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isDark ? Colors.cyanAccent : Colors.grey.shade600,
            size: 28,
          ),
        ],
      ),
    );
  }
}

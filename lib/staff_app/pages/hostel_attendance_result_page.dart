import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/search_field.dart';
import '../controllers/hostel_controller.dart';
import 'hostel_attendance_mark_page.dart';

class HostelAttendanceResultPage extends StatefulWidget {
  const HostelAttendanceResultPage({super.key});

  @override
  State<HostelAttendanceResultPage> createState() =>
      _HostelAttendanceResultPageState();
}

class _HostelAttendanceResultPageState
    extends State<HostelAttendanceResultPage> {
  final HostelController hostelCtrl = Get.find<HostelController>();
  String _query = "";

  // COLORS
  static const Color neon = Color(0xFF00FFF5);
  static const Color darkNavy = Color(0xFF1a1a2e);
  static const Color darkBlue = Color(0xFF16213e);
  static const Color midBlue = Color(0xFF0f3460);
  static const Color purpleDark = Color(0xFF533483);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: const Color(0xFF16213e),

      // ✅ PERFECT APP BAR
      appBar: AppBar(
        backgroundColor: isDark
            ? Colors.black.withOpacity(0.35)
            : Colors.white.withOpacity(0.95),
        elevation: 0,
        title: Text(
          "Hostel Attendance",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [darkNavy, darkBlue, midBlue, purpleDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isDark ? null : Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          children: [
            // ✅ FIXED GAP BELOW APP BAR
            const SizedBox(height: kToolbarHeight + 10),

            // 🔍 SEARCH BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.white : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.24)
                        : Theme.of(context).dividerColor,
                  ),
                ),
                child: SearchField(
                  hint: 'Search floor / hostel',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.black54 : Colors.black45,
                  ),
                  textColor: Colors.black,
                  iconColor: Colors.black87,
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 📋 LIST
            Expanded(
              child: Obx(() {
                if (hostelCtrl.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filtered = hostelCtrl.roomsSummary.where((row) {
                  final q = _query.toLowerCase();
                  return (row['room']?.toString() ?? '').toLowerCase().contains(
                        q,
                      ) ||
                      (row['floor']?.toString() ?? '').toLowerCase().contains(
                        q,
                      ) ||
                      (row['incharge']?.toString() ?? '')
                          .toLowerCase()
                          .contains(q);
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      "No attendance records found",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) =>
                      _attendanceCard(filtered[index], index + 1, isDark),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CARD =================
  Widget _attendanceCard(Map<String, dynamic> row, int sNo, bool isDark) {
    // Parse all metrics safely
    final total = int.tryParse(row['total']?.toString() ?? '0') ?? 0;
    final present = int.tryParse(row['present']?.toString() ?? '0') ?? 0;
    final outing = int.tryParse(row['outing']?.toString() ?? '0') ?? 0;
    final homePass = int.tryParse(row['home_pass']?.toString() ?? '0') ?? 0;
    final selfOuting = int.tryParse(row['self_outing']?.toString() ?? '0') ?? 0;
    final selfHome = int.tryParse(row['self_home']?.toString() ?? '0') ?? 0;

    // Calculate absent or use missing if available?
    // Usually: Absent = Total - (Present + Outing + HomePass + ...)
    // But for now let's just use Total - Present as 'Not Present' or
    // maybe verify if 'missing' field exists? The API screenshot doesn't show it clearly.
    // Let's stick to Total - Present for "Absent/Missing" generally,
    // OR just display "Missing" if we want to be specific about who is not accounted for.
    // However, if someone is on Outing, they are not "Present" in room, but valid.
    // Let's display "Missing" as (Total - Present - Outing - HomePass - SelfOuting - SelfHome).

    final accountedFor = present + outing + homePass + selfOuting + selfHome;
    final missing = (total - accountedFor).clamp(0, total);

    return InkWell(
      onTap: () {
        Get.to(
          () => const HostelAttendanceMarkPage(),
          arguments: {
            'room_id': row['room'],
            'room_name': row['room']?.toString() ?? 'N/A',
            'floor_name': row['floor'],
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? null : Theme.of(context).cardColor,
          gradient: isDark
              ? const LinearGradient(colors: [midBlue, purpleDark])
              : null,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? neon.withOpacity(0.35) : Colors.grey.shade300,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? neon.withOpacity(0.25)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "S.No: $sNo",
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: neon,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    row['room']?.toString() ?? 'N/A',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Text(
              "Floor: ${row['floor'] ?? 'N/A'}",
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
            ),
            const SizedBox(height: 6),
            Text(
              "Incharge: ${row['incharge'] ?? 'N/A'}",
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
            ),

            const SizedBox(height: 14),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _badge(Icons.people, "Total: $total", Colors.blueAccent),
                _badge(
                  Icons.check_circle,
                  "Present: $present",
                  Colors.greenAccent,
                ),
                if (outing > 0)
                  _badge(
                    Icons.directions_walk,
                    "Outing: $outing",
                    Colors.orangeAccent,
                  ),
                if (homePass > 0)
                  _badge(
                    Icons.home,
                    "Home Pass: $homePass",
                    Colors.purpleAccent,
                  ),
                if (selfOuting > 0)
                  _badge(
                    Icons.directions_run,
                    "Self Outing: $selfOuting",
                    Colors.tealAccent,
                  ),
                if (selfHome > 0)
                  _badge(Icons.cottage, "Self Home: $selfHome", Colors.brown),
                // Show Missing/Absent in Red
                _badge(Icons.cancel, "Missing: $missing", Colors.redAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= BADGE =================
  Widget _badge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1.3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

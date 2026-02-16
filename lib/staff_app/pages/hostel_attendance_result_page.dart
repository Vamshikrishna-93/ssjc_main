import 'package:flutter/material.dart';
import '../widgets/search_field.dart';

class HostelAttendanceResultPage extends StatefulWidget {
  const HostelAttendanceResultPage({super.key});

  @override
  State<HostelAttendanceResultPage> createState() =>
      _HostelAttendanceResultPageState();
}

class _HostelAttendanceResultPageState
    extends State<HostelAttendanceResultPage> {
  String _query = "";

  // COLORS
  static const Color neon = Color(0xFF00FFF5);
  static const Color darkNavy = Color(0xFF1a1a2e);
  static const Color darkBlue = Color(0xFF16213e);
  static const Color midBlue = Color(0xFF0f3460);
  static const Color purpleDark = Color(0xFF533483);

  final List<List<String>> _rows = [
    ['1', 'C-201', '2ND FLOOR C & D BLOCKS', 'GOSU ABHISHEK SAGAR', '7', '0'],
    ['2', 'C-202', '2ND FLOOR C & D BLOCKS', 'GOSU ABHISHEK SAGAR', '7', '0'],
    ['3', 'C-203', '2ND FLOOR C & D BLOCKS', 'GOSU ABHISHEK SAGAR', '8', '0'],
    ['4', 'C-204', '2ND FLOOR C & D BLOCKS', 'GOSU ABHISHEK SAGAR', '9', '0'],
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _rows.where((row) {
      return row[1].toLowerCase().contains(_query.toLowerCase()) ||
          row[2].toLowerCase().contains(_query.toLowerCase()) ||
          row[3].toLowerCase().contains(_query.toLowerCase()) ||
          row[0].contains(_query);
    }).toList();

    return Scaffold(
      backgroundColor: Color(0xFF16213e),

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
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) =>
                    _attendanceCard(filtered[index], isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CARD =================
  Widget _attendanceCard(List<String> row, bool isDark) {
    final total = int.parse(row[4]);
    final present = int.parse(row[5]);
    final absent = total - present;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? null : Theme.of(context).cardColor,
        gradient: isDark
            ? LinearGradient(
                colors: [
                  midBlue.withOpacity(0.55),
                  purpleDark.withOpacity(0.55),
                ],
              )
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
                "S.No: ${row[0]}",
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
                  row[1],
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
            "Floor: ${row[2]}",
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            "Incharge: ${row[3]}",
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
          ),

          const SizedBox(height: 14),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _badge(Icons.people, "Total: $total", neon),
              _badge(
                Icons.check_circle,
                "Present: $present",
                Colors.greenAccent,
              ),
              _badge(Icons.cancel, "Absent: $absent", Colors.redAccent),
            ],
          ),
        ],
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

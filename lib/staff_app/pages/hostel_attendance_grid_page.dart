import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hostel_controller.dart';
import '../model/hostel_grid_model.dart';

class HostelAttendanceGridPage extends StatefulWidget {
  final int sid;
  final String studentName;
  final String admNo;

  const HostelAttendanceGridPage({
    super.key,
    required this.sid,
    required this.studentName,
    required this.admNo,
  });

  @override
  State<HostelAttendanceGridPage> createState() =>
      _HostelAttendanceGridPageState();
}

class _HostelAttendanceGridPageState extends State<HostelAttendanceGridPage> {
  final HostelController hostelCtrl = Get.find<HostelController>();

  // COLORS
  static const Color neon = Color(0xFF00FFF5);
  static const Color darkNavy = Color(0xFF1a1a2e);
  static const Color darkBlue = Color(0xFF16213e);
  static const Color midBlue = Color(0xFF0f3460);
  static const Color purpleDark = Color(0xFF533483);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      hostelCtrl.loadHostelGrid(widget.sid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16213e),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Attendance Grid",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              "${widget.studentName} (${widget.admNo})",
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [darkNavy, darkBlue, midBlue, purpleDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (hostelCtrl.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: neon),
              );
            }

            if (hostelCtrl.hostelGrid.isEmpty) {
              return const Center(
                child: Text(
                  "No attendance data found",
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: hostelCtrl.hostelGrid.length,
              itemBuilder: (context, index) {
                final monthData = hostelCtrl.hostelGrid[index];
                return _MonthGridCard(monthData: monthData);
              },
            );
          }),
        ),
      ),
    );
  }
}

class _MonthGridCard extends StatelessWidget {
  final HostelGridModel monthData;

  const _MonthGridCard({required this.monthData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00FFF5).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF00FFF5).withOpacity(0.5),
                  ),
                ),
                child: Text(
                  monthData.monthName?.toUpperCase() ?? "UNKNOWN",
                  style: const TextStyle(
                    color: Color(0xFF00FFF5),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, // 7 days a week style
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: 31,
            itemBuilder: (context, index) {
              final dayNum = index + 1;
              final key = "Day_${dayNum.toString().padLeft(2, '0')}";
              final status = monthData.dayAttendance[key];

              return _DayCell(day: dayNum, status: status);
            },
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final String? status;

  const _DayCell({required this.day, required this.status});

  Color _getStatusColor(String? s) {
    switch (s?.toUpperCase()) {
      case 'P':
        return Colors.greenAccent;
      case 'A':
        return Colors.redAccent;
      case 'O':
        return Colors.orangeAccent;
      case 'H':
        return Colors.purpleAccent;
      case 'SO':
        return Colors.cyanAccent;
      case 'SH':
        return Colors.yellowAccent;
      default:
        return Colors.white.withOpacity(0.05); // Default/Null
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    final hasStatus = status != null && status != 'null' && status!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: hasStatus ? color : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: hasStatus
            ? null
            : Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Stack(
        children: [
          // Day Number
          Center(
            child: Text(
              "$day",
              style: TextStyle(
                color: hasStatus ? Colors.black87 : Colors.white30,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          // Status Indicator (small dot or text?)
          // Since the box is colored, maybe just the number is fine.
          // Or show the status code instead of day number if present?
          // Let's overlay status code small if present.
          if (hasStatus)
            Positioned(
              bottom: 2,
              right: 2,
              child: Text(
                status!,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

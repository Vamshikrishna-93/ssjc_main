import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hostel_controller.dart';
import '../widgets/skeleton.dart';

class HostelAttendanceStatusPage extends StatelessWidget {
  const HostelAttendanceStatusPage({super.key});

  // COLORS
  static const Color neon = Color(0xFF00FFF5);
  static const Color darkNavy = Color(0xFF1a1a2e);
  static const Color darkBlue = Color(0xFF16213e);
  static const Color midBlue = Color(0xFF0f3460);
  static const Color purpleDark = Color(0xFF533483);

  @override
  Widget build(BuildContext context) {
    final HostelController hostelCtrl = Get.find<HostelController>();

    return Scaffold(
      backgroundColor: const Color(0xFF16213e),
      appBar: AppBar(
        title: Text(
          "Hostel Attendance Status",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
              return const Padding(
                padding: EdgeInsets.all(16),
                child: SkeletonList(itemCount: 5),
              );
            }

            if (hostelCtrl.roomsSummary.isEmpty) {
              return Center(
                child: Text(
                  "No data available",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: hostelCtrl.roomsSummary.length,
              itemBuilder: (context, index) {
                final row = hostelCtrl.roomsSummary[index];
                return _AttendanceStatusCard(row: row, index: index + 1);
              },
            );
          }),
        ),
      ),
    );
  }
}

class _AttendanceStatusCard extends StatelessWidget {
  final Map<String, dynamic> row;
  final int index;

  const _AttendanceStatusCard({required this.row, required this.index});

  @override
  Widget build(BuildContext context) {
    final room = row['room']?.toString() ?? '-';
    final floor = row['floor']?.toString() ?? '-';
    final incharge = row['incharge']?.toString() ?? 'N/A';
    final total = int.tryParse(row['total']?.toString() ?? '0') ?? 0;
    final present = int.tryParse(row['present']?.toString() ?? '0') ?? 0;
    final outing = int.tryParse(row['outing']?.toString() ?? '0') ?? 0;
    final homePass = int.tryParse(row['home_pass']?.toString() ?? '0') ?? 0;
    final selfOuting = int.tryParse(row['self_outing']?.toString() ?? '0') ?? 0;
    final selfHome = int.tryParse(row['self_home']?.toString() ?? '0') ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: S.No and Room Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "S.No: $index",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: HostelAttendanceStatusPage.neon,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  room,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Floor and Incharge Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.layers_outlined,
                    color: Colors.white70,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    floor,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    color: Colors.white70,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    incharge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Divider(color: Colors.white10, height: 24),

          // Metrics Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;
              // 4 items in first row, so roughly width / 4 minus spacing
              final double itemWidth4 = (width - 3 * 8) / 4;
              // 2 items in second row, width / 2 minus spacing
              final double itemWidth2 = (width - 8) / 2;

              return Column(
                children: [
                  // ROW 1: Total, Present, Outing, Home Pass
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _MetricBadge(
                        label: "Total",
                        value: "$total",
                        color: Colors.blue,
                        width: itemWidth4,
                      ),
                      _MetricBadge(
                        label: "Present",
                        value: "$present",
                        color: Colors.tealAccent, // Greenish from screenshot
                        width: itemWidth4,
                      ),
                      _MetricBadge(
                        label: "Outing",
                        value: "$outing",
                        color: Colors.amber,
                        width: itemWidth4,
                      ),
                      _MetricBadge(
                        label: "Home Pass",
                        value: "$homePass",
                        color: Colors.purpleAccent,
                        width: itemWidth4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // ROW 2: Self Outing, Self Home
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _MetricBadge(
                        label: "Self Outing",
                        value: "$selfOuting",
                        color: Colors.cyan,
                        width: itemWidth2,
                      ),
                      _MetricBadge(
                        label: "Self Home",
                        value: "$selfHome",
                        color: Colors.lightGreenAccent, // Yellowish green
                        width: itemWidth2,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MetricBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final double width;

  const _MetricBadge({
    required this.label,
    required this.value,
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

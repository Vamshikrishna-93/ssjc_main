import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hostel_controller.dart';
import '../controllers/branch_controller.dart';
import 'hostel_attendance_grid_page.dart';

class HostelAttendanceMarkPage extends StatefulWidget {
  const HostelAttendanceMarkPage({super.key});

  @override
  State<HostelAttendanceMarkPage> createState() =>
      _HostelAttendanceMarkPageState();
}

class _HostelAttendanceMarkPageState extends State<HostelAttendanceMarkPage> {
  final HostelController hostelCtrl = Get.find<HostelController>();
  final Map<String, dynamic> args = Get.arguments;

  // COLORS
  static const Color neon = Color(0xFF00FFF5);
  static const Color darkNavy = Color(0xFF1a1a2e);
  static const Color darkBlue = Color(0xFF16213e);
  static const Color midBlue = Color(0xFF0f3460);
  static const Color purpleDark = Color(0xFF533483);

  // State for attendance marking
  final Map<int, String> _statuses = {}; // sid -> status (P/A)

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStudents();
    });
  }

  Future<void> _loadStudents() async {
    // Note: Adjust params based on what's available in args
    // We need shift and date. For now, using defaults.
    await hostelCtrl.loadRoomStudents(
      shift: '1', // Default shift
      date: DateTime.now().toIso8601String().split('T')[0],
      roomId: args['room_id'].toString(),
    );

    // Initialize statuses to Present by default
    for (final s in hostelCtrl.roomStudents) {
      _statuses[s.sid] = 'P';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final roomName = args['room_name'] ?? 'Room';

    return Scaffold(
      backgroundColor: const Color(0xFF16213e),
      appBar: AppBar(
        title: Text(
          "Mark Attendance - $roomName",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark
            ? Colors.black.withOpacity(0.35)
            : Colors.white.withOpacity(0.95),
        elevation: 0,
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
            Expanded(
              child: Obx(() {
                if (hostelCtrl.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (hostelCtrl.roomStudents.isEmpty) {
                  return const Center(
                    child: Text(
                      "No students found in this room",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: hostelCtrl.roomStudents.length,
                  itemBuilder: (context, index) {
                    final student = hostelCtrl.roomStudents[index];
                    final sid = student.sid;
                    final currentStatus = _statuses[sid] ?? 'P';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? null : Theme.of(context).cardColor,
                        gradient: isDark
                            ? const LinearGradient(
                                colors: [midBlue, purpleDark],
                              )
                            : null,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? neon.withOpacity(0.35)
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? neon.withOpacity(0.15)
                                : Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.studentName,
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Adm No: ${student.admno}",
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // View History Button
                          IconButton(
                            icon: const Icon(
                              Icons.history,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () {
                              Get.to(
                                () => HostelAttendanceGridPage(
                                  sid: student.sid,
                                  studentName: student.studentName,
                                  admNo: student.admno,
                                ),
                              );
                            },
                          ),
                          _statusButton(
                            'P',
                            Colors.greenAccent,
                            currentStatus == 'P',
                            () {
                              setState(() => _statuses[sid] = 'P');
                            },
                          ),
                          const SizedBox(width: 8),
                          _statusButton(
                            'A',
                            Colors.redAccent,
                            currentStatus == 'A',
                            () {
                              setState(() => _statuses[sid] = 'A');
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: isDark
                      ? const LinearGradient(colors: [neon, Colors.cyan])
                      : const LinearGradient(
                          colors: [Color(0xFF0f3460), Color(0xFF533483)],
                        ),
                  boxShadow: isDark
                      ? [
                          BoxShadow(
                            color: neon.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _submit,
                  child: const Text(
                    "Submit Attendance",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusButton(
    String label,
    Color color,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final sids = _statuses.keys.toList();
    final statuses = sids.map((id) => _statuses[id]!).toList();

    // 1. Get Branch ID
    final BranchController branchCtrl = Get.put(BranchController());
    if (branchCtrl.branches.isEmpty) {
      await branchCtrl.loadBranches();
    }
    // Try to get branch from active filter or default
    String branchId = '1';
    if (hostelCtrl.activeBranch.value.isNotEmpty) {
      final b = branchCtrl.branches.firstWhereOrNull(
        (element) => element.branchName == hostelCtrl.activeBranch.value,
      );
      if (b != null) branchId = b.id.toString();
    } else {
      // Fallback to selected branch in controller
      branchId = branchCtrl.selectedBranch.value?.id.toString() ?? '1';
    }

    // 2. Get Hostel ID
    String hostelId = '1';
    if (hostelCtrl.hostels.isEmpty && branchId != '1') {
      await hostelCtrl.loadHostelsByBranch(int.parse(branchId));
    }

    if (hostelCtrl.activeHostel.value.isNotEmpty) {
      final h = hostelCtrl.hostels.firstWhereOrNull(
        (element) => element.buildingName == hostelCtrl.activeHostel.value,
      );
      if (h != null) hostelId = h.id.toString();
    }

    // 3. Floor ID
    // If activeFloor is set (Name), try to find ID?
    // Or just pass the Name if that's what we have.
    // Screenshot 3 has `Mark Attendance - 101`. `args` has `room_name`, `floor_name`.
    // Let's assume we pass Name if we can't find ID, or use `1` as generic fallback if critical?
    // Actually, `ApiCollection` says `floor` param.
    String floorId = args['floor_name'] ?? hostelCtrl.activeFloor.value;
    // Attempt lookup if `members` are loaded
    if (hostelCtrl.members.isNotEmpty) {
      final m = hostelCtrl.members.firstWhereOrNull(
        (element) => element['floor']?.toString() == floorId,
      );
      if (m != null && m.containsKey('floor_id')) {
        floorId = m['floor_id'].toString();
      }
    }

    final success = await hostelCtrl.submitAttendance(
      branchId: branchId,
      hostel: hostelId,
      floor: floorId,
      room: args['room_id']
          .toString(), // Use Room ID directly as it is available
      shift: '1',
      sidList: sids,
      statusList: statuses,
    );

    if (success) {
      Get.back();
      Get.snackbar("Success", "Attendance saved successfully");
    }
  }
}

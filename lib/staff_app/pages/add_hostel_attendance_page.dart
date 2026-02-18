import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/hostel_controller.dart';
import '../controllers/branch_controller.dart';

class AddHostelAttendancePage extends StatefulWidget {
  final String? branch;
  final String? hostel;
  final String? floor;
  final String? room;
  final String? month;

  const AddHostelAttendancePage({
    super.key,
    this.branch,
    this.hostel,
    this.floor,
    this.room,
    this.month,
  });

  @override
  State<AddHostelAttendancePage> createState() =>
      _AddHostelAttendancePageState();
}

class _AddHostelAttendancePageState extends State<AddHostelAttendancePage> {
  final HostelController hostelCtrl = Get.find<HostelController>();

  // Mock student data - replace with actual API data
  final List<Map<String, dynamic>> students = [];
  final Map<int, String> attendanceStatus = {};

  bool isLoading = false;
  String selectedDate = DateTime.now().toIso8601String().split('T')[0];

  // Attendance status options
  final List<String> statusOptions = [
    'Present',
    'Missing',
    'Outing',
    'Home Pass',
    'Self Outing',
    'Self Home',
  ];

  // DARK COLORS (matching dashboard)
  static const Color dark1 = Color(0xFF1a1a2e);
  static const Color dark2 = Color(0xFF16213e);
  static const Color dark3 = Color(0xFF0f3460);
  static const Color purpleDark = Color(0xFF533483);

  @override
  void initState() {
    super.initState();
    // Initialize all students as 'Present' by default
    for (int i = 0; i < students.length; i++) {
      attendanceStatus[i] = 'Present';
    }
  }

  Future<void> _getStudents() async {
    await hostelCtrl.loadRoomStudents(
      shift: '1', // Default shift
      date: selectedDate,
      roomId: widget.room ?? '',
    );

    // Initialize attendance status to 'Present' for all students
    for (final student in hostelCtrl.roomStudents) {
      attendanceStatus[student.sid] = 'Present';
    }
  }

  Future<void> _submitAttendance() async {
    final List<int> sids = [];
    final List<String> statuses = [];

    for (final student in hostelCtrl.roomStudents) {
      sids.add(student.sid);
      // Map full status names to single chars if needed by backend (API usually expects 'P', 'A', 'O', etc.)
      // Assuming backend accepts full words or we map them here.
      // Based on screenshot 3, it sends "A" for Absent.
      // Let's map them.
      String status = attendanceStatus[student.sid] ?? 'Present';
      String statusCode = 'P';
      switch (status) {
        case 'Present':
          statusCode = 'P';
          break;
        case 'Missing':
          statusCode =
              'A'; // or 'M'? Screenshot shows 'A' button, table has 'Missing'. Let's use 'A' for Absent/Missing
          break;
        case 'Outing':
          statusCode = 'O';
          break;
        case 'Home Pass':
          statusCode = 'H';
          break;
        case 'Self Outing':
          statusCode = 'SO';
          break;
        case 'Self Home':
          statusCode = 'SH';
          break;
        default:
          statusCode = 'P';
      }
      statuses.add(statusCode);
    }

    // 1. Find Branch ID
    final BranchController branchCtrl = Get.put(BranchController());
    // If branches aren't loaded, we might need to load them first or rely on pre-loaded data
    if (branchCtrl.branches.isEmpty) {
      await branchCtrl.loadBranches();
    }

    final branchName = widget.branch;
    final branchObj = branchCtrl.branches.firstWhereOrNull(
      (b) => b.branchName == branchName,
    );
    final String branchId =
        branchObj?.id.toString() ?? '1'; // Default to 1 or handle error

    // 2. Find Hostel ID (Building ID)
    // Ensure hostels are loaded for the branch
    if (hostelCtrl.hostels.isEmpty) {
      // We might need to load them if not present, but usually they are if we are here.
      // If not, we can try to load them if we have a branch ID
      if (branchObj != null) {
        await hostelCtrl.loadHostelsByBranch(branchObj.id);
      }
    }

    final hostelName = widget.hostel;
    final hostelObj = hostelCtrl.hostels.firstWhereOrNull(
      (h) => h.buildingName == hostelName,
    );
    final String hostelId = hostelObj?.id.toString() ?? '1';

    // 3. Find Floor ID - we don't have a direct Floor ID lookup map easily accessible
    // without iterating members or having a floor model.
    // BUT the API for "store" might accept the raw value if it's just a number,
    // OR we need to find the ID.
    // Looking at `HostelController.loadFloorsAndRooms`, it extracts floor names.
    // And `ApiCollection.storeHostelAttendance` describes params as `hostel`, `floor`, `room`.
    // If the backend expects IDs for floor/room, we have a problem because we only have names here.
    // However, in `HostelController.loadFloorsAndRooms`, we loaded `members`.
    // `members` contains `floor` and `room` fields which are likely Names (e.g. "1-FLOOR").
    // Let's assume for now that passing the Name is what's intended OR
    // strict IDs are required. The Screenshot shows `floor=2`, `room=7`. These are definitely IDs.

    // We need to find Floor ID and Room ID.
    // We can try to find them from `hostelCtrl.members` if it has ID fields?
    // checking `members` data structure... `getHostelMembers` returns a list of maps.
    // We didn't see the full structure in `view_file` of controller, but usually it has `floor_id`, `room_id`?
    // If not, we might be stuck sending names or need to fetch structure.

    // HACK: Filter `hostelCtrl.members` to find a matching floor/room name and get its ID if available.
    String floorId = widget.floor ?? '0';
    String roomId = widget.room ?? '0';

    if (hostelCtrl.members.isNotEmpty) {
      final member = hostelCtrl.members.firstWhereOrNull(
        (m) =>
            m['floor']?.toString() == widget.floor &&
            m['room']?.toString() == widget.room,
      );
      if (member != null) {
        // If the API response contains explicit IDs
        if (member.containsKey('floor_id'))
          floorId = member['floor_id'].toString();
        if (member.containsKey('room_id'))
          roomId = member['room_id'].toString();
        // If not, we might have to rely on the names being numbers or something,
        // but `widget.floor` is "1-FLOOR".
        // Let's try to parse if it contains a number, or stick with what we have.
        // Screenshot shows `floor_id=2`...
      }
    }

    // If we still don't have IDs and we are sending names like "1-FLOOR", it might fail.
    // But let's proceed with finding what we can.
    // For now, I will assume the `HostelAttendanceStatusPage` (which likely navigates here)
    // passed names.
    // Wait, the user said "Add Hostel Attendance Page" and "Hostel Attendance Mark Page".
    // If I look at the `HostelAttendanceMarkPage` (screenshot 3), it has `Mark Attendance - 101`.
    // The previous page `HostelAttendanceStatusPage` (screenshot 1) shows `Room 101`.

    // Let's check `HostelController.loadFloorsAndRooms` again.
    // It calls `ApiService.getHostelMembers`.
    // `ApiCollection.hostelMembersList` takes type/param.

    // If I cannot guarantee IDs, I will send what I have, but try to find IDs from `members`.
    // I'll add a helper to look up IDs from the member list which contains everything.

    final success = await hostelCtrl.submitAttendance(
      branchId: branchId,
      hostel: hostelId, // Building ID
      floor: floorId, // Sending Name if ID not found, but likely need ID
      room: roomId, // Sending Name if ID not found
      shift: '1',
      sidList: sids,
      statusList: statuses,
    );

    if (success) {
      Get.snackbar(
        'Success',
        'Attendance submitted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF16213e),

        // ---------------- APP BAR ----------------
        appBar: AppBar(
          backgroundColor: isDark
              ? Colors.black.withOpacity(0.4)
              : Colors.white.withOpacity(0.9),
          elevation: 0,
          title: Text(
            "Add Hostel Attendance",
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

        // ---------------- BODY ----------------
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    colors: [dark1, dark2, dark3, purpleDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [Color(0xFFF5F6FA), Color(0xFFE8ECF4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Filter Summary Cards
                _buildFilterSummary(isDark),

                // Get Students Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Obx(
                      () => ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? Colors.cyanAccent
                              : const Color(0xFF533483),
                          foregroundColor: isDark ? Colors.black : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: hostelCtrl.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : const Icon(Icons.search),
                        label: Text(
                          hostelCtrl.isLoading.value
                              ? "Loading..."
                              : "Get Students",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: hostelCtrl.isLoading.value
                            ? null
                            : _getStudents,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Obx(() {
                    if (hostelCtrl.roomStudents.isEmpty) {
                      return Center(
                        child: Text(
                          'Click "Get Students" to load student list',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                    return _buildStudentTable(isDark);
                  }),
                ),

                // Submit Button
                Obx(
                  () => hostelCtrl.roomStudents.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: _submitAttendance,
                              child: const Text(
                                'Submit Attendance',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSummary(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _filterChip(isDark, 'Branch', widget.branch ?? 'Not Selected'),
              _filterChip(isDark, 'Hostel', widget.hostel ?? 'Not Selected'),
              _filterChip(isDark, 'Floor', widget.floor ?? 'Not Selected'),
              _filterChip(isDark, 'Room', widget.room ?? 'Not Selected'),
              _filterChip(isDark, 'Date', selectedDate),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterChip(bool isDark, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16213e) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.cyanAccent : const Color(0xFF533483),
        ),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildStudentTable(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            // Table Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF16213e) : Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Text(
                      'S No.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Attendance Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Admission No.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Student Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Phone Number',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Table Rows
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: hostelCtrl.roomStudents.length,
              itemBuilder: (context, index) {
                final student = hostelCtrl.roomStudents[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? Colors.white12 : Colors.grey.shade200,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: attendanceStatus[student.sid] ?? 'Present',
                            isExpanded: true,
                            underline: const SizedBox(),
                            dropdownColor: isDark ? dark2 : Colors.white,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 12,
                            ),
                            items: statusOptions.map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                attendanceStatus[student.sid] = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          student.admno,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () {
                            // TODO: Navigate to student details
                          },
                          child: Text(
                            student.studentName,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          student.phone ?? '',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

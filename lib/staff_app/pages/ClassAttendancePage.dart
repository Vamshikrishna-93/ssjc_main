import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/class_attendance_controller.dart';
import '../controllers/branch_controller.dart';
import '../controllers/group_controller.dart';
import '../controllers/course_controller.dart';
import '../controllers/batch_controller.dart';
import '../controllers/shift_controller.dart';
import '../model/branch_model.dart';
import '../model/group_model.dart';
import '../model/course_model.dart';
import '../model/batch_model.dart';
import '../model/shift_model.dart';
import '../widgets/skeleton.dart';
import '../models/attendance_model.dart';

class ClassAttendancePage extends StatefulWidget {
  const ClassAttendancePage({super.key});

  @override
  State<ClassAttendancePage> createState() => _ClassAttendancePageState();
}

class _ClassAttendancePageState extends State<ClassAttendancePage> {
  // ================= CONTROLLERS =================
  final BranchController branchCtrl = Get.put(BranchController());
  final GroupController groupCtrl = Get.put(GroupController());
  final CourseController courseCtrl = Get.put(CourseController());
  final BatchController batchCtrl = Get.put(BatchController());
  final ShiftController shiftCtrl = Get.put(ShiftController());
  late final ClassAttendanceController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ClassAttendanceController());
    branchCtrl.loadBranches();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Class Attendance"),
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
                  colors: [Color(0xFFF5F7FA), Color(0xFFE4E8F0)],
                ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Branch Selection
                Obx(
                  () => _selectionCard(
                    isDark: isDark,
                    icon: Icons.account_tree_rounded,
                    iconColor: Colors.cyan,
                    title: "Select Branch",
                    value: branchCtrl.selectedBranch.value?.branchName,
                    onTap: () {
                      _showSelectionSheet<BranchModel>(
                        context: context,
                        title: "Select Branch",
                        items: branchCtrl.branches,
                        getName: (item) => item.branchName,
                        onSelected: (item) {
                          branchCtrl.selectedBranch.value = item;
                          groupCtrl.selectedGroup.value = null;
                          courseCtrl.selectedCourse.value = null;
                          batchCtrl.selectedBatch.value = null;
                          groupCtrl.loadGroups(item.id);
                          shiftCtrl.loadShifts(item.id);
                        },
                        isDark: isDark,
                      );
                    },
                  ),
                ),

                // Group Selection
                Obx(
                  () => _selectionCard(
                    isDark: isDark,
                    icon: Icons.groups_rounded,
                    iconColor: Colors.purple,
                    title: "Select Group",
                    value: groupCtrl.selectedGroup.value?.name,
                    onTap: () {
                      if (branchCtrl.selectedBranch.value == null) {
                        Get.snackbar("Info", "Please select a branch first");
                        return;
                      }
                      _showSelectionSheet<GroupModel>(
                        context: context,
                        title: "Select Group",
                        items: groupCtrl.groups,
                        getName: (item) => item.name,
                        onSelected: (item) {
                          groupCtrl.selectedGroup.value = item;
                          courseCtrl.selectedCourse.value = null;
                          batchCtrl.selectedBatch.value = null;
                          courseCtrl.loadCourses(item.id);
                        },
                        isDark: isDark,
                      );
                    },
                  ),
                ),

                // Course Selection
                Obx(
                  () => _selectionCard(
                    isDark: isDark,
                    icon: Icons.menu_book_rounded,
                    iconColor: Colors.blue,
                    title: "Select Course",
                    value: courseCtrl.selectedCourse.value?.courseName,
                    onTap: () {
                      if (groupCtrl.selectedGroup.value == null) {
                        Get.snackbar("Info", "Please select a group first");
                        return;
                      }
                      _showSelectionSheet<CourseModel>(
                        context: context,
                        title: "Select Course",
                        items: courseCtrl.courses,
                        getName: (item) => item.courseName,
                        onSelected: (item) {
                          courseCtrl.selectedCourse.value = item;
                          batchCtrl.selectedBatch.value = null;
                          batchCtrl.loadBatches(item.id);
                        },
                        isDark: isDark,
                      );
                    },
                  ),
                ),

                // Batch Selection
                Obx(
                  () => _selectionCard(
                    isDark: isDark,
                    icon: Icons.class_rounded,
                    iconColor: Colors.pink,
                    title: "Select Batch",
                    value: batchCtrl.selectedBatch.value?.batchName,
                    onTap: () {
                      if (courseCtrl.selectedCourse.value == null) {
                        Get.snackbar("Info", "Please select a course first");
                        return;
                      }
                      _showSelectionSheet<BatchModel>(
                        context: context,
                        title: "Select Batch",
                        items: batchCtrl.batches,
                        getName: (item) => item.batchName,
                        onSelected: (item) {
                          batchCtrl.selectedBatch.value = item;
                        },
                        isDark: isDark,
                      );
                    },
                  ),
                ),

                // Shift Selection
                Obx(
                  () => _selectionCard(
                    isDark: isDark,
                    icon: Icons.schedule_rounded,
                    iconColor: Colors.orange,
                    title: "Select Shift",
                    value: shiftCtrl.selectedShift.value?.shiftName,
                    onTap: () {
                      if (branchCtrl.selectedBranch.value == null) {
                        Get.snackbar("Info", "Please select a branch first");
                        return;
                      }
                      _showSelectionSheet<ShiftModel>(
                        context: context,
                        title: "Select Shift",
                        items: shiftCtrl.shifts,
                        getName: (item) => item.shiftName,
                        onSelected: (item) {
                          shiftCtrl.selectedShift.value = item;
                        },
                        isDark: isDark,
                      );
                    },
                  ),
                ),
                // Date Selection
                Obx(
                  () => _selectionCard(
                    isDark: isDark,
                    icon: Icons.calendar_today_rounded,
                    iconColor: Colors.tealAccent,
                    title: "Select Date",
                    value: controller.selectedDate.value
                        .toString()
                        .split(' ')
                        .first,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: controller.selectedDate.value,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: isDark
                                ? ThemeData.dark().copyWith(
                                    colorScheme: const ColorScheme.dark(
                                      primary: Color(0xFF1FFFE0),
                                      onPrimary: Colors.black,
                                      surface: Color(0xFF1C2541),
                                    ),
                                  )
                                : ThemeData.light(),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        controller.selectedDate.value = picked;
                      }
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // ✅ GET STUDENTS BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Obx(
                    () => ElevatedButton.icon(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.loadClassAttendance(),
                      icon: controller.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Icon(Icons.search, size: 22),
                      label: Text(
                        controller.isLoading.value
                            ? "Loading..."
                            : "Get Students",
                        style: const TextStyle(
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
                ),

                const SizedBox(height: 20),

                // ✅ STUDENT LIST / LOADING / EMPTY / ERROR
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: SkeletonList(itemCount: 5),
                    );
                  }

                  if (controller.attendanceList.isEmpty) {
                    if (controller.errorMessage.value.isNotEmpty) {
                      return _errorCard(isDark, controller.errorMessage.value);
                    }
                    return _emptyStateCard(isDark);
                  }

                  return _markAttendanceSection(isDark);
                }),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= MARK ATTENDANCE SECTION =================
  Widget _markAttendanceSection(bool isDark) {
    return Column(
      children: [
        // ── Attendance Status Badge ──
        Obx(() {
          final bool isError = controller.errorMessage.value.isNotEmpty;
          if (!controller.hasExistingAttendance.value && !isError) {
            return const SizedBox();
          }

          final isTaken =
              controller.errorMessage.value == "Attendance Already Taken";
          final displayMsg = isError
              ? controller.errorMessage.value
              : "ATTENDANCE ALREADY RECORDED FOR THIS DATE";

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isTaken
                  ? Colors.red.withOpacity(0.15)
                  : Colors.amber.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isTaken
                    ? Colors.red.withOpacity(0.4)
                    : Colors.amber.withOpacity(0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isTaken ? Icons.error_outline : Icons.info_outline,
                  color: isTaken ? Colors.red : Colors.amber,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  displayMsg.toUpperCase(),
                  style: TextStyle(
                    color: isDark
                        ? (isTaken
                              ? Colors.red.shade300
                              : Colors.amber.shade200)
                        : (isTaken
                              ? Colors.red.shade900
                              : Colors.amber.shade900),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          );
        }),
        // ── Summary bar ──
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: controller.isSubmitted.value
                  ? Colors.blue.withOpacity(isDark ? 0.15 : 0.05)
                  : (isDark ? Colors.white.withOpacity(0.08) : Colors.white),
              border: Border.all(
                color: controller.isSubmitted.value
                    ? Colors.blue.withOpacity(0.4)
                    : (isDark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.grey.shade300),
              ),
            ),
            child: Column(
              children: [
                if (controller.isSubmitted.value) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        color: Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "ATTENDANCE ARCHIVED (READ-ONLY)",
                        style: TextStyle(
                          color: isDark ? Colors.blue.shade300 : Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    color: Colors.blue.withOpacity(0.2),
                    height: 1,
                    thickness: 1,
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _summaryChip(
                      label: "Total",
                      count: controller.attendanceList.length,
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                      isDark: isDark,
                    ),
                    _summaryChip(
                      label: "Present",
                      count: controller.presentCount,
                      color: Colors.green.shade400,
                      isDark: isDark,
                    ),
                    _summaryChip(
                      label: "Absent",
                      count: controller.absentCount,
                      color: Colors.red.shade400,
                      isDark: isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ── Mark All shortcuts ──
        Obx(
          () => Visibility(
            visible: !controller.isSubmitted.value,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.markAllPresent(),
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text("All Present"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green.shade400,
                      side: BorderSide(color: Colors.green.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.markAllAbsent(),
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: const Text("All Absent"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade400,
                      side: BorderSide(color: Colors.red.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // ── Student cards ──
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.attendanceList.length,
          itemBuilder: (context, index) {
            final student = controller.attendanceList[index];
            return Obx(() {
              final isPresent = controller.attendanceStatus[index] ?? true;
              return _studentAttendanceCard(
                isDark: isDark,
                student: student,
                isPresent: isPresent,
                index: index,
                onToggle: () => controller.toggleAttendance(index),
              );
            });
          },
        ),

        const SizedBox(height: 20),

        // ── Submit Attendance button ──
        Obx(
          () => SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: controller.isSubmitting.value
                  ? null
                  : () => controller.submitAttendance(),
              icon: controller.isSubmitting.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_rounded, size: 22),
              label: Text(
                controller.isSubmitting.value
                    ? "Submitting..."
                    : "Submit Attendance",
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3A506B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= STUDENT ATTENDANCE CARD =================
  Widget _studentAttendanceCard({
    required bool isDark,
    required StudentAttendance student,
    required bool isPresent,
    required int index,
    required VoidCallback onToggle,
  }) {
    final bool isSubmitted = controller.isSubmitted.value;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isPresent
            ? Colors.green.withOpacity(isDark ? 0.12 : 0.07)
            : Colors.red.withOpacity(isDark ? 0.12 : 0.07),
        border: Border.all(
          color: isSubmitted
              ? Colors.grey.withOpacity(0.4)
              : (isPresent
                    ? Colors.green.withOpacity(0.4)
                    : Colors.red.withOpacity(0.4)),
        ),
      ),
      child: Opacity(
        opacity: isSubmitted ? 0.7 : 1.0,
        child: Row(
          children: [
            // Index badge
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isPresent
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
              ),
              alignment: Alignment.center,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isPresent
                      ? Colors.green.shade400
                      : Colors.red.shade400,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Student info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.fullName,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Adm: ${student.admno}',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // P / A toggle
            GestureDetector(
              onTap: isSubmitted ? null : onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isPresent
                      ? Colors.green.shade400
                      : Colors.red.shade400,
                ),
                child: Text(
                  isPresent ? 'P' : 'A',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SUMMARY CHIP =================
  Widget _summaryChip({
    required String label,
    required int count,
    required Color color,
    required bool isDark,
  }) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // ================= SELECTION CARD =================
  Widget _selectionCard({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    String? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.2)
                : Colors.grey.shade300,
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
      ),
    );
  }

  // ================= ERROR CARD =================
  Widget _errorCard(bool isDark, String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.red.withOpacity(0.1) : Colors.red.shade50,
        border: Border.all(
          color: isDark ? Colors.red.withOpacity(0.3) : Colors.red.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade400, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isDark ? Colors.red.shade300 : Colors.red.shade700,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= EMPTY STATE CARD =================
  Widget _emptyStateCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: isDark
                ? Colors.white.withOpacity(0.3)
                : Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            "No Students Found",
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey.shade700,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Select all filters and tap 'Get Students'",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ================= SELECTION SHEET =================
  void _showSelectionSheet<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T) getName,
    required Function(T) onSelected,
    required bool isDark,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E2C) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Divider(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                height: 1,
              ),

              Expanded(
                child: Obx(() {
                  // Determine if the current selection type is loading
                  bool isLoading = false;
                  if (title.contains("Branch"))
                    isLoading = branchCtrl.isLoading.value;
                  else if (title.contains("Group"))
                    isLoading = groupCtrl.isLoading.value;
                  else if (title.contains("Course"))
                    isLoading = courseCtrl.isLoading.value;
                  else if (title.contains("Batch"))
                    isLoading = batchCtrl.isLoading.value;
                  else if (title.contains("Shift"))
                    isLoading = shiftCtrl.isLoading.value;

                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 48,
                            color: isDark
                                ? Colors.white24
                                : Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No $title found",
                            style: TextStyle(
                              color: isDark ? Colors.white54 : Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: items.length,
                    separatorBuilder: (context, index) => Divider(
                      color: isDark ? Colors.white10 : Colors.grey.shade100,
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          getName(item),
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: isDark ? Colors.white24 : Colors.grey.shade300,
                        ),
                        onTap: () {
                          onSelected(item);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

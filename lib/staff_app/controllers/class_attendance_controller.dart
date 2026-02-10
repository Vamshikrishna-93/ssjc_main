import 'package:get/get.dart';

import 'branch_controller.dart';
import 'group_controller.dart';
import 'course_controller.dart';
import 'batch_controller.dart';
import 'shift_controller.dart';
import '../api/api_collection.dart';
import '../api/api_service.dart';

class ClassAttendanceController extends GetxController {
  // ================= DEPENDENT CONTROLLERS =================
  final BranchController branchCtrl = Get.find<BranchController>();
  final GroupController groupCtrl = Get.find<GroupController>();
  final CourseController courseCtrl = Get.find<CourseController>();
  final BatchController batchCtrl = Get.find<BatchController>();
  final ShiftController shiftCtrl = Get.find<ShiftController>();

  // ================= MONTH =================
  final RxString selectedMonth = ''.obs; // format: YYYY-MM

  // ================= ATTENDANCE STATE =================
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> attendanceList =
      <Map<String, dynamic>>[].obs;
  final RxString errorMessage = ''.obs;

  // ================= VALIDATION =================
  bool get isReady {
    return branchCtrl.selectedBranch.value != null &&
        groupCtrl.selectedGroup.value != null &&
        courseCtrl.selectedCourse.value != null &&
        batchCtrl.selectedBatch.value != null &&
        shiftCtrl.selectedShift.value != null &&
        selectedMonth.value.isNotEmpty;
  }

  // ================= LOAD ATTENDANCE =================
  Future<void> loadClassAttendance() async {
    if (!isReady) {
      Get.snackbar("Error", "Please select all fields");
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      attendanceList.clear();

      final res = await ApiService.getRequest(
        ApiCollection.monthlyAttendance(
          branchId: branchCtrl.selectedBranch.value!.id,
          groupId: groupCtrl.selectedGroup.value!.id,
          courseId: courseCtrl.selectedCourse.value!.id,
          batchId: batchCtrl.selectedBatch.value!.id,
          shiftId: shiftCtrl.selectedShift.value!.id,
          month: selectedMonth.value,
        ),
      );

      final success = res['success'] == true || res['success'] == "true";

      if (success && res['indexdata'] != null) {
        attendanceList.assignAll(
          List<Map<String, dynamic>>.from(res['indexdata']),
        );
      } else {
        errorMessage.value = "No attendance data found";
      }
    } catch (e) {
      errorMessage.value = "Failed to load attendance";
      Get.snackbar("Error", errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // ================= CLEAR =================
  void clear() {
    attendanceList.clear();
    errorMessage.value = '';
  }
}

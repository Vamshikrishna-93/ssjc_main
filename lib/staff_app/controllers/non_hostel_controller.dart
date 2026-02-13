import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/api_service.dart';
import '../model/branch_model.dart';
import '../model/non_hostel_student_model.dart';
import 'branch_controller.dart';

class NonHostelController extends GetxController {
  final isLoading = false.obs;
  final studentList = <NonHostelStudentModel>[].obs;
  final filteredList = <NonHostelStudentModel>[].obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchNonHostelStudents();
  }

  Future<void> fetchNonHostelStudents() async {
    try {
      final BranchController branchController = Get.find<BranchController>();

      // Ensure branches are loaded if empty
      if (branchController.branches.isEmpty) {
        await branchController.loadBranches();
      }

      // Select first branch if none selected
      if (branchController.selectedBranch.value == null &&
          branchController.branches.isNotEmpty) {
        branchController.selectedBranch.value = branchController.branches.first;
      }

      final BranchModel? branch = branchController.selectedBranch.value;

      if (branch == null) {
        studentList.clear();
        filteredList.clear();
        debugPrint("Error: No branch selected");
        return;
      }

      isLoading.value = true;
      final students = await ApiService.getNonHostelStudents(branch.id);
      studentList.assignAll(students);
      filterStudents(searchController.text);
    } catch (e) {
      debugPrint("Error fetching non-hostel students: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void filterStudents(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(studentList);
    } else {
      final lowerCaseQuery = query.toLowerCase();
      filteredList.assignAll(
        studentList.where((student) {
          final name = student.studentName.toLowerCase();
          final admNo = student.admNo.toLowerCase();
          return name.contains(lowerCaseQuery) ||
              admNo.contains(lowerCaseQuery);
        }).toList(),
      );
    }
  }
}

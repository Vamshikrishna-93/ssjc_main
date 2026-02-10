// import 'package:get/get.dart';
// import 'package:ssjc_p/api/api_service.dart';
// import 'package:ssjc_p/model/DepartmentModel.dart';
// import 'package:ssjc_p/model/staff_model.dart';

// class StaffController extends GetxController {
//   // ================= STATE =================
//   final isLoading = false.obs;
//   final errorMessage = ''.obs;

//   // ================= DATA =================
//   final staffList = <StaffModel>[].obs;
//   final departmentList = <DepartmentModel>[].obs;

//   // ================= FILTER =================
//   final selectedDepartment = ''.obs;

//   // // ================= UNIQUE DEPARTMENTS (FOR DROPDOWN) =================
//   // List<String> get uniqueDepartments {
//   //   return departmentList
//   //       .map((d) => d.department)
//   //       .toSet() // 🔑 removes duplicates
//   //       .toList();
//   // }
//   List<String> get uniqueDepartments {
//     final Set<String> result = {};

//     for (final d in departmentList) {
//       final name = d.department.toUpperCase().trim();

//       // ✅ NON must be checked FIRST
//       if (name.contains('NON')) {
//         result.add('NON ACADAMIC');
//       }
//       // ✅ FINANCE next
//       else if (name.contains('FINANCE') || name.contains('ACCOUNT')) {
//         result.add('FINANCE');
//       }
//       // ✅ ACADAMIC last
//       else if (name.contains('ACAD')) {
//         result.add('ACADAMIC');
//       }
//     }

//     return result.toList();
//   }

//   // ================= FILTERED STAFF LIST =================
//   List<StaffModel> get filteredDesignations {
//     if (selectedDepartment.value.isEmpty) {
//       return staffList;
//     }

//     return staffList
//         .where(
//           (s) =>
//               s.department.toLowerCase() ==
//               selectedDepartment.value.toLowerCase(),
//         )
//         .toList();
//   }

//   // ================= FETCH STAFF + DEPARTMENTS =================
//   Future<void> fetchStaff() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';

//       final results = await Future.wait([
//         ApiService.getDepartmentsList(),
//         ApiService.getDesignationsList(),
//       ]);

//       // 🔹 Departments
//       departmentList.value =
//           results[0].map((e) => DepartmentModel.fromJson(e)).toList();

//       // 🔹 Staff / Designations
//       staffList.value = results[1].map((e) => StaffModel.fromJson(e)).toList();
//     } catch (e) {
//       errorMessage.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // ================= SET / CLEAR DEPARTMENT =================
//   void setDepartment(String value) {
//     selectedDepartment.value = value;
//   }

//   void clearDepartment() {
//     selectedDepartment.value = '';
//   }
// }
import 'package:get/get.dart';
import 'package:student_app/staff_app/api/api_service.dart';
import 'package:student_app/staff_app/model/DepartmentModel.dart';
import 'package:student_app/staff_app/model/staff_model.dart';


class StaffController extends GetxController {
  // ================= STATE =================
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // ================= DATA =================
  final staffList = <StaffModel>[].obs;
  final departmentList = <DepartmentModel>[].obs;

  // ================= FILTER =================
  final selectedDepartment = 'ALL'.obs;

  // ================= DROPDOWN VALUES =================
  List<String> get uniqueDepartments => const [
        'ALL',
        'FINANCE',
        'ACADAMIC',
        'NON ACADAMIC',
      ];

  // ================= NORMALIZE DEPARTMENT =================
  String normalizeDepartment(String value) {
    final name = value.toUpperCase().trim();

    if (name.contains('NON')) {
      return 'NON ACADAMIC';
    } else if (name.contains('FINANCE') || name.contains('ACCOUNT')) {
      return 'FINANCE';
    } else if (name.contains('ACAD')) {
      return 'ACADAMIC';
    }
    return '';
  }

  // ================= FILTERED STAFF =================
  List<StaffModel> get filteredDesignations {
    // 🔹 ALL → return everything
    if (selectedDepartment.value == 'ALL') {
      return staffList;
    }

    return staffList
        .where(
          (s) => normalizeDepartment(s.department) == selectedDepartment.value,
        )
        .toList();
  }

  // ================= FETCH DATA =================
  Future<void> fetchStaff() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final results = await Future.wait([
        ApiService.getDepartmentsList(),
        ApiService.getDesignationsList(),
      ]);

      departmentList.value =
          results[0].map((e) => DepartmentModel.fromJson(e)).toList();

      staffList.value = results[1].map((e) => StaffModel.fromJson(e)).toList();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ================= SET / CLEAR =================
  void setDepartment(String value) {
    selectedDepartment.value = value;
  }

  void clearDepartment() {
    selectedDepartment.value = 'ALL';
  }
}

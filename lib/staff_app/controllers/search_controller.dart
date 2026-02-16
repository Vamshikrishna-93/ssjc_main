import 'package:get/get.dart';
import '../api/api_service.dart';
import '../model/student_model.dart';

class SearchController extends GetxController {
  // Observable variables
  var searchQuery = ''.obs;
  var searchResults = <StudentModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Search for student by admission number
  Future<void> searchStudent(String admNo) async {
    if (admNo.trim().isEmpty) {
      errorMessage.value = 'Please enter an admission number';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      searchResults.clear();

      final results = await ApiService.searchStudentByAdmNo(admNo.trim());

      if (results.isNotEmpty) {
        searchResults.value = results
            .map((json) => StudentModel.fromJson(json))
            .toList();
      } else {
        errorMessage.value = 'No student found with admission number: $admNo';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Clear search results and reset state
  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
    errorMessage.value = '';
    isLoading.value = false;
  }
}

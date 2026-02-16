import 'package:get/get.dart';
import '../api/api_service.dart';
import '../model/exam_category_model.dart';

class ExamCategoryController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<ExamCategory> categories = <ExamCategory>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      isLoading.value = true;

      final response = await ApiService.getExamCategories();

      categories.assignAll(
        response.map((e) => ExamCategory.fromJson(e)).toList(),
      );
    } catch (e) {
      print("Category API Error: $e");
      categories.clear();
    } finally {
      isLoading.value = false;
    }
  }
}

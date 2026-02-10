import 'package:get/get.dart';
import '../api/api_collection.dart';
import '../api/api_service.dart';
import '../model/batch_model.dart';

class BatchController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<BatchModel> batches = <BatchModel>[].obs;
  final Rxn<BatchModel> selectedBatch = Rxn<BatchModel>();

  Future<void> loadBatches(int courseId) async {
    try {
      isLoading.value = true;
      batches.clear();

      final res = await ApiService.getRequest(
        ApiCollection.batchesByCourse(courseId),
      );

      if (res['success'] == "true" && res['indexdata'] != null) {
        batches.assignAll(
          (res['indexdata'] as List)
              .map((e) => BatchModel.fromJson(e))
              .toList(),
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load batches");
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    batches.clear();
  }
}

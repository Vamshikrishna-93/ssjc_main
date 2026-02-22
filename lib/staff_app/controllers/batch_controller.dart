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
      selectedBatch.value = null; // ✅ Reset selection

      final res = await ApiService.getRequest(
        ApiCollection.batchesByCourse(courseId),
      );

      // 🔍 DEBUG LOGS
      print("BATCH API RESPONSE FOR COURSE $courseId: $res");

      final success = res['success'] == true || res['success'] == "true";

      // Look for batches in 'indexdata' or 'data' or 'batches' or 'list'
      final dynamic rawData =
          res['indexdata'] ?? res['data'] ?? res['batches'] ?? res['list'];

      if (success && rawData != null && rawData is List) {
        batches.assignAll(rawData.map((e) => BatchModel.fromJson(e)).toList());
        print("LOADED ${batches.length} BATCHES");
      } else {
        print("NO BATCHES FOUND OR DATA NULL");
      }
    } catch (e) {
      print("BATCH LOADING ERROR: $e");
      Get.snackbar("Error", "Failed to load batches");
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    batches.clear();
    selectedBatch.value = null; // ✅ Reset selection
  }
}

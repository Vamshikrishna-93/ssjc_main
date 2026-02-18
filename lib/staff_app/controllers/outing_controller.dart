import 'package:get/get.dart';
import 'package:student_app/staff_app/api/api_service.dart';
import 'package:student_app/staff_app/model/outing_model.dart';
import 'package:student_app/staff_app/model/OutingInfo.dart';

class OutingController extends GetxController {
  // ================= LOADING =================
  final RxBool isLoading = false.obs;

  // ================= OUTING LIST =================
  final RxList<OutingModel> outingList = <OutingModel>[].obs;
  final RxList<OutingModel> filteredList = <OutingModel>[].obs;

  // ================= FILTER STATES =================
  final RxString selectedBranch = "All".obs;
  final RxString selectedStatus = "All".obs;
  final RxBool isTodayFilter = false.obs;
  final RxString searchQuery = "".obs;

  DateTime? fromDate;
  DateTime? toDate;

  // ================= SUMMARY (TOP CARDS) =================
  final Rx<OutingInfo?> outPassInfo = Rx<OutingInfo?>(null);
  final Rx<OutingInfo?> homePassInfo = Rx<OutingInfo?>(null);
  final Rx<OutingInfo?> selfOutingInfo = Rx<OutingInfo?>(null);
  final Rx<OutingInfo?> selfHomeInfo = Rx<OutingInfo?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchOutings();
  }

  // ================= FETCH OUTINGS =================
  Future<void> fetchOutings({
    String? branch,
    String? reportType,
    String? daybookFilter,
    String? firstDate,
    String? nextDate,
  }) async {
    try {
      isLoading.value = true;

      final Map<String, dynamic> res = await ApiService.getOutingListRaw(
        branch: branch ?? selectedBranch.value,
        reportType: reportType ?? selectedStatus.value,
        daybookFilter: daybookFilter ?? "All",
        firstDate:
            firstDate ??
            (fromDate != null ? fromDate!.toString().substring(0, 10) : ""),
        nextDate:
            nextDate ??
            (toDate != null ? toDate!.toString().substring(0, 10) : ""),
      );

      // ===== LIST DATA =====
      final List listData = res['indexdata'] ?? [];
      final list = listData.map((e) => OutingModel.fromJson(e)).toList();

      outingList.assignAll(list);
      applyFilters(); // Apply search if any

      // ===== SUMMARY DATA =====
      final info = res['outing_info'];
      if (info != null) {
        if (info['outpass']?.isNotEmpty == true) {
          outPassInfo.value = OutingInfo.fromJson(info['outpass'][0]);
        }
        if (info['homepass']?.isNotEmpty == true) {
          homePassInfo.value = OutingInfo.fromJson(info['homepass'][0]);
        }
        if (info['selfouting']?.isNotEmpty == true) {
          selfOutingInfo.value = OutingInfo.fromJson(info['selfouting'][0]);
        }
        if (info['selfhome']?.isNotEmpty == true) {
          selfHomeInfo.value = OutingInfo.fromJson(info['selfhome'][0]);
        }
      }
    } catch (e) {
      print("❌ OutingController error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= APPLY ALL FILTERS (CLIENT SIDE) =================
  void applyFilters() {
    List<OutingModel> temp = outingList.toList();

    // 🔹 SEARCH (Previously we did branch/status/date filter here, but now it's server-side)
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      temp = temp
          .where(
            (o) =>
                o.studentName.toLowerCase().contains(q) ||
                o.admno.toLowerCase().contains(q),
          )
          .toList();
    }

    filteredList.assignAll(temp);
  }

  // ================= FILTER ACTIONS =================
  void search(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void filterToday() {
    isTodayFilter.value = true;
    fromDate = null;
    toDate = null;
    fetchOutings(daybookFilter: "Today");
  }

  void filterByBranch(String branch) {
    selectedBranch.value = branch;
    fetchOutings(branch: branch);
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
    fetchOutings(reportType: status);
  }

  void filterByCustomDate(DateTime from, DateTime to) {
    fromDate = from;
    toDate = to;
    isTodayFilter.value = false;
    fetchOutings(
      daybookFilter: "Custom",
      firstDate: from.toString().substring(0, 10),
      nextDate: to.toString().substring(0, 10),
    );
  }

  // ================= DATE DROPDOWN FILTER =================
  void filterByDate(String type) {
    isTodayFilter.value = false;
    fromDate = null;
    toDate = null;

    switch (type) {
      case "Today":
        filterToday();
        return;

      case "Yesterday":
        fetchOutings(daybookFilter: "Yesterday");
        break;

      case "Last7Days":
        fetchOutings(daybookFilter: "Last7Days");
        break;

      case "ThisMonth":
        fetchOutings(daybookFilter: "ThisMonth");
        break;

      case "LastMonth":
        fetchOutings(daybookFilter: "LastMonth");
        break;

      case "All":
        filterAll();
        return;

      case "Custom":
        // UI will open date picker
        return;
    }
  }

  // ================= RESET =================
  void filterAll() {
    selectedBranch.value = "All";
    selectedStatus.value = "All";
    isTodayFilter.value = false;
    searchQuery.value = "";
    fromDate = null;
    toDate = null;
    fetchOutings(
      branch: "All",
      reportType: "All",
      daybookFilter: "All",
      firstDate: "",
      nextDate: "",
    );
  }

  // ================= COUNTS =================
  int countApproved() =>
      filteredList.where((o) => o.status == "Approved").length;

  int countPending() => filteredList.where((o) => o.status == "Pending").length;

  int countNotReported() =>
      filteredList.where((o) => o.status == "Not Reported").length;
}

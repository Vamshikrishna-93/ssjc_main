import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:student_app/staff_app/controllers/branch_controller.dart';
import 'package:student_app/staff_app/pages/issue_outing.dart';
import 'package:student_app/staff_app/pages/verify_outing_page.dart';
import 'package:student_app/staff_app/controllers/outing_controller.dart';
import 'package:student_app/staff_app/model/outing_model.dart';
import 'package:student_app/staff_app/widgets/skeleton.dart';

class OutingListPage extends StatefulWidget {
  const OutingListPage({super.key});

  @override
  State<OutingListPage> createState() => _OutingListPageState();
}

class _OutingListPageState extends State<OutingListPage> {
  bool showStudents = true;
  TextEditingController searchController = TextEditingController();
  int selectedFilter = 0;

  final BranchController branchController = Get.put(BranchController());
  final OutingController controller = Get.put(OutingController());

  @override
  void initState() {
    super.initState();
    // branchController.loadBranches(); // Removed: OutingController.onInit already calls this
  }

  String selectedStatus = "All";
  String selectedDateFilter = "All";
  DateTime? fromDate;
  DateTime? toDate;

  Widget branchDropdown(bool isDark) {
    return Obx(() {
      if (branchController.isLoading.value) {
        return const SkeletonLoader(width: double.infinity, height: 50);
      }

      return DropdownButtonFormField<String>(
        isExpanded: true,
        initialValue: selectedBranch,
        decoration: InputDecoration(
          filled: true,
          fillColor: isDark ? Colors.white10 : Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
        items: [
          const DropdownMenuItem(value: "All", child: Text("All")),
          ...branchController.branches.map(
            (b) => DropdownMenuItem(
              value: b.id.toString(),
              child: Text(
                b.branchName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            selectedBranch = value!;
            showStudents = false; // Hide old data when filter changes
          });
          controller.updateBranch(value!);
        },
      );
    });
  }

  String selectedBranch = "All";

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0f1c2e) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [const Color(0xFF1a1a2e), const Color(0xFF16213e)]
                  : [const Color(0xFFE0F2FE), const Color(0xFFBAE6FD)],
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Outing list",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0, top: 8, bottom: 8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const IssueOutingPage(studentName: '', outingType: ''),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF4DBE8D),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    Container(width: 1, color: Colors.white.withOpacity(0.2)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF42B883),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Issue Outing",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF1a1a2e),
                    const Color(0xFF16213e),
                    const Color(0xFF0f3460),
                    const Color(0xFF533483),
                  ]
                : [
                    const Color(0xFFE0F2FE),
                    const Color(0xFFBAE6FD),
                    const Color(0xFF7DD3FC),
                    const Color(0xFF38BDF8),
                  ],
            stops: const [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 10),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double itemWidth = (constraints.maxWidth - 12) / 2;
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            // 🔴 OUT PASS
                            SizedBox(
                              width: itemWidth,
                              child: Obx(() {
                                final info = controller.outPassInfo.value;
                                return outingCard(
                                  "Out Pass",
                                  info?.total.toString() ?? "0",
                                  Colors.redAccent,
                                  Icons.exit_to_app_rounded,
                                  isLoading: controller.isLoading.value,
                                  pending: info?.pending ?? 0,
                                  approved: info?.approved ?? 0,
                                  notReported: info?.notReported ?? 0,
                                );
                              }),
                            ),

                            // 🟣 HOME PASS
                            SizedBox(
                              width: itemWidth,
                              child: Obx(() {
                                final info = controller.homePassInfo.value;
                                return outingCard(
                                  "Home Pass",
                                  info?.total.toString() ?? "0",
                                  Colors.deepPurpleAccent,
                                  Icons.home,
                                  isLoading: controller.isLoading.value,
                                  pending: info?.pending ?? 0,
                                  approved: info?.approved ?? 0,
                                  notReported: info?.notReported ?? 0,
                                );
                              }),
                            ),

                            // 🟠 SELF OUTING
                            SizedBox(
                              width: itemWidth,
                              child: Obx(() {
                                final info = controller.selfOutingInfo.value;
                                return outingCard(
                                  "Self Outing",
                                  info?.total.toString() ?? "0",
                                  Colors.orangeAccent,
                                  Icons.exit_to_app,
                                  isLoading: controller.isLoading.value,
                                  pending: info?.pending ?? 0,
                                  approved: info?.approved ?? 0,
                                  notReported: info?.notReported ?? 0,
                                );
                              }),
                            ),

                            // 🟢 SELF HOME
                            SizedBox(
                              width: itemWidth,
                              child: Obx(() {
                                final info = controller.selfHomeInfo.value;
                                return outingCard(
                                  "Self Home",
                                  info?.total.toString() ?? "0",
                                  Colors.teal,
                                  Icons.home,
                                  isLoading: controller.isLoading.value,
                                  pending: info?.pending ?? 0,
                                  approved: info?.approved ?? 0,
                                  notReported: info?.notReported ?? 0,
                                );
                              }),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 25),

                    // FILTER SECTION
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.07)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Filter Options",
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),

                          // ✅ BRANCH DROPDOWN
                          branchDropdown(isDark),
                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            child: DropdownButtonFormField<String>(
                              initialValue: selectedStatus,
                              isExpanded: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: isDark
                                    ? Colors.white10
                                    : Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                              ),
                              items:
                                  const [
                                    "All",
                                    "Pending",
                                    "Approved",
                                    "Not Reported",
                                  ].map((status) {
                                    return DropdownMenuItem<String>(
                                      value: status,
                                      child: Text(status),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  selectedStatus = value;
                                  showStudents = false;
                                });
                                controller.updateStatus(value);
                              },
                            ),
                          ),

                          const SizedBox(height: 12),

                          DropdownButtonFormField<String>(
                            initialValue: selectedDateFilter,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: isDark ? Colors.white10 : Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: "All",
                                child: Text("All"),
                              ),
                              DropdownMenuItem(
                                value: "Today",
                                child: Text("Today"),
                              ),
                              DropdownMenuItem(
                                value: "Yesterday",
                                child: Text("Yesterday"),
                              ),
                              DropdownMenuItem(
                                value: "Last7Days",
                                child: Text("Last 7 Days"),
                              ),
                              DropdownMenuItem(
                                value: "ThisMonth",
                                child: Text("This Month"),
                              ),
                              DropdownMenuItem(
                                value: "LastMonth",
                                child: Text("Last Month"),
                              ),
                              DropdownMenuItem(
                                value: "Custom",
                                child: Text("Custom"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedDateFilter = value!;
                                showStudents = false;
                              });
                              controller.updateDateFilter(value!);
                            },
                          ),
                          if (selectedDateFilter == "Custom") ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      fromDate = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime.now(),
                                        initialDate: DateTime.now(),
                                      );
                                    },
                                    child: Text(
                                      fromDate == null
                                          ? "From Date"
                                          : fromDate!.toString().substring(
                                              0,
                                              10,
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      toDate = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime.now(),
                                        initialDate: DateTime.now(),
                                      );
                                    },
                                    child: Text(
                                      toDate == null
                                          ? "To Date"
                                          : toDate!.toString().substring(0, 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (fromDate != null && toDate != null) {
                                  controller.updateCustomDates(
                                    fromDate!,
                                    toDate!,
                                  );
                                }
                              },
                              child: const Text("Apply Date Filter"),
                            ),
                          ],

                          const SizedBox(height: 18),

                          // SEARCH BAR
                          Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white10 : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white24
                                    : Colors.grey.shade400,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: isDark ? Colors.white70 : Colors.grey,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: searchController,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Search students...",
                                      hintStyle: TextStyle(
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.grey,
                                      ),
                                    ),
                                    onChanged: controller.search,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // FILTER BUTTON
                    GestureDetector(
                      onTap: () {
                        setState(() => showStudents = true);
                        controller.fetchOutings();
                      },
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(27),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: 70,
                              decoration: const BoxDecoration(
                                color: Color(0xFF8B98E8),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(27),
                                  bottomLeft: Radius.circular(27),
                                ),
                              ),
                              child: const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            Container(
                              width: 1.5,
                              color: Colors.white.withOpacity(0.3),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF7B88D8),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(27),
                                    bottomRight: Radius.circular(27),
                                  ),
                                ),
                                child: const Text(
                                  "Filter Students",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),
                  ]),
                ),
              ),

              // STUDENT LIST (API DATA)
              if (showStudents)
                Obx(() {
                  if (controller.isLoading.value) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: SkeletonList(itemCount: 5),
                      ),
                    );
                  }

                  if (controller.filteredList.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            "No outing records found",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final o = controller.filteredList[index];
                        return _buildOutingItem(o);
                      }, childCount: controller.filteredList.length),
                    ),
                  );
                }),
              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutingItem(OutingModel o) {
    return InkWell(
      onTap: () async {
        final result = await Get.to(
          () => VerifyOutingPage(
            key: ValueKey(o.id),
            adm: o.admno,
            name: o.studentName,
            status: o.status,
            outingId: o.id,
          ),
        );
        if (result == true) {
          controller.fetchOutings();
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF193C68), Color(0xFF462A78)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          o.studentName.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          o.admno,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: o.status == "Approved"
                                ? Colors.green
                                : Colors.orange,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          o.status,
                          style: TextStyle(
                            color: o.status == "Approved"
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        o.outingType,
                        style: const TextStyle(
                          color: Color(0xFF4DB6FF),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (o.purpose.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.white60,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Purpose: ",
                      style: TextStyle(color: Colors.white60, fontSize: 16),
                    ),
                    Expanded(
                      child: Text(
                        o.purpose,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              if (o.permission.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      color: Colors.white60,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Permission By: ",
                      style: TextStyle(color: Colors.white60, fontSize: 16),
                    ),
                    Expanded(
                      child: Text(
                        o.permission,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  const Icon(
                    Icons.access_time_outlined,
                    color: Colors.white60,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "${o.outDate} • ${o.outingTime}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              const Divider(color: Colors.white10, height: 32, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _actionIcon(
                    Icons.flag,
                    Colors.redAccent,
                    "Report",
                    () => _showRemarksDialog(context, o.id),
                  ),
                  const SizedBox(width: 12),
                  _actionIcon(
                    Icons.edit,
                    Colors.orangeAccent,
                    "Edit",
                    () => _showRemarksDialog(context, o.id),
                  ),
                  const SizedBox(width: 12),
                  _actionIcon(
                    Icons.delete,
                    Colors.redAccent,
                    "Delete",
                    () => _showDeleteConfirmationDialog(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget outingCard(
    String title,
    String count,
    Color color,
    IconData icon, {
    bool isLoading = false,
    required int pending,
    required int approved,
    required int notReported,
  }) {
    if (isLoading) {
      return SkeletonLoader(
        width: double.infinity,
        height: 180,
        borderRadius: 18,
      );
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.85), color.withOpacity(0.6)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.white)),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Pending: $pending",
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            "Approved: $approved",
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            "Not Reported: $notReported",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _actionIcon(
    IconData icon,
    Color color,
    String tooltip,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: color, size: 24),
        ),
      ),
    );
  }

  void _showRemarksDialog(BuildContext context, int outingId) {
    final TextEditingController remarksController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titlePadding: EdgeInsets.zero,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey, size: 30),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(height: 1),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Remarks *",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF5E6A81),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: remarksController,
              maxLines: 6,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12, right: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B88D8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () async {
                if (remarksController.text.trim().isEmpty) {
                  Get.snackbar(
                    "Error",
                    "Please enter remarks",
                    backgroundColor: Colors.orange,
                  );
                  return;
                }
                final success = await controller.addOutingRemarks(
                  outingId,
                  remarksController.text.trim(),
                );
                if (success) {
                  Navigator.pop(ctx);
                }
              },
              child: Obx(
                () => controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Update Remarks",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titlePadding: EdgeInsets.zero,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey, size: 30),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFD1A7), width: 3),
              ),
              child: const Icon(
                Icons.priority_high,
                color: Color(0xFFFFCC33),
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Are you sure? You want to delete this Outing",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4A4A),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "You won't be able to revert this!",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B88D8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    elevation: 4,
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    "Yes, Delete it!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6666),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    elevation: 4,
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

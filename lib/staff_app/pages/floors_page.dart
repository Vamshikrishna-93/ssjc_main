import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/search_field.dart';
import '../controllers/branch_controller.dart';
import '../model/branch_model.dart';

class FloorsPage extends StatefulWidget {
  const FloorsPage({super.key});

  @override
  State<FloorsPage> createState() => _FloorsPageState();
}

class _FloorsPageState extends State<FloorsPage> {
  String _query = '';

  // ---------------- DARK COLORS ----------------
  static const Color dark1 = Color(0xFF1a1a2e);
  static const Color dark2 = Color(0xFF16213e);
  static const Color dark3 = Color(0xFF0f3460);
  static const Color purpleDark = Color(0xFF533483);
  static const Color neon = Color(0xFF00FFF5);

  // ---------------- CONTROLLER ----------------
  final BranchController branchCtrl = Get.put(BranchController());

  int? selectedBranchId;
  String selectedBranchName = "";

  final List<Map<String, String>> _floors = [
    {'floor': 'GROUND FLOOR', 'hostel': 'SSG EAMCET CAMPUS'},
    {'floor': 'FIRST FLOOR', 'hostel': 'SSG EAMCET CAMPUS'},
    {'floor': 'SECOND FLOOR', 'hostel': 'SSG NEET & MAINS'},
  ];

  @override
  void initState() {
    super.initState();
    branchCtrl.loadBranches();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _floors.where((f) {
      return f['floor']!.toLowerCase().contains(_query.toLowerCase()) ||
          f['hostel']!.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
            size: 26,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Floors List",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ================= BODY =================
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [dark1, dark2, dark3, purpleDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).colorScheme.surface,
                  ],
                ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 95),

            // ================= SEARCH =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.12)
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? Colors.white24
                        : Theme.of(context).dividerColor,
                  ),
                ),
                child: SearchField(
                  hint: 'Search floor / hostel',
                  hintStyle: TextStyle(
                    color: isDark ? const Color(0xFFB5C7E8) : Colors.black54,
                  ),
                  textColor: isDark ? Colors.white : Colors.black,
                  iconColor: isDark ? neon : Colors.black54,
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ================= BRANCH DROPDOWN =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                if (branchCtrl.isLoading.value) {
                  return const CircularProgressIndicator();
                }

                if (branchCtrl.branches.isEmpty) {
                  return Text(
                    "No branches available",
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  );
                }

                return DropdownButtonFormField<int>(
                  value: selectedBranchId,
                  dropdownColor: isDark ? dark1 : Theme.of(context).cardColor,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withOpacity(0.12)
                        : Theme.of(context).cardColor,
                    hintText: "Select Branch",
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  items: branchCtrl.branches
                      .map<DropdownMenuItem<int>>((BranchModel b) {
                    return DropdownMenuItem<int>(
                      value: b.id,
                      child: Text(b.branchName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBranchId = value;
                      final selected =
                          branchCtrl.branches.firstWhere((b) => b.id == value);
                      selectedBranchName = selected.branchName;
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: 15),

            // ================= FLOORS LIST =================
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  final item = filtered[i];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? LinearGradient(
                              colors: [
                                dark3.withOpacity(0.45),
                                purpleDark.withOpacity(0.45),
                              ],
                            )
                          : LinearGradient(
                              colors: [
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.08),
                                Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.08),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark
                            ? neon.withOpacity(0.32)
                            : Theme.of(context).dividerColor,
                        width: 1.3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              isDark ? neon.withOpacity(0.18) : Colors.black12,
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['floor']!,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Hostel: ${item['hostel']}",
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? const Color(0xFFB5C7E8)
                                : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Branch: ${selectedBranchName.isEmpty ? 'All Branches' : selectedBranchName}",
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? const Color(0xFFB5C7E8)
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ================= FAB =================
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: isDark ? neon : Theme.of(context).colorScheme.primary,
        icon: Icon(Icons.add, color: isDark ? Colors.black : Colors.white),
        label: Text(
          "Add Floor",
          style: TextStyle(
            color: isDark ? Colors.black : Colors.white,
          ),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Add Floor (Dummy Action)")),
          );
        },
      ),
    );
  }
}

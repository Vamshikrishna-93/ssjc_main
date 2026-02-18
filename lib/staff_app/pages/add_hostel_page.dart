import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/api_service.dart';
import '../controllers/branch_controller.dart';
import '../controllers/staff_controller.dart';
import '../controllers/hostel_controller.dart';

class AddHostelPage extends StatefulWidget {
  const AddHostelPage({super.key});

  @override
  State<AddHostelPage> createState() => _AddHostelPageState();
}

class _AddHostelPageState extends State<AddHostelPage> {
  final _formKey = GlobalKey<FormState>();

  final BranchController branchCtrl = Get.put(BranchController());
  final StaffController staffCtrl = Get.put(StaffController());
  final HostelController hostelCtrl = Get.put(HostelController());

  final TextEditingController _buildingCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();

  final RxnString _category = RxnString();
  final RxnInt _selectedInchargeId = RxnInt();
  final RxnInt _selectedBranchId = RxnInt();
  final RxnString _status = RxnString();
  final RxBool _isSaving = false.obs;

  // ---------------- COLORS ----------------
  static const Color dark1 = Color(0xFF1a1a2e);
  static const Color dark2 = Color(0xFF16213e);
  static const Color dark3 = Color(0xFF0f3460);
  static const Color purpleDark = Color(0xFF533483);
  static const Color neon = Color(0xFF00FFF5);

  final Map<String, IconData> genderIcons = {
    "Boys": Icons.male,
    "Girls": Icons.female,
  };

  final Map<String, IconData> branchIcons = {
    "EAMCET": Icons.engineering,
    "NEET": Icons.local_hospital,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          "Add Hostel",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ================= BODY =================
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [dark1, dark2, dark3, purpleDark],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // ================= FORM CARD =================
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: isDark ? neon : Theme.of(context).dividerColor,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? neon.withOpacity(0.35) : Colors.black12,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _inputField(
                          context,
                          label: "Building Name *",
                          controller: _buildingCtrl,
                          icon: Icons.home_work,
                        ),
                        const SizedBox(height: 20),

                        Obx(
                          () => _dropdownField(
                            context,
                            label: "Category",
                            value: _category.value,
                            icon: Icons.home,
                            items: const ["BOYS HOSTEL", "GIRLS HOSTEL"],
                            innerIcons: {
                              "BOYS HOSTEL": Icons.male,
                              "GIRLS HOSTEL": Icons.female,
                            },
                            onChanged: (v) => _category.value = v,
                          ),
                        ),
                        const SizedBox(height: 20),

                        _inputField(
                          context,
                          label: "Address *",
                          controller: _addressCtrl,
                          icon: Icons.location_on,
                        ),
                        const SizedBox(height: 20),

                        Obx(
                          () => _dropdownField(
                            context,
                            label: "Incharge *",
                            value:
                                staffCtrl.staffList.firstWhereOrNull(
                                      (s) => s.id == _selectedInchargeId.value,
                                    ) !=
                                    null
                                ? "${staffCtrl.staffList.firstWhere((s) => s.id == _selectedInchargeId.value).designation} (${_selectedInchargeId.value})"
                                : null,
                            icon: Icons.person,
                            items: staffCtrl.staffList
                                .map((s) => "${s.designation} (${s.id})")
                                .toList(),
                            onChanged: (v) {
                              if (v != null) {
                                final idMatch = RegExp(
                                  r'\((\d+)\)$',
                                ).firstMatch(v);
                                if (idMatch != null) {
                                  _selectedInchargeId.value = int.parse(
                                    idMatch.group(1)!,
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        Obx(
                          () => _dropdownField(
                            context,
                            label: "Branch *",
                            value: branchCtrl.branches
                                .firstWhereOrNull(
                                  (b) => b.id == _selectedBranchId.value,
                                )
                                ?.branchName,
                            icon: Icons.account_tree,
                            items: branchCtrl.branches
                                .map((b) => b.branchName)
                                .toList(),
                            innerIcons: branchIcons,
                            onChanged: (v) {
                              final b = branchCtrl.branches.firstWhereOrNull(
                                (b) => b.branchName == v,
                              );
                              _selectedBranchId.value = b?.id;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        Obx(
                          () => _dropdownField(
                            context,
                            label: "Status",
                            value: _status.value,
                            icon: Icons.toggle_on,
                            items: const ["Active", "Inactive"],
                            onChanged: (v) => _status.value = v,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // ================= SUBMIT BUTTON =================
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.check_circle),
                              label: _isSaving.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    )
                                  : const Text(
                                      "Add Hostel",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: neon,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                elevation: 15,
                              ),
                              onPressed: _isSaving.value ? null : _submit,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_category.value == null ||
        _selectedInchargeId.value == null ||
        _selectedBranchId.value == null ||
        _status.value == null) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      _isSaving.value = true;

      await ApiService.saveHostelBuilding(
        buildingName: _buildingCtrl.text,
        category: _category.value!,
        address: _addressCtrl.text,
        inchargeId: _selectedInchargeId.value!,
        branchId: _selectedBranchId.value!,
        status: _status.value == "Active" ? 1 : 0,
      );

      Get.snackbar(
        "Success",
        "Hostel building added successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Refresh hostel list and go back
      hostelCtrl.loadHostelsByBranch(_selectedBranchId.value!);
      Get.back();
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      _isSaving.value = false;
    }
  }

  // ================= INPUT FIELD =================
  Widget _inputField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.06)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white24 : Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: neon, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color: isDark ? const Color(0xFFB5C7E8) : Colors.black54,
                  fontSize: 14,
                ),
                border: InputBorder.none,
              ),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
          ),
        ],
      ),
    );
  }

  // ================= DROPDOWN FIELD =================
  Widget _dropdownField(
    BuildContext context, {
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
    Map<String, IconData>? innerIcons,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.06)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white24 : Theme.of(context).dividerColor,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: value,
          dropdownColor: isDark ? dark3 : Theme.of(context).cardColor,
          decoration: const InputDecoration(border: InputBorder.none),
          icon: const Icon(Icons.arrow_drop_down, color: neon),
          hint: Text(
            label,
            style: TextStyle(
              color: isDark ? const Color(0xFFB5C7E8) : Colors.black54,
              fontSize: 14,
            ),
          ),
          selectedItemBuilder: (context) {
            return items.map((e) {
              return Row(
                children: [
                  Icon(innerIcons?[e] ?? icon, color: neon, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      e,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }).toList();
          },
          items: items.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Row(
                children: [
                  Icon(innerIcons?[e] ?? icon, color: neon, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      e,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

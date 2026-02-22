import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:student_app/staff_app/controllers/hostel_controller.dart';
import '../controllers/branch_controller.dart';
import '../widgets/skeleton.dart';

import 'hostel_attendance_status_page.dart';

class HostelAttendanceFilterPage extends StatefulWidget {
  const HostelAttendanceFilterPage({super.key});

  @override
  State<HostelAttendanceFilterPage> createState() =>
      _HostelAttendanceFilterPageState();
}

class _HostelAttendanceFilterPageState
    extends State<HostelAttendanceFilterPage> {
  String? _branch;
  String? _hostel;
  String? _floor;
  String? _room;
  DateTime _selectedDate = DateTime.now();

  final BranchController branchCtrl = Get.put(BranchController());
  final HostelController hostelCtrl = Get.put(HostelController());

  // DARK COLORS
  static const Color dark1 = Color(0xFF1a1a2e);
  static const Color dark2 = Color(0xFF16213e);
  static const Color dark3 = Color(0xFF0f3460);
  static const Color purpleDark = Color(0xFF533483);
  static const Color neon = Color(0xFF00FFF5);

  @override
  void initState() {
    super.initState();
    // 1️⃣ Load branches
    branchCtrl.loadBranches();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF16213e),

        // ---------------- APP BAR ----------------
        appBar: AppBar(
          backgroundColor: isDark
              ? Colors.black.withOpacity(0.4)
              : Colors.white.withOpacity(0.9),
          elevation: 0,
          title: Text(
            "View Hostel Attendance",
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        // ---------------- BODY ----------------
        body: Container(
          width: double.infinity,
          height: double.infinity,
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
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                  ),
          ),

          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              16,
              kToolbarHeight + MediaQuery.of(context).padding.top + 16,
              16,
              32 + MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              children: [
                // BRANCH
                Obx(
                  () => branchCtrl.isLoading.value
                      ? const SkeletonLoader(width: double.infinity, height: 60)
                      : _neonDropdown(
                          context,
                          label: "Select Branch",
                          icon: Icons.school,
                          iconColor: neon,
                          value: _branch,
                          items: branchCtrl.branches
                              .map((b) => b.branchName)
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              _branch = v;
                              _hostel = _floor = _room = null;
                            });

                            final branchObj = branchCtrl.branches.firstWhere(
                              (b) => b.branchName == v,
                            );
                            hostelCtrl.loadHostelsByBranch(branchObj.id);
                          },
                        ),
                ),
                const SizedBox(height: 14),

                // HOSTEL
                Obx(
                  () => hostelCtrl.isLoading.value && _branch != null
                      ? const SkeletonLoader(width: double.infinity, height: 60)
                      : _neonDropdown(
                          context,
                          label: "Select Hostel",
                          icon: Icons.apartment,
                          iconColor: Colors.purpleAccent,
                          value: _hostel,
                          items: hostelCtrl.hostels
                              .map((h) => h.buildingName)
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              _hostel = v;
                              _floor = _room = null;
                            });

                            final h = hostelCtrl.hostels.firstWhere(
                              (h) => h.buildingName == v,
                            );
                            hostelCtrl.selectedHostel.value = h;
                            hostelCtrl.loadFloorsAndRooms(h.id);
                          },
                        ),
                ),
                const SizedBox(height: 14),

                // FLOOR
                Obx(
                  () => hostelCtrl.isLoading.value && _hostel != null
                      ? const SkeletonLoader(width: double.infinity, height: 60)
                      : _neonDropdown(
                          context,
                          label: "Select Floor",
                          icon: Icons.layers,
                          iconColor: Colors.blueAccent,
                          value: _floor,
                          items: hostelCtrl.floors,
                          onChanged: (v) {
                            setState(() {
                              _floor = v;
                              _room = null;
                            });
                            if (v != null) {
                              hostelCtrl.filterRoomsByFloor(v);
                            }
                          },
                        ),
                ),
                const SizedBox(height: 14),

                // ROOM
                Obx(
                  () => hostelCtrl.isLoading.value && _floor != null
                      ? const SkeletonLoader(width: double.infinity, height: 60)
                      : _neonDropdown(
                          context,
                          label: "Select Room",
                          icon: Icons.meeting_room,
                          iconColor: Colors.pinkAccent,
                          value: _room,
                          items: hostelCtrl.rooms,
                          onChanged: (v) => setState(() => _room = v),
                        ),
                ),
                const SizedBox(height: 14),

                // DATE
                _neonDatePicker(
                  context,
                  label: "Select Date",
                  icon: Icons.event,
                  iconColor: Colors.lightBlueAccent,
                  value: _selectedDate,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                ),
                const SizedBox(height: 14),
                const SizedBox(height: 24),

                // GET STUDENTS BUTTON
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? Colors.cyanAccent
                            : Theme.of(context).primaryColor,
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: hostelCtrl.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Icon(Icons.search),
                      label: Text(
                        hostelCtrl.isLoading.value
                            ? "Loading..."
                            : "Get Students",
                      ),
                      onPressed: hostelCtrl.isLoading.value
                          ? null
                          : () async {
                              if (_branch == null || _hostel == null) {
                                Get.snackbar(
                                  "Warning",
                                  "Select Branch and Hostel",
                                );
                                return;
                              }

                              final branchObj = branchCtrl.branches.firstWhere(
                                (b) => b.branchName == _branch,
                              );
                              final hostelObj = hostelCtrl.hostels.firstWhere(
                                (h) => h.buildingName == _hostel,
                              );

                              await hostelCtrl.loadRoomAttendanceSummary(
                                branch: branchObj.id.toString(),
                                date: _selectedDate.toIso8601String().split(
                                  'T',
                                )[0],
                                hostel: hostelObj.id.toString(),
                                floor: _floor ?? 'All',
                                room: _room ?? 'All',
                              );

                              Get.toNamed('/hostelAttendanceResult');
                            },
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _neonButton(
                        label: "Add Attendance",
                        icon: Icons.add,
                        color: Colors.greenAccent,
                        onTap: () {
                          if (_branch == null ||
                              _hostel == null ||
                              _floor == null ||
                              _room == null) {
                            Get.snackbar("Error", "Please select all filters");
                            return;
                          }
                          // Navigate to Add Hostel Attendance Page
                          Get.toNamed(
                            '/addHostelAttendance',
                            arguments: {
                              'branch': _branch,
                              'hostel': _hostel,
                              'floor': _floor,
                              'room': _room,
                              'date': _selectedDate.toIso8601String().split(
                                'T',
                              )[0],
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _neonButton(
                        label: "Check Status",
                        icon: Icons.check_circle,
                        color: Colors.blueAccent,
                        onTap: () async {
                          if (_branch == null || _hostel == null) {
                            Get.snackbar(
                              "Warning",
                              "Select Branch and Hostel",
                              backgroundColor: Colors.orange,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          final branchObj = branchCtrl.branches.firstWhere(
                            (b) => b.branchName == _branch!,
                          );
                          final hostelObj = hostelCtrl.hostels.firstWhere(
                            (h) => h.buildingName == _hostel!,
                          );

                          await hostelCtrl.loadRoomAttendanceSummary(
                            branch: branchObj.id.toString(),
                            date: _selectedDate.toIso8601String().split('T')[0],
                            hostel: hostelObj.id.toString(),
                            floor: _floor ?? 'All',
                            room: _room ?? 'All',
                          );

                          Get.to(() => const HostelAttendanceStatusPage());
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- DATE PICKER ----------------
  Widget _neonDatePicker(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color iconColor,
    required DateTime value,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white24 : Theme.of(context).dividerColor,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${value.day}/${value.month}/${value.year}",
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.calendar_today, size: 18, color: neon.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }

  // ---------------- DROPDOWN ----------------
  Widget _neonDropdown(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color iconColor,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white24 : Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: (value != null && items.contains(value)) ? value : null,
              dropdownColor: isDark ? dark2 : Theme.of(context).cardColor,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              iconEnabledColor: neon,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                border: InputBorder.none,
              ),
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- BUTTON ----------------
  Widget _neonButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        onPressed: onTap,
      ),
    );
  }
}

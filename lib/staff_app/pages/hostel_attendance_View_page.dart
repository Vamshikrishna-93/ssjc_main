import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/branch_controller.dart';
import '../model/branch_model.dart';

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
  String _month = 'Nov';

  final BranchController branchCtrl = Get.put(BranchController());
  List<DropdownMenuItem<String>> branchItems = [];

  // DARK COLORS
  static const Color dark1 = Color(0xFF1a1a2e);
  static const Color dark2 = Color(0xFF16213e);
  static const Color dark3 = Color(0xFF0f3460);
  static const Color purpleDark = Color(0xFF533483);
  static const Color neon = Color(0xFF00FFF5);

  @override
  void initState() {
    super.initState();

    branchCtrl.loadBranches();

    ever(branchCtrl.branches, (_) {
      branchItems = branchCtrl.branches
          .map(
            (BranchModel b) => DropdownMenuItem(
              value: b.branchName,
              child: Text(b.branchName),
            ),
          )
          .toList();

      if (branchItems.isNotEmpty && _branch == null) {
        _branch = branchItems.first.value;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: Colors.transparent, // ✅ FIX
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false, // ✅ FIX
        backgroundColor: Color(0xFF16213e),

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
          height: double.infinity, // ✅ ENSURES FULL PAINT
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
              kToolbarHeight +
                  MediaQuery.of(context).padding.top +
                  16, // ✅ FIXED
              16,
              32 + MediaQuery.of(context).padding.bottom, // ✅ BOTTOM FIX
            ),
            child: Column(
              children: [
                _neonDropdown(
                  context,
                  label: "Select Branch",
                  icon: Icons.school,
                  iconColor: neon,
                  value: _branch,
                  items: branchItems,
                  onChanged: (v) => setState(() => _branch = v),
                ),
                const SizedBox(height: 14),
                _neonDropdown(
                  context,
                  label: "Select Hostel",
                  icon: Icons.apartment,
                  iconColor: Colors.purpleAccent,
                  value: _hostel,
                  items: const [
                    DropdownMenuItem(value: 'ADARSA', child: Text('ADARSA')),
                    DropdownMenuItem(value: 'VIDHYA', child: Text('VIDHYA')),
                  ],
                  onChanged: (v) => setState(() => _hostel = v),
                ),
                const SizedBox(height: 14),
                _neonDropdown(
                  context,
                  label: "Select Floor",
                  icon: Icons.layers,
                  iconColor: Colors.blueAccent,
                  value: _floor,
                  items: const [
                    DropdownMenuItem(value: '1', child: Text('First Floor')),
                    DropdownMenuItem(value: '2', child: Text('Second Floor')),
                  ],
                  onChanged: (v) => setState(() => _floor = v),
                ),
                const SizedBox(height: 14),
                _neonDropdown(
                  context,
                  label: "Select Room",
                  icon: Icons.meeting_room,
                  iconColor: Colors.pinkAccent,
                  value: _room,
                  items: const [
                    DropdownMenuItem(value: 'C-201', child: Text('C-201')),
                    DropdownMenuItem(value: 'C-202', child: Text('C-202')),
                    DropdownMenuItem(value: 'C-203', child: Text('C-203')),
                  ],
                  onChanged: (v) => setState(() => _room = v),
                ),
                const SizedBox(height: 14),
                _neonDropdown(
                  context,
                  label: "Select Month",
                  icon: Icons.calendar_month,
                  iconColor: Colors.orangeAccent,
                  value: _month,
                  items: const [
                    DropdownMenuItem(value: 'Jan', child: Text('January')),
                    DropdownMenuItem(value: 'Feb', child: Text('February')),
                    DropdownMenuItem(value: 'Mar', child: Text('March')),
                    DropdownMenuItem(value: 'Apr', child: Text('April')),
                    DropdownMenuItem(value: 'May', child: Text('May')),
                    DropdownMenuItem(value: 'Jun', child: Text('June')),
                    DropdownMenuItem(value: 'Jul', child: Text('July')),
                    DropdownMenuItem(value: 'Aug', child: Text('August')),
                    DropdownMenuItem(value: 'Sep', child: Text('September')),
                    DropdownMenuItem(value: 'Oct', child: Text('October')),
                    DropdownMenuItem(value: 'Nov', child: Text('November')),
                    DropdownMenuItem(value: 'Dec', child: Text('December')),
                  ],
                  onChanged: (v) => setState(() => _month = v!),
                ),
                const SizedBox(height: 24),
                SizedBox(
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
                    icon: const Icon(Icons.search),
                    label: const Text("Get Students"),
                    onPressed: () => Get.toNamed('/hostelAttendanceResult'),
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
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _neonButton(
                        label: "Check Status",
                        icon: Icons.check_circle,
                        color: Colors.blueAccent,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
    required List<DropdownMenuItem<String>> items,
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
              value: value,
              dropdownColor: isDark ? dark2 : Theme.of(context).cardColor,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
              iconEnabledColor: neon,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                border: InputBorder.none,
              ),
              items: items,
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
        label: Text(label),
        onPressed: onTap,
      ),
    );
  }
}

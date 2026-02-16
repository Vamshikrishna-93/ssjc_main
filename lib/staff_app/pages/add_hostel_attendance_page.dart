import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:student_app/staff_app/controllers/hostel_controller.dart';

class AddHostelAttendancePage extends StatefulWidget {
  final String? branch;
  final String? hostel;
  final String? floor;
  final String? room;
  final String? month;

  const AddHostelAttendancePage({
    super.key,
    this.branch,
    this.hostel,
    this.floor,
    this.room,
    this.month,
  });

  @override
  State<AddHostelAttendancePage> createState() =>
      _AddHostelAttendancePageState();
}

class _AddHostelAttendancePageState extends State<AddHostelAttendancePage> {
  final HostelController hostelCtrl = Get.find<HostelController>();

  // Mock student data - replace with actual API data
  final List<Map<String, dynamic>> students = [];
  final Map<int, String> attendanceStatus = {};

  bool isLoading = false;
  String selectedDate = DateTime.now().toIso8601String().split('T')[0];

  // Attendance status options
  final List<String> statusOptions = [
    'Present',
    'Missing',
    'Outing',
    'Home Pass',
    'Self Outing',
    'Self Home',
  ];

  // DARK COLORS (matching dashboard)
  static const Color dark1 = Color(0xFF1a1a2e);
  static const Color dark2 = Color(0xFF16213e);
  static const Color dark3 = Color(0xFF0f3460);
  static const Color purpleDark = Color(0xFF533483);

  @override
  void initState() {
    super.initState();
    // Initialize all students as 'Present' by default
    for (int i = 0; i < students.length; i++) {
      attendanceStatus[i] = 'Present';
    }
  }

  Future<void> _getStudents() async {
    setState(() => isLoading = true);

    // TODO: Replace with actual API call
    // For now, adding mock data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      students.clear();
      students.addAll([
        {
          'admissionNo': '251170',
          'name': 'NAGAM GHANA ESWAR',
          'phone': '9876543210',
        },
        {
          'admissionNo': '251935',
          'name': 'ANNAM JOSH SRIDHAR MANIKANTA REDDY',
          'phone': '9876543211',
        },
        {
          'admissionNo': '251936',
          'name': 'GADE SRI ABHIJITH REDDY',
          'phone': '9876543212',
        },
        {
          'admissionNo': '252126',
          'name': 'PODILI CHARAN',
          'phone': '9876543213',
        },
        {
          'admissionNo': '252349',
          'name': 'ELICHERLA STEEIEN ARYA',
          'phone': '9876543214',
        },
        {
          'admissionNo': '252983',
          'name': 'BANDARU SHESHI KIRAN',
          'phone': '9876543215',
        },
      ]);

      // Initialize attendance status for new students
      for (int i = 0; i < students.length; i++) {
        attendanceStatus[i] = 'Present';
      }

      isLoading = false;
    });
  }

  Future<void> _submitAttendance() async {
    // TODO: Implement API call to submit attendance
    Get.snackbar(
      'Success',
      'Attendance submitted successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
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
            "Add Hostel Attendance",
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
                : const LinearGradient(
                    colors: [Color(0xFFF5F6FA), Color(0xFFE8ECF4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Filter Summary Cards
                _buildFilterSummary(isDark),

                // Get Students Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? Colors.cyanAccent
                            : const Color(0xFF533483),
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: isLoading
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
                        isLoading ? "Loading..." : "Get Students",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: isLoading ? null : _getStudents,
                    ),
                  ),
                ),

                // Student List
                Expanded(
                  child: students.isEmpty
                      ? Center(
                          child: Text(
                            'Click "Get Students" to load student list',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : _buildStudentTable(isDark),
                ),

                // Submit Button
                if (students.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _submitAttendance,
                        child: const Text(
                          'Submit Attendance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  Widget _buildFilterSummary(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _filterChip(isDark, 'Branch', widget.branch ?? 'Not Selected'),
              _filterChip(isDark, 'Hostel', widget.hostel ?? 'Not Selected'),
              _filterChip(isDark, 'Floor', widget.floor ?? 'Not Selected'),
              _filterChip(isDark, 'Room', widget.room ?? 'Not Selected'),
              _filterChip(isDark, 'Date', selectedDate),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterChip(bool isDark, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16213e) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.cyanAccent : const Color(0xFF533483),
        ),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildStudentTable(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            // Table Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF16213e) : Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Text(
                      'S No.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Attendance Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Admission No.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Student Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Phone Number',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Table Rows
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? Colors.white12 : Colors.grey.shade200,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: attendanceStatus[index],
                            isExpanded: true,
                            underline: const SizedBox(),
                            dropdownColor: isDark ? dark2 : Colors.white,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 12,
                            ),
                            items: statusOptions.map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                attendanceStatus[index] = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          student['admissionNo'],
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () {
                            // TODO: Navigate to student details
                          },
                          child: Text(
                            student['name'],
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          student['phone'] ?? '',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

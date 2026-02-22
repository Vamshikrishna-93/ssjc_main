import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/monthly_attendance_controller.dart';

class StudentMonthAttendancePage extends StatelessWidget {
  final String monthName;
  final int year;

  StudentMonthAttendancePage({
    super.key,
    required this.monthName,
    required this.year,
    required String studentName,
    required String admNo,
  });

  final MonthlyAttendanceController attendanceCtrl =
      Get.find<MonthlyAttendanceController>();

  // ================= MONTH MAP =================
  static const Map<String, String> monthMap = {
    "January": "01",
    "February": "02",
    "March": "03",
    "April": "04",
    "May": "05",
    "June": "06",
    "July": "07",
    "August": "08",
    "September": "09",
    "October": "10",
    "November": "11",
    "December": "12",
  };

  // ================= DAYS IN MONTH =================
  int getDaysInMonth(String monthName, int year) {
    final monthNumber = int.parse(monthMap[monthName]!);

    if (monthNumber == 2) {
      final isLeapYear =
          (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }

    if ([4, 6, 9, 11].contains(monthNumber)) {
      return 30;
    }

    return 31;
  }

  final List<String> dayKeys = [
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "ten",
    "oneone",
    "onetwo",
    "onethree",
    "onefour",
    "onefive",
    "onesix",
    "oneseven",
    "oneeight",
    "onenine",
    "twozero",
    "twoone",
    "twotwo",
    "twothree",
    "twofour",
    "twofive",
    "twosix",
    "twoseven",
    "twoeight",
    "twonine",
    "threezero",
    "threeone",
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Student Attendance ($year)"),
        centerTitle: true,
        foregroundColor: isDark ? Colors.white : Colors.black,
        backgroundColor: isDark ? const Color(0xFF0b132b) : Colors.white,
        elevation: 0,
      ),
      backgroundColor: isDark ? const Color(0xFF0b132b) : Colors.white,
      body: Obx(() {
        if (attendanceCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (attendanceCtrl.attendanceList.isEmpty) {
          return const Center(child: Text("No data found"));
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _attendanceTable(isDark),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ================= TABLE =================
  Widget _attendanceTable(bool isDark) {
    final borderColor = isDark
        ? Colors.white.withOpacity(0.15)
        : Colors.grey.shade300;
    final textColor = isDark ? Colors.white : Colors.black;
    final headerColor = isDark ? const Color(0xFF1b2f5b) : Colors.grey.shade200;
    final cellColor = isDark ? const Color(0xFF2e2a63) : Colors.white;

    final totalDays = getDaysInMonth(monthName, year);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HEADER =================
          Row(
            children: [
              _cell(
                "S No",
                50,
                headerColor,
                textColor,
                borderColor,
                isHeader: true,
              ),
              _cell(
                "Adm No",
                80,
                headerColor,
                textColor,
                borderColor,
                isHeader: true,
              ),
              _cell(
                "Name",
                150,
                headerColor,
                textColor,
                borderColor,
                isHeader: true,
              ),
              ...List.generate(totalDays, (index) {
                return _cell(
                  "${index + 1}",
                  40,
                  headerColor,
                  textColor,
                  borderColor,
                  isHeader: true,
                );
              }),
            ],
          ),

          // ================= BODY =================
          ...List.generate(attendanceCtrl.attendanceList.length, (index) {
            final student = attendanceCtrl.attendanceList[index];
            final String fullName =
                "${student['sfname'] ?? ''} ${student['slname'] ?? ''}".trim();

            return Row(
              children: [
                _cell("${index + 1}", 50, cellColor, textColor, borderColor),
                _cell(
                  "${student['admno'] ?? ''}",
                  80,
                  cellColor,
                  textColor,
                  borderColor,
                ),
                _cell(
                  fullName,
                  150,
                  cellColor,
                  textColor,
                  borderColor,
                  textAlign: TextAlign.start,
                ),
                ...List.generate(totalDays, (dayIndex) {
                  final String status =
                      student[dayKeys[dayIndex]]?.toString() ?? "-";
                  return _cell(
                    status,
                    40,
                    cellColor,
                    _getStatusColor(status),
                    borderColor,
                  );
                }),
              ],
            );
          }),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == "P") return Colors.green;
    if (status == "A") return Colors.red;
    return Colors.grey;
  }

  Widget _cell(
    String text,
    double width,
    Color bgColor,
    Color textColor,
    Color borderColor, {
    bool isHeader = false,
    TextAlign textAlign = TextAlign.center,
  }) {
    return Container(
      width: width,
      height: 46,
      alignment: textAlign == TextAlign.start
          ? Alignment.centerLeft
          : Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          right: BorderSide(color: borderColor),
          bottom: BorderSide(color: borderColor),
        ),
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/non_hostel_controller.dart';
import '../controllers/branch_controller.dart';
import '../model/non_hostel_student_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NonHostelPage extends StatefulWidget {
  const NonHostelPage({super.key});

  @override
  State<NonHostelPage> createState() => _NonHostelPageState();
}

class _NonHostelPageState extends State<NonHostelPage> {
  late final NonHostelController controller;

  @override
  void initState() {
    super.initState();
    // Ensure BranchController is available
    if (!Get.isRegistered<BranchController>()) {
      Get.put(BranchController());
    }
    controller = Get.put(NonHostelController());
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we are in dark mode for gradient colors
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF1a1a2e),
                  const Color(0xFF16213e),
                  const Color(0xFF0f3460),
                ]
              : [const Color(0xFFF5F6FA), const Color(0xFFE8ECF4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Non Hostel Students",
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black87,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.filterStudents,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  hintText: "Search by Name or Admission No",
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 20,
                  ),
                ),
              ),
            ),
            // Student List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: isDark ? Colors.blueAccent : Colors.blue,
                    ),
                  );
                }
                if (controller.filteredList.isEmpty) {
                  return Center(
                    child: Text(
                      "No students found",
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: controller.filteredList.length,
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 20,
                  ),
                  itemBuilder: (context, index) {
                    final student = controller.filteredList[index];
                    return _buildStudentCard(student, isDark);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      Get.snackbar("Error", "Could not launch dialer");
    }
  }

  Widget _buildStudentCard(NonHostelStudentModel student, bool isDark) {
    return Card(
      color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: isDark ? 0 : 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isDark
                      ? Colors.blueAccent.withOpacity(0.2)
                      : Colors.blue.shade100,
                  radius: 24,
                  child: Text(
                    student.studentName.isNotEmpty
                        ? student.studentName[0].toUpperCase()
                        : "?",
                    style: TextStyle(
                      color: isDark ? Colors.blueAccent : Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.studentName,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        student.admNo,
                        style: TextStyle(
                          color: isDark ? Colors.white60 : Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (student.phone.isNotEmpty)
                  IconButton(
                    onPressed: () => _makePhoneCall(student.phone),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.green.withOpacity(0.1),
                      shape: const CircleBorder(),
                    ),
                    icon: const Icon(Icons.phone, color: Colors.green),
                    tooltip: "Call Student",
                  ),
              ],
            ),
            const Divider(height: 24, color: Colors.white10),
            if (student.fatherName.isNotEmpty) ...[
              _buildInfoRow(
                Icons.person,
                "Father: ${student.fatherName}",
                isDark,
              ),
              const SizedBox(height: 8),
            ],
            if (student.phone.isNotEmpty) ...[
              _buildInfoRow(Icons.phone, "Phone: ${student.phone}", isDark),
              const SizedBox(height: 8),
            ],
            if (student.address.isNotEmpty) ...[
              _buildInfoRow(
                Icons.location_on,
                "Address: ${student.address}",
                isDark,
              ),
              const SizedBox(height: 16),
            ],
            if (student.course.isNotEmpty || student.batch.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (student.course.isNotEmpty)
                    _buildTag(student.course, isDark),
                  if (student.batch.isNotEmpty)
                    _buildTag(student.batch, isDark),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: isDark ? Colors.white54 : Colors.black45),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.1) : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.blue.shade100,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isDark ? Colors.white70 : Colors.blue.shade800,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

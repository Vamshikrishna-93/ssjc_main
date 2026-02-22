import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/student_model.dart';
import '../model/student_details_model.dart';
import '../api/api_service.dart';
import '../controllers/hostel_controller.dart';
import '../widgets/skeleton.dart';

class StudentDetailsPage extends StatefulWidget {
  final StudentModel? student;
  final String? admissionNo;

  const StudentDetailsPage({super.key, this.student, this.admissionNo});

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  bool isLoading = true;
  StudentDetailsModel? studentDetails;
  String? errorMessage;
  final HostelController hostelCtrl = Get.put(HostelController());

  @override
  void initState() {
    super.initState();
    _loadStudentDetails();
  }

  Future<void> _loadStudentDetails() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Determine admission number
      final admNo = widget.admissionNo ?? widget.student?.admNo;

      if (admNo == null || admNo.isEmpty) {
        throw Exception('Admission number is required');
      }

      // Fetch full student details from API
      final data = await ApiService.getStudentDetailsByAdmNo(admNo);

      setState(() {
        studentDetails = StudentDetailsModel.fromJson(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
        // Fallback to passed student data if available
        if (widget.student != null) {
          studentDetails = StudentDetailsModel.fromStudentModel(
            widget.student!,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [
                  Color(0xFF1a1a2e),
                  Color(0xFF16213e),
                  Color(0xFF0f3460),
                  Color(0xFF533483),
                ]
              : const [Color(0xFFF5F6FA), Color(0xFFE8ECF4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Student Details'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
            bottom: TabBar(
              onTap: (index) {
                if (index == 1 && studentDetails != null) {
                  hostelCtrl.loadHostelGrid(studentDetails!.sid);
                }
              },
              tabs: const [
                Tab(text: "Profile"),
                // Tab(text: "Hostel Attendance"),
              ],
            ),
          ),
          body: isLoading
              ? _buildSkeleton(context, isDark)
              : errorMessage != null && studentDetails == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _loadStudentDetails,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : TabBarView(
                  children: [
                    _buildStudentDetails(context, isDark),
                    // _buildHostelAttendanceGrid(context, isDark),
                  ],
                ),
        ),
      ),
    );
  }

  // Widget _buildHostelAttendanceGrid(BuildContext context, bool isDark) {
  //   return Obx(() {
  //     if (hostelCtrl.isLoading.value) {
  //       return const Center(child: CircularProgressIndicator());
  //     }

  //     if (hostelCtrl.hostelGrid.isEmpty) {
  //       return const Center(
  //         child: Text(
  //           "No attendance grid found",
  //           style: TextStyle(color: Colors.white70),
  //         ),
  //       );
  //     }

  //     return ListView.builder(
  //       padding: const EdgeInsets.all(16),
  //       itemCount: hostelCtrl.hostelGrid.length,
  //       itemBuilder: (context, index) {
  //         final monthData = hostelCtrl.hostelGrid[index];
  //         return Card(
  //           margin: const EdgeInsets.only(bottom: 16),
  //           color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.all(12),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   monthData.monthName ?? "Unknown Month",
  //                   style: const TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.blueAccent,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 12),
  //                 _buildDaysGrid(monthData.dayAttendance, isDark),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   });
  // }

  // Widget _buildDaysGrid(Map<String, String?> attendance, bool isDark) {
  //   return Wrap(
  //     spacing: 8,
  //     runSpacing: 8,
  //     children: List.generate(31, (index) {
  //       final dayNum = (index + 1).toString().padLeft(2, '0');
  //       final status = attendance["Day_$dayNum"];

  //       return Container(
  //         width: 35,
  //         height: 35,
  //         alignment: Alignment.center,
  //         decoration: BoxDecoration(
  //           color: _getDayColor(status, isDark),
  //           borderRadius: BorderRadius.circular(6),
  //           border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
  //         ),
  //         child: Text(
  //           (index + 1).toString(),
  //           style: TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.bold,
  //             color: status != null
  //                 ? Colors.white
  //                 : (isDark ? Colors.white38 : Colors.black38),
  //           ),
  //         ),
  //       );
  //     }),
  //   );
  // }

  // Color _getDayColor(String? status, bool isDark) {
  //   if (status == null || status.isEmpty || status == "null") {
  //     return isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100;
  //   }
  //   switch (status.toUpperCase()) {
  //     case 'P':
  //       return Colors.green.shade600;
  //     case 'A':
  //       return Colors.red.shade600;
  //     case 'O':
  //       return Colors.orange.shade600;
  //     case 'M':
  //       return Colors.redAccent.shade400;
  //     case 'H':
  //       return Colors.purple.shade600;
  //     default:
  //       return Colors.blueGrey;
  //   }
  // }

  Widget _buildStudentDetails(BuildContext context, bool isDark) {
    if (studentDetails == null) return const SizedBox.shrink();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366f1), Color(0xFF818cf8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${studentDetails!.sFirstName} ${studentDetails!.sLastName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Admission No: ${studentDetails!.admNo}',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              studentDetails!.status.toLowerCase() == 'active'
                              ? Colors.green
                              : studentDetails!.status.toLowerCase() ==
                                    'suspended'
                              ? Colors.orange
                              : Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          studentDetails!.status.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (studentDetails!.isFlagged) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.flag, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'FLAGGED',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Personal Information Section
            _buildSectionTitle(context, 'Personal Information'),
            const SizedBox(height: 12),
            _buildInfoCard(context, [
              _buildInfoRow(
                context,
                Icons.person_outline,
                'Full Name',
                '${studentDetails!.sFirstName} ${studentDetails!.sLastName}',
                const Color(0xFF6366f1),
              ),
              _buildInfoRow(
                context,
                Icons.family_restroom,
                'Father Name',
                studentDetails!.fatherName,
                const Color(0xFF8b5cf6),
              ),
              _buildInfoRow(
                context,
                Icons.phone,
                'Mobile',
                studentDetails!.mobile,
                const Color(0xFF06b6d4),
              ),
            ]),

            const SizedBox(height: 24),

            // Academic Information Section
            _buildSectionTitle(context, 'Academic Information'),
            const SizedBox(height: 12),
            _buildInfoCard(context, [
              _buildInfoRow(
                context,
                Icons.school,
                'Branch',
                studentDetails!.branchName,
                const Color(0xFF10b981),
              ),
              _buildInfoRow(
                context,
                Icons.groups,
                'Group',
                studentDetails!.groupName,
                const Color(0xFFF59e0b),
              ),
              _buildInfoRow(
                context,
                Icons.book,
                'Course',
                studentDetails!.courseName,
                const Color(0xFF3b82f6),
              ),
              _buildInfoRow(
                context,
                Icons.class_,
                'Batch',
                studentDetails!.batch,
                const Color(0xFFec4899),
              ),
            ]),

            const SizedBox(height: 24),

            // Student ID Card
            _buildSectionTitle(context, 'Student ID'),
            const SizedBox(height: 12),
            _buildInfoCard(context, [
              _buildInfoRow(
                context,
                Icons.badge,
                'Student ID',
                studentDetails!.sid.toString(),
                const Color(0xFF3b82f6),
              ),
              _buildInfoRow(
                context,
                Icons.confirmation_number,
                'Admission Number',
                studentDetails!.admNo,
                const Color(0xFF6366f1),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B).withOpacity(
                0.7,
              ) // Deep navy/slate for dark mode
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.26)
                : Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? 'N/A' : value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonLoader(
            width: double.infinity,
            height: 200,
            borderRadius: 16,
          ),
          const SizedBox(height: 24),
          const SkeletonLoader(width: 150, height: 24),
          const SizedBox(height: 12),
          const SkeletonLoader(
            width: double.infinity,
            height: 120,
            borderRadius: 20,
          ),
          const SizedBox(height: 24),
          const SkeletonLoader(width: 150, height: 24),
          const SizedBox(height: 12),
          const SkeletonLoader(
            width: double.infinity,
            height: 160,
            borderRadius: 20,
          ),
        ],
      ),
    );
  }
}

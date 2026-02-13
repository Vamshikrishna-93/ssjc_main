import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app/staff_app/pages/dashboard_page.dart';
import 'package:student_app/staff_app/pages/login_page.dart';
import 'package:get_storage/get_storage.dart';
import 'package:student_app/home/home_page.dart';
import 'package:student_app/staff_app/pages/non_hostel_page.dart';
import 'package:student_app/staff_app/pages/verify_attendance_page.dart';

// Staff Controllers
import 'package:student_app/staff_app/controllers/theme_controller.dart';
import 'package:student_app/staff_app/controllers/auth_controller.dart';

// Staff Theme
import 'package:student_app/staff_app/theme/app_theme.dart';

// Staff Storage
import 'package:student_app/staff_app/utils/get_storage.dart';

// Staff Pages
import 'package:student_app/staff_app/pages/profile_page.dart';
import 'package:student_app/staff_app/pages/staff_list_page.dart';
import 'package:student_app/staff_app/pages/outing_list_page.dart';
import 'package:student_app/staff_app/pages/outing_pending_listPage.dart';
import 'package:student_app/staff_app/pages/subject_marks_upload_page.dart';
import 'package:student_app/staff_app/pages/Staff_Attendance_Page.dart';
import 'package:student_app/staff_app/pages/ClassAttendancePage.dart';
import 'package:student_app/staff_app/pages/exam_category_list_page.dart';
import 'package:student_app/staff_app/pages/exam_list_page.dart';
import 'package:student_app/staff_app/pages/student_attendance.dart';
import 'package:student_app/staff_app/pages/Room_page.dart';
import 'package:student_app/staff_app/pages/hostel_members_page.dart';
import 'package:student_app/staff_app/pages/floors_page.dart';
import 'package:student_app/staff_app/pages/add_hostel_page.dart';
import 'package:student_app/staff_app/pages/hostel_attendance_View_page.dart';
import 'package:student_app/staff_app/pages/hostel_attendance_result_page.dart';
import 'package:student_app/staff_app/pages/fee_head_page.dart';
import 'package:student_app/staff_app/pages/assign_students_page.dart';
import 'package:student_app/staff_app/pages/hostel_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // 🌗 Global controller (NOT user-specific) - Staff App
  Get.put(ThemeController(), permanent: true);

  // 🔐 AuthController MUST NOT be permanent (multi-user safe) - Staff App
  Get.lazyPut<AuthController>(() => AuthController());

  // 🔐 Check Staff Login Status
  final bool isStaffLoggedIn = AppStorage.isLoggedIn();
  final String initialRoute = isStaffLoggedIn ? '/dashboard' : '/';

  runApp(SsJcApp(initialRoute: initialRoute));
}

class SsJcApp extends StatelessWidget {
  final String initialRoute;
  const SsJcApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    // Bind to Staff ThemeController for app-wide theme
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SSJC',

        // 🌗 THEME (Staff App Theme)
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.isDark.value
            ? ThemeMode.dark
            : ThemeMode.light,

        // 🚀 Entry Point: Based on authentication status
        initialRoute: initialRoute,

        getPages: [
          // 🏠 HOME / ROLE SELECTION
          GetPage(name: '/home', page: () => const HomePage()),

          // 🔑 AUTH FLOW
          // Note: '/splash' in Staff App is Staff Splash.
          // Since we start with HomePage (Role), we might not use '/splash' as initial route.
          //  GetPage(name: '/splash', page: () => const SplashPage()),
          GetPage(name: '/login', page: () => const LoginPage()),
          GetPage(name: '/dashboard', page: () => const HomeDashboardPage()),
          GetPage(name: '/profile', page: () => const ProfilePage()),

          // 👨🏫 STAFF
          GetPage(name: '/staff', page: () => const StaffListPage()),
          GetPage(
            name: '/staffAttendance',
            page: () => const StaffAttendancePage(),
          ),
          GetPage(name: '/classAttendance', page: () => ClassAttendancePage()),

          // 🚶 OUTING
          GetPage(name: '/outingList', page: () => const OutingListPage()),
          GetPage(
            name: '/outingPending',
            page: () => const OutingPendingListPage(),
          ),

          // 📝 ATTENDANCE
          GetPage(
            name: '/verifyAttendance',
            page: () => const VerifyAttendancePage(),
          ),
          GetPage(
            name: '/studentAttendance',
            page: () => const StudentAttendancePage(),
          ),

          // 📚 EXAMS
          GetPage(
            name: '/examCategoryList',
            page: () => const ExamCategoryListPage(),
          ),
          GetPage(name: '/examsList', page: () => const ExamsListPage()),
          GetPage(
            name: '/marksUpload',
            page: () => const SubjectMarksUploadPage(),
          ),

          // 💰 FEES
          GetPage(name: '/feeHeads', page: () => const FeeHeadPage()),

          // 🏨 HOSTEL / ROOMS
          GetPage(name: '/rooms', page: () => const RoomsPage()),
          GetPage(
            name: '/hostelMembers',
            page: () => const HostelMembersPage(),
          ),
          GetPage(name: '/floors', page: () => const FloorsManagementPage()),
          GetPage(name: '/hostelList', page: () => const HostelListPage()),
          GetPage(name: '/addHostel', page: () => const AddHostelPage()),
          GetPage(name: '/nonHostel', page: () => const NonHostelPage()),
          GetPage(
            name: '/hostelAttendanceFilter',
            page: () => const HostelAttendanceFilterPage(),
          ),
          GetPage(
            name: '/hostelAttendanceResult',
            page: () => const HostelAttendanceResultPage(),
          ),
          GetPage(
            name: '/assignStudents',
            page: () => const AssignStudentsPage(students: []),
          ),
        ],
      ),
    );
  }
}

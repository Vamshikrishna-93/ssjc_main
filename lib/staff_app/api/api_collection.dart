class ApiCollection {
  static const String baseUrl = "https://stage.srisaraswathigroups.in/api";

  // LOGIN (QUERY PARAMS — EXACTLY LIKE POSTMAN)
  static String login({required String username, required String password}) {
    return "/login"
        "?user_login=${Uri.encodeQueryComponent(username)}"
        "&password=${Uri.encodeQueryComponent(password)}";
  }

  static const String branchList = "/branchlist";
  static String groupsByBranch(int branchId) => "/groupslistbybranch/$branchId";
  static String coursesByGroup(int groupId) => "/courselistbygroup/$groupId";
  static String batchesByCourse(int courseId) => "/batchlistbycourse/$courseId";
  static String shiftsByBranch(int branchId) => "/shiftlistbybranch/$branchId";
  static String studentByAdmNo(String admNo) =>
      "/getstudentdetailsbysearch/$admNo";

  static const String outingList =
      "/outinglist?branch[]=All&report_type=All&daybookfilter=All&firstdate=&nextdate=";

  static const String pendingOutingList = "/getpendingoutinglist";
  static const String departmentsList = "/departmentslist";
  static const String designationsList = "/designationslist";
  static const String examsList = "/exams_list";
  static const String myProfile = "/myprofile";

  static String feeHeadsByBranch(int branchId) => "/feeheadsbybranch/$branchId";

  static String monthlyAttendance({
    required int branchId,
    required int groupId,
    required int courseId,
    required int batchId,
    required String month,
    required int shiftId,
  }) {
    return "/monthlyattendanceList"
        "?branchid=$branchId"
        "&groupid=$groupId"
        "&courseid=$courseId"
        "&batchid=$batchId"
        "&month=$month"
        "&shift=$shiftId";
  }
}

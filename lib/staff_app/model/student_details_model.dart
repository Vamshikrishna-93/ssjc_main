class StudentDetailsModel {
  final String admNo;
  final int sid;
  final String sFirstName;
  final String sLastName;
  final String fatherName;
  final String mobile;
  final String status;
  final String branchName;
  final String groupName;
  final String courseName;
  final String batch;
  final bool isFlagged;

  StudentDetailsModel({
    required this.admNo,
    required this.sid,
    required this.sFirstName,
    required this.sLastName,
    required this.fatherName,
    required this.mobile,
    required this.status,
    required this.branchName,
    required this.groupName,
    required this.courseName,
    required this.batch,
    required this.isFlagged,
  });

  factory StudentDetailsModel.fromJson(Map<String, dynamic> json) {
    return StudentDetailsModel(
      admNo: json['admno']?.toString() ?? '',
      sid: json['sid'] is int
          ? json['sid']
          : int.tryParse(json['sid']?.toString() ?? '0') ?? 0,
      sFirstName: json['sfname']?.toString() ?? '',
      sLastName: json['slname']?.toString() ?? '',
      fatherName: json['fname']?.toString() ?? '',
      mobile: json['pmobile']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      branchName: json['branch_name']?.toString() ?? '',
      groupName: json['groupname']?.toString() ?? '',
      courseName: json['coursename']?.toString() ?? '',
      batch: json['batch']?.toString() ?? '',
      isFlagged: json['isflagged'] == null || json['isflagged'] == 'null'
          ? false
          : true,
    );
  }

  // Convert StudentModel to StudentDetailsModel
  factory StudentDetailsModel.fromStudentModel(dynamic studentModel) {
    return StudentDetailsModel(
      admNo: studentModel.admNo ?? '',
      sid: studentModel.sid ?? 0,
      sFirstName: studentModel.sFirstName ?? '',
      sLastName: studentModel.sLastName ?? '',
      fatherName: studentModel.fatherName ?? '',
      mobile: studentModel.mobile ?? '',
      status: studentModel.status ?? '',
      branchName: studentModel.branchName ?? '',
      groupName: studentModel.groupName ?? '',
      courseName: studentModel.courseName ?? studentModel.batch ?? '',
      batch: studentModel.batch ?? '',
      isFlagged: studentModel.isFlagged ?? false,
    );
  }
}

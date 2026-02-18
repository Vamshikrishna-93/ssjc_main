class StudentModel {
  final String admNo;
  final int sid;
  final String sFirstName;
  final String sLastName;
  final String fatherName;
  final String mobile;
  final String status;
  final String branchName;
  final String groupName;
  final String batch;
  final String courseName;
  final bool isFlagged;

  StudentModel({
    required this.admNo,
    required this.sid,
    required this.sFirstName,
    required this.sLastName,
    required this.fatherName,
    required this.mobile,
    required this.status,
    required this.branchName,
    required this.groupName,
    required this.batch,
    required this.courseName,
    required this.isFlagged,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
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
      batch: json['batch']?.toString() ?? '',
      courseName: json['coursename']?.toString() ?? '',
      isFlagged: json['isflagged'] == null || json['isflagged'] == 'null'
          ? false
          : true,
    );
  }
}

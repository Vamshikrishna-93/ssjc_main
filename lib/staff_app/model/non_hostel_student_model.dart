class NonHostelStudentModel {
  final String admNo;
  final int sid;
  final String studentName;
  final String fatherName;
  final String phone;
  final String address;
  final String course;
  final String batch;

  NonHostelStudentModel({
    required this.admNo,
    required this.sid,
    required this.studentName,
    required this.fatherName,
    required this.phone,
    required this.address,
    required this.course,
    required this.batch,
  });

  factory NonHostelStudentModel.fromJson(Map<String, dynamic> json) {
    return NonHostelStudentModel(
      admNo: json['admno']?.toString() ?? '',
      sid: int.tryParse(json['sid']?.toString() ?? '0') ?? 0,
      studentName: json['student_name']?.toString() ?? '',
      fatherName: json['father_name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      course: json['course_name']?.toString() ?? '',
      batch: json['batch_name']?.toString() ?? '',
    );
  }
}

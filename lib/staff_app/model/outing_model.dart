class OutingModel {
  final int id;
  final String admno;
  final String studentName;
  final String outingType;
  final String outDate;
  final String outingTime;
  final String purpose;
  final String status;
  final String permission;
  final String branch;

  OutingModel({
    required this.id,
    required this.admno,
    required this.studentName,
    required this.outingType,
    required this.outDate,
    required this.outingTime,
    required this.purpose,
    required this.status,
    required this.permission,
    required this.branch,
  });

  factory OutingModel.fromJson(Map<String, dynamic> json) {
    return OutingModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      admno: json['admno']?.toString() ?? '',
      studentName:
          (json['student_name'] ?? json['sname'] ?? json['studentname'] ?? '')
              .toString(),
      outingType: (json['outingtype'] ?? json['outing_type'] ?? '').toString(),
      outDate: (json['out_date'] ?? json['date'] ?? '').toString(),
      outingTime: (json['outing_time'] ?? json['time'] ?? '').toString(),
      purpose: (json['purpose'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      permission: (json['permission'] ?? '').toString(),
      branch: (json['branch'] ?? '').toString(),
    );
  }
}

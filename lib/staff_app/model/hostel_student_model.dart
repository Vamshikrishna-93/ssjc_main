class HostelStudentModel {
  final int sid;
  final String admno;
  final String studentName;
  final String? phone;
  final String? gender;
  final String? hostel;
  final String? floor;
  final String? room;

  HostelStudentModel({
    required this.sid,
    required this.admno,
    required this.studentName,
    this.phone,
    this.gender,
    this.hostel,
    this.floor,
    this.room,
  });

  factory HostelStudentModel.fromJson(Map<String, dynamic> json) {
    return HostelStudentModel(
      sid: int.tryParse(json['sid']?.toString() ?? '0') ?? 0,
      admno: json['admno']?.toString() ?? '',
      studentName:
          json['student_name']?.toString() ??
          json['full_name']?.toString() ??
          '',
      phone: json['phone']?.toString() ?? json['pmobile']?.toString() ?? '',
      gender: json['gender']?.toString(),
      hostel: json['hostel']?.toString(),
      floor: json['floor']?.toString(),
      room: json['room']?.toString(),
    );
  }
}

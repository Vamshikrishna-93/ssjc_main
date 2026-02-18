class RoomAttendanceModel {
  final int sid;
  final String admno;
  final String studentName;
  final String? phone;
  final String? status;
  final String? date;
  // Nested attendance data: e.g., {"17": {"Morning": "-", "Night": "-", "1": "P"}}
  final Map<String, dynamic>? attendanceMap;

  RoomAttendanceModel({
    required this.sid,
    required this.admno,
    required this.studentName,
    this.phone,
    this.status,
    this.date,
    this.attendanceMap,
  });

  factory RoomAttendanceModel.fromJson(Map<String, dynamic> json) {
    return RoomAttendanceModel(
      sid: int.tryParse(json['sid']?.toString() ?? '0') ?? 0,
      admno: json['admno']?.toString() ?? '',
      studentName:
          json['full_name']?.toString() ??
          json['student_name']?.toString() ??
          '',
      phone: json['pmobile']?.toString() ?? json['phone']?.toString() ?? '',
      status: json['at_status']?.toString(),
      date: json['at_date']?.toString(),
      attendanceMap: json['attendance'] != null && json['attendance'] is Map
          ? Map<String, dynamic>.from(json['attendance'])
          : null,
    );
  }
}

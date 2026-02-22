class AttendanceRecord {
  final String batch;
  final int total;
  final int present;
  final int absent;
  final int branchId;
  final int groupId;
  final int courseId;
  final int batchId;

  AttendanceRecord({
    required this.batch,
    required this.total,
    required this.present,
    required this.absent,
    required this.branchId,
    required this.groupId,
    required this.courseId,
    required this.batchId,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      batch: json['batch']?.toString() ?? '',
      total: int.tryParse(json['TotalStudents']?.toString() ?? '0') ?? 0,
      present: int.tryParse(json['TotalPresent']?.toString() ?? '0') ?? 0,
      absent: int.tryParse(json['TotalAbsent']?.toString() ?? '0') ?? 0,
      branchId: int.tryParse(json['branch_id']?.toString() ?? '0') ?? 0,
      groupId: int.tryParse(json['group_id']?.toString() ?? '0') ?? 0,
      courseId: int.tryParse(json['course_id']?.toString() ?? '0') ?? 0,
      batchId: int.tryParse(json['batch_id']?.toString() ?? '0') ?? 0,
    );
  }
}

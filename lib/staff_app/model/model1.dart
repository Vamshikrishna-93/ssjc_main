class AttendanceRecord {
  final String batch;
  final int total;
  final int present;
  final int absent;
  final int outing;

  AttendanceRecord({
    required this.batch,
    required this.total,
    required this.present,
    required this.absent,
    required this.outing,
  });
}

class HostelGridModel {
  final String? monthName;
  final Map<String, String?> dayAttendance;

  HostelGridModel({this.monthName, required this.dayAttendance});

  factory HostelGridModel.fromJson(Map<String, dynamic> json) {
    Map<String, String?> days = {};
    for (int i = 1; i <= 31; i++) {
      String key = "Day_${i.toString().padLeft(2, '0')}";
      days[key] = json[key]?.toString();
    }

    return HostelGridModel(
      monthName: json['month_name']?.toString(),
      dayAttendance: days,
    );
  }
}

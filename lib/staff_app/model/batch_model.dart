class BatchModel {
  final int id;
  final String batchName;
  final int courseId;
  final int groupId;
  final int branchId;
  final int status;

  BatchModel({
    required this.id,
    required this.batchName,
    required this.courseId,
    required this.groupId,
    required this.branchId,
    required this.status,
  });

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    return BatchModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      batchName:
          (json['batch'] ??
                  json['batchname'] ??
                  json['batch_name'] ??
                  json['name'] ??
                  '')
              .toString(),
      courseId: json['course_id'] is int
          ? json['course_id']
          : int.tryParse(json['course_id'].toString()) ?? 0,
      groupId: json['group_id'] is int
          ? json['group_id']
          : int.tryParse(json['group_id'].toString()) ?? 0,
      branchId: json['branch_id'] is int
          ? json['branch_id']
          : int.tryParse(json['branch_id'].toString()) ?? 0,
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status'].toString()) ?? 0,
    );
  }
}

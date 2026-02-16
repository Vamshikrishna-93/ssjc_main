class ExamCategory {
  final int id;
  final String category;
  final int? branchId;
  final String branchName;

  ExamCategory({
    required this.id,
    required this.category,
    this.branchId,
    required this.branchName,
  });

  factory ExamCategory.fromJson(Map<String, dynamic> json) {
    return ExamCategory(
      id: json['id'],
      category: json['category'],
      branchId: json['branch_id'],
      branchName: json['branch_name'] ?? '',
    );
  }
}

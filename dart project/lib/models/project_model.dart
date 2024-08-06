class Project {
  final int projectId;
  final String projectTitle;
  final String abstract;
  final int batchId;
  final String status;
  final String remarks;

  Project({
    required this.projectId,
    required this.projectTitle,
    required this.abstract,
    required this.batchId,
    required this.status,
    required this.remarks,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['project_id'],
      projectTitle: json['project_title'],
      abstract: json['abstract'],
      batchId: json['batch_id'],
      status: json['status'],
      remarks: json['remarks'],
    );
  }
}

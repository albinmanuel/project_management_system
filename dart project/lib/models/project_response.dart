class ProjectResponse {
  final bool status;
  final String message;
  final String project_id;



  ProjectResponse({required this.status, required this.message,required this.project_id});

  factory ProjectResponse.fromJson(Map<String, dynamic> json) {
    return ProjectResponse(
        status: json['status'],
        message: json['message'],
        project_id: json['project_id'].toString()


    );
  }
}
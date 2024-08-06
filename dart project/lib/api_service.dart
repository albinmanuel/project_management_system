import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/models/batch_model.dart';
import 'package:untitled/models/login_response.dart';
import 'package:untitled/models/project_model.dart';
import 'package:untitled/models/project_response.dart';

class ApiService {
  String baseUrl = "http://127.0.0.1:8000/";


  Future<LoginResponse> isAuthorizedStudent(String uname,
      String password) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'check_login_student'),
      body: {'uname': uname, 'password': password},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Failed to check authorization');
    }
  }


  Future<List<Batch>> getBatches() async {
    final response = await http.get(Uri.parse(baseUrl + 'get_batch'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<Batch> batches = data.map((json) => Batch.fromJson(json)).toList();
      return batches;
    } else {
      throw Exception('Failed to load projects');
    }
  }



  Future<ProjectResponse> saveProject(String projectName, String abstract,
      String username) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'saveproject'),
      body: {'pname': projectName, 'abstract': abstract, 'username': username},
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return ProjectResponse.fromJson(data);
    } else {
      throw Exception('Failed to check authorization');
    }
  }

  Future<String> add_group(String groupName, String createdBy) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'add_group'),
      body: {'group_title': groupName , 'created_by': createdBy },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }

  Future<String> add_group_member(String groupID, String createdBy) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'add_members'),
      body: {'group_id': groupID , 'username': createdBy },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }
  Future<String> get_project_group_members(String email) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'get_project_group_members'),
      body: {'email': email  },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }
  Future<String> get_all_student(String email) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'get_all_student'),
      body: {'email': email  },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }
  Future<String> get_all_student_projects(String email) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'get_all_student_projects'),
      body: {'email': email  },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }

  Future<String> get_all_guides() async {
    final response = await http.post(
      Uri.parse(baseUrl + 'get_all_guides'),
      body: {  },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }

  Future<String> add_project_guide(String project_id, String staff_id) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'add_project_guide'),
      body: {'project_id': project_id , 'staff_id': staff_id },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }
  Future<String> get_all_guides_by_pid(String project_id) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'get_all_guides_by_pid'),
      body: {'project_id': project_id ,  },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }

  Future<String> get_alert_message_by_pid(String project_id) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'get_alert_message_by_pid'),
      body: {'project_id': project_id ,  },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }

  Future<String> get_guide_message_by_pid(String project_id) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'get_guide_message_by_pid'),
      body: {'project_id': project_id ,  },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }


  Future<String> get_project_by_pid(String project_id) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'get_project_by_pid'),
      body: {'project_id': project_id ,  },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }

  Future<String> get_staff_by_staff_id(String staff_id) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'get_staff_by_staff_id'),
      body: {'staff_id': staff_id ,  },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }
  Future<String> get_staff_technologies_by_staff_id(String staff_id) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'get_staff_technologies_by_staff_id'),
      body: {'staff_id': staff_id ,  },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }

  Future<String> get_allowed_student_project(String email) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'get_allowed_student_project'),
      body: {'email': email ,  },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }

  Future<String> add_task(String project_id,String task_name) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'add_task'),
      body: {'project_id': project_id ,'task_name': task_name ,  },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }
  Future<String> get_task_by_project_id(String project_id) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'get_task_by_project_id'),
      body: {'project_id': project_id   },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }

  Future<String> delete_task(String task_id) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'delete_task'),
      body: {'task_id': task_id   },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }
  Future<String> update_task_complete(String task_id) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'update_task_complete'),
      body: {'task_id': task_id   },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }

  Future<String> get_report_by_project_id(String project_id) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'get_report_by_project_id'),
      body: {'project_id': project_id   },
    );

    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to check authorization');
    }
  }



  static void ShowMessage(BuildContext _context, String title, String message) {
    showDialog(
        context: _context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        }
    );
  }
}
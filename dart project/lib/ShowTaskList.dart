import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:untitled/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowTaskList extends StatefulWidget {
  @override
  _ShowTaskListState createState() => _ShowTaskListState();
}

class _ShowTaskListState extends State<ShowTaskList> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _tasks = [];
  Map<String, dynamic> allowedProject = {};
  bool _isLoading = true;
  String _loggedInUserEmail = '';
  String project_id = "";
  String task_name = "";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('username') ?? '';
    setState(() {
      _loggedInUserEmail = email;
    });
    _fetchAllowedProjectData(email);
  }

  Future<void> _fetchTask() async {
    try {
      String response = await _apiService.get_task_by_project_id(project_id);
      List<dynamic> jsonResponse = jsonDecode(response);
      setState(() {
        _tasks = List<Map<String, dynamic>>.from(jsonResponse);
      });
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  Future<void> _fetchAllowedProjectData(String email) async {
    try {
      String response =
      await _apiService.get_allowed_student_project(email);
      Map<String, dynamic> jsonResponse = jsonDecode(response);
      setState(() {
        allowedProject = jsonResponse;
        project_id = allowedProject['project_id'].toString();
        _isLoading = false;
      });
      _fetchTask();
    } catch (e) {
      print('Error fetching allowed project: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createNewTask(BuildContext context) async {
    try {
      String group_response =
      await _apiService.add_task(project_id, task_name);
      Map<String, dynamic> data = jsonDecode(group_response);
      if (data['status'] == true) {
        ApiService.ShowMessage(
            context, "Message", "Task created successfully");
        _fetchTask();
      } else {
        ApiService.ShowMessage(context, "Error", data['message']);
      }
    } catch (e) {
      print('Data entry error: $e');
      ApiService.ShowMessage(
          context,
          "Error",
          'An error occurred while adding the task. '
              'Please try again later.');
    }
  }

  Future<void> _deleteTask(BuildContext context, String task_id) async {
    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(_context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Delete the task if confirmed
                try {
                  String group_response =
                  await _apiService.delete_task(task_id);
                  Map<String, dynamic> data = jsonDecode(group_response);
                  if (data['status'] == true) {

                    _fetchTask();
                  }
                } catch (e) {
                  print('Error deleting task: $e');
                }
                Navigator.of(_context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  Future<void> _updateTaskStatus(BuildContext context, String task_id) async {
    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          title: Text('Confirm Update'),
          content: Text('Do you want to set this task as complete?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(_context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Update the task status if confirmed
                try {
                  String group_response =
                  await _apiService.update_task_complete(task_id);
                  Map<String, dynamic> data = jsonDecode(group_response);
                  if (data['status'] == true) {

                    _fetchTask();
                  }
                } catch (e) {
                  print('Error updating task status: $e');
                }
                Navigator.of(_context).pop(); // Close the dialog
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : allowedProject.isNotEmpty
          ? Column(
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext _context) {
                  return AlertDialog(
                    title: Text('Create New Task'),
                    content: TextField(
                      onChanged: (value) {
                        task_name = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Task Name',
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(_context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _createNewTask(context);
                          Navigator.of(_context).pop();
                        },
                        child: Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Create New Task'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (BuildContext _context, int index) {
                Map<String, dynamic> task = _tasks[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0), // Optional: Adjust border radius as needed
                  ),
                  child: ListTile(
                    title: Text(task['task_name']),
                    subtitle: Text(
                      'Status: ${task['task_status'] ?? ''}',
                      style: TextStyle(
                        color: task['task_status'] == 'created' ? Colors.red : Colors.green,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteTask(context,task['task_id'].toString());
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _updateTaskStatus(context,
                                task['task_id'].toString());
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      )
          : Center(
        child: Text('Your project is not exist or approved'),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:untitled/ProjectGuideRequest.dart';
import 'package:untitled/api_service.dart'; // Import your ApiService class
import 'package:shared_preferences/shared_preferences.dart';

class MyProjectsWidget extends StatefulWidget {
  @override
  _MyProjectsWidgetState createState() => _MyProjectsWidgetState();
}

class _MyProjectsWidgetState extends State<MyProjectsWidget> {
  List<Map<String, dynamic>> _projects = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('username') ?? '';
    _fetchProjects(email);
  }

  Future<void> _fetchProjects(String email) async {
    try {
      // Call your API to fetch projects
      String response = await _apiService.get_all_student_projects(email);
      List<dynamic> jsonResponse = jsonDecode(response);
      setState(() {
        _projects = List<Map<String, dynamic>>.from(jsonResponse);
      });
    } catch (e) {
      // Handle errors here
      print('Error fetching projects: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MY PROJECTS'),
      ),
      body: _projects.isNotEmpty
          ? ListView.builder(
        itemCount: _projects.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> project = _projects[index];
          return GestureDetector(
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectGuideRequest(projectId: project['project_id']),
                ),
              );
            },
            child: ListTile(
              title: Text(
                project['project_title'] ?? 'No Title',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(project['group_title'] ?? 'No Group Title'),
              trailing: Text(
                project['status'] ?? 'No Status',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

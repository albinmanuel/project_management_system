import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:untitled/NewReportFormPage.dart';
import 'package:untitled/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowReportList extends StatefulWidget {
  @override
  _ShowReportListState createState() => _ShowReportListState();
}

class _ShowReportListState extends State<ShowReportList> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _reports = [];
  Map<String, dynamic> allowedProject = {};
  bool _isLoading = true;
  String _loggedInUserEmail = '';
  String project_id = '';
  String report_title = '';
  File? _selectedFile;

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

  Future<void> _fetchReports() async {
    try {
      String response = await _apiService.get_report_by_project_id(project_id);
      List<dynamic> jsonResponse = jsonDecode(response);
      setState(() {
        _reports = List<Map<String, dynamic>>.from(jsonResponse);
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
      _fetchReports();
    } catch (e) {
      print('Error fetching allowed project: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report List'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : allowedProject.isNotEmpty
          ? Column(
        children: [
          ElevatedButton(
            onPressed: ()   {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewReportFormPage(project_id:project_id)),
              );
            },
            child: Text('Create New Report'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _reports.length,
              itemBuilder: (BuildContext _context, int index) {
                Map<String, dynamic> task = _reports[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text(task['report_title']),
                    subtitle: Text("Mark:${task['mark']}"),
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

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:untitled/api_service.dart';
import 'package:untitled/models/batch_model.dart';
import 'package:untitled/models/login_response.dart';
import 'package:untitled/models/project_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProjectFormWidget extends StatefulWidget {
  @override
  _ProjectFormWidgetState createState() => _ProjectFormWidgetState();
}

class _ProjectFormWidgetState extends State<ProjectFormWidget> {
  String _projectTitle = '';
  String _abstract = '';
  String _selectedBatchId = ''; // Variable to store selected batch ID

  List<Map<String, String>> _batches = [{'id': '', 'name': 'Select'}]; // Initial empty list
  String _loggedInUserEmail = '';


  @override
  void initState() {
    super.initState(); // Initialize _selectedValue
    _fetchData();
    _loadBatches();
  }

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('username') ?? '';
    setState(() {
      _loggedInUserEmail = email;
    });
  }

  Future<void> _loadBatches() async {
    try {
      List<Batch> batches = await ApiService().getBatches();
      setState(() {
        _batches = batches
            .map((batch) => {'id': batch.batchId, 'name': batch.batchTitle})
            .toList();
        _batches.insert(0, {'id': '', 'name': 'Select'}); // Add 'Select' option at the beginning
      });
    } catch (e) {
      // Handle error
      print('Error fetching batches: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Project Title'),
              onChanged: (value) {
                setState(() {
                  _projectTitle = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Abstract'),
              maxLines: 4,
              onChanged: (value) {
                setState(() {
                  _abstract = value;
                });
              },
            ),
            SizedBox(height: 20.0),

            ElevatedButton(
              onPressed: () {
                _saveproject(context);

                // Handle form submission here
               print("saved");
                // You can access _projectTitle, _abstract, and _selectedBatchId
              },
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
  void _saveproject(BuildContext context) async {
    ApiService apiService = ApiService();
    try {
      ProjectResponse response = await apiService.saveProject( _projectTitle, _abstract, _loggedInUserEmail);
      // Check the status of the login response
      if (response.status) {
        // If login is successful, navigate to the user dashboard
        ApiService.ShowMessage(context, "Message", response.message);
      } else {
        // If login fails, show an error message
        ApiService.ShowMessage(context, "Error", response.message);

      }
    } catch (e) {
      // Handle error
      print('Data entry error: $e');
      ApiService.ShowMessage(context, "Error", 'An error occurred while data entry. Please try again later.');

    }
  }
}


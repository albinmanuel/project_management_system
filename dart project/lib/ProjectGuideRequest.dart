import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/api_service.dart'; // Import your ApiService class
import 'package:shared_preferences/shared_preferences.dart';

class ProjectGuideRequest extends StatefulWidget {
  final int projectId;

  ProjectGuideRequest({required this.projectId});

  @override
  _ProjectGuideRequestState createState() => _ProjectGuideRequestState();
}

class _ProjectGuideRequestState extends State<ProjectGuideRequest> {
  final ApiService _apiService = ApiService();
  String _selectedGuideId = '';
  Map<String, dynamic> _projectDetails = {};
  List<Map<String, dynamic>> _guides = [];
  List<Map<String, dynamic>> _guideDetails = [];
  List<Map<String, dynamic>> _guidealertMessages = [];
  List<Map<String, dynamic>> _guideMessagesMessages = [];

  bool _showRequestButton = false; // Track the visibility of the "Request a Guide" button

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchGuideDetails();
    _fetchProjectDetails();
    _fetchAlertMessages();
    _fetchGuideMessages();
  }
  Future<void> _fetchProjectDetails() async {
    try {
      String response = await _apiService.get_project_by_pid(widget.projectId.toString());
      Map<String, dynamic> jsonResponse = jsonDecode(response);
      setState(() {
        _projectDetails = jsonResponse;
        _showRequestButton = _projectDetails['status'] == 'Allowed';
      });
    } catch (e) {
      // Handle errors here
      print('Error fetching project details: $e');
    }
  }
  Future<void> _fetchAlertMessages() async {
    try {
      String response = await _apiService.get_alert_message_by_pid(widget.projectId.toString());
      List<dynamic> jsonResponse = jsonDecode(response);
      setState(() {
        _guidealertMessages = List<Map<String, dynamic>>.from(jsonResponse);

      });
    } catch (e) {
      // Handle errors here
      print('Error fetching project details: $e');
    }
  }

  Future<void> _fetchGuideMessages() async {
    try {
      String response = await _apiService.get_guide_message_by_pid(widget.projectId.toString());
      List<dynamic> jsonResponse = jsonDecode(response);
      setState(() {
        _guideMessagesMessages = List<Map<String, dynamic>>.from(jsonResponse);

      });
    } catch (e) {
      // Handle errors here
      print('Error fetching project details: $e');
    }
  }

  Future<void> _fetchData() async {
    try {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('username') ?? '';
      String response = await _apiService.get_all_guides();
      List<dynamic> jsonResponse = jsonDecode(response);
      setState(() {
        _guides = List<Map<String, dynamic>>.from(jsonResponse);
        Map<String, dynamic> selectStaff = {'staff_id': '', 'name': 'Select Staff'};
        _guides.insert(0, selectStaff);
      });
    } catch (e) {
      // Handle errors here
      print('Error fetching guides: $e');
    }
  }
  Future<void> _fetchGuideDetails() async {
    try {
      String response = await _apiService.get_all_guides_by_pid(widget.projectId.toString());
      List<dynamic> jsonResponse = jsonDecode(response);
      setState(() {
        _guideDetails = List<Map<String, dynamic>>.from(jsonResponse);
      });
    } catch (e) {
      // Handle errors here
      print('Error fetching guide details: $e');
    }
  }

  Future<void> _saveSelectedGuide(BuildContext context) async {
    // Implement logic to save selected guide ID
    print('Selected guide ID: $_selectedGuideId');
    String projectId = widget.projectId.toString();
    ApiService apiService = ApiService();
    try {
      String group_response = await apiService.add_project_guide(projectId, _selectedGuideId);
      Map<String, dynamic> data = jsonDecode(group_response);
      if( data['status']==true){


        ApiService.ShowMessage(context, "Message", data['message']);
        _fetchGuideDetails();
        //  Navigator.push(
        //      context,
        //      MaterialPageRoute(builder: (context) => )
      }
      else{
        ApiService.ShowMessage(context, "Error", data['message']);
      }
    } catch (e) {
      // Handle error
      print('Data entry errormmm: $e');
      ApiService.ShowMessage(context, "Error", 'An error occurred while data entry. Please try again later.');

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _projectDetails.isNotEmpty ? _projectDetails['project_title'] : '', // Show project title
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
      body: Column(
        children: [
          if (_showRequestButton) // Only display the "Request a Guide" button if the project status is "Accepted"
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Select a Guide'),
                      content: DropdownButtonFormField(
                        items: _guides.map((guide) {
                          return DropdownMenuItem(
                            value: guide['staff_id'],
                            child: Text(guide['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGuideId = value.toString();
                          });
                        },
                        value: _selectedGuideId,
                        decoration: InputDecoration(
                          labelText: 'Guide',
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _saveSelectedGuide(context);
                            Navigator.of(context).pop();
                          },
                          child: Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Request a Guide'),
            ),
          if (_projectDetails.isNotEmpty && _projectDetails['status']=='Send')
            Text("Please wait, your project is not approved by project coordinator ", style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),),
          if (_projectDetails.isNotEmpty && _projectDetails['status']=='Refused')
            Text("your project is rejected by project coordinator "),
            Text(_projectDetails['remarks'], style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),),

          Expanded(
            child: ListView.builder(
              itemCount: _guideDetails.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> guide = _guideDetails[index];
                return ListTile(
                  title: Text('Staff Name: ${guide['name']}'),
                  subtitle: Text('Status: ${guide['status']}\nRemarks: ${guide['remarks'] ?? 'No remarks'}'),
                );
              },
            ),
          ),
    Expanded(
    child:ListView.builder(
            itemCount: _guidealertMessages.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> alert = _guidealertMessages[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    "IMPORTANT ALERTS",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Message: ${alert['message']}"),
                      Text("Posted Date: ${alert['posted_date']}"),
                      Text("End Date: ${alert['end_date']}"),
                    ],
                  ),
                ),
              );
            },
          )
    ),

          Expanded(
              child:ListView.builder(
                itemCount: _guideMessagesMessages.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> alert = _guideMessagesMessages[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        "MESSAGES FROM GUIDE",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Message: ${alert['content']}"),
                          Text("Posted Date: ${alert['posted_date']}"),

                        ],
                      ),
                    ),
                  );
                },
              )
          )

        ],
      ),
    );
  }
}
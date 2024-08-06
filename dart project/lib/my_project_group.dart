import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:untitled/api_service.dart'; // Assuming ApiService is in a file named api_service.dart
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/create_group.dart';

class MyProjectGroup extends StatefulWidget {
  @override
  _MyProjectGroupState createState() => _MyProjectGroupState();
}

class _MyProjectGroupState extends State<MyProjectGroup> {
  String _loggedInUserEmail = '';
  bool _isLoading = true;
  bool _hasGroup = false;
  String _groupName = '';
  String _group_id='';
  String selected_student_email='';
  String? _selectedValue;
  List<dynamic> _teamMembers = [];

  @override
  void initState() {
    super.initState();
    _selectedValue = ''; // Initialize _selectedValue
    _fetchData();
  }

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('username') ?? '';
    setState(() {
      _loggedInUserEmail = email;
    });

    try {
      String response = await ApiService().get_project_group_members(email);
      Map<String, dynamic> data = jsonDecode(response);
      bool status = data['status'];
      if (status) {
        setState(() {
          _hasGroup = true;
          _groupName = data['group']['group_title'];
          _group_id = data['group']['group_id'].toString();
          _teamMembers = data['team_members'];
        });
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Project Group'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasGroup
          ? _buildGroupDetails()
          : _buildCreateGroupButton(),
    );
  }

  Widget _buildGroupDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            _groupName,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TEAM MEMBERS',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _showAddMemberDialog();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _teamMembers.length,
            itemBuilder: (context, index) {
              final member = _teamMembers[index];
              return ListTile(
                title: Text(member['student_name']),
                subtitle: Text(member['register_no']),
                // Add more details if needed
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCreateGroupButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Navigate to another form to create a group
          // Example:
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroup()));

        },
        child: Text('Create Group'),
      ),
    );
  }



  void _showAddMemberDialog() {
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          title: Text("Add Team Member"),
          contentPadding: EdgeInsets.all(16.0), // Add padding to the content
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder(
                    future: _getAllStudents(),
                    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<dynamic> students = snapshot.data!;
                        students.insert(0, {'email': '', 'student_name': 'Select Student'});
                        return DropdownButton<String>(
                          isExpanded: true, // Expand dropdown to fit content
                          value: _selectedValue,
                          items: students.map((student) {
                            return DropdownMenuItem<String>(
                              value: student['email'],
                              child: Text(student['student_name']),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _selectedValue = value;
                            });
                          },
                        );
                      }
                    },
                  ),
                  SizedBox(height: 16.0), // Add space between dropdown and selected value text
                  Text(
                    'Selected Value: ${_selectedValue ?? "None"}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Add logic to save the selected value
                print(_selectedValue!);
                Navigator.of(context).pop();
                String group_member_response = await ApiService().add_group_member(_group_id, _selectedValue!);
                Map<String, dynamic> data1 = jsonDecode(group_member_response);
                ApiService.ShowMessage(_context, "Message", data1['message']);
                _fetchData();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<List<dynamic>> _getAllStudents() async {
    try {
      String response = await ApiService().get_all_student(_loggedInUserEmail);
      List<dynamic> data = jsonDecode(response);
      return data;
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }
}

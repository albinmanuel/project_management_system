import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitled/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  String _groupName = '';
  String _loggedInUserEmail = '';


  @override
  void initState() {
    super.initState(); // Initialize _selectedValue
    _fetchData();
  }

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('username') ?? '';
    setState(() {
      _loggedInUserEmail = email;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Group Name'),
              onChanged: (value) {
                setState(() {
                  _groupName = value;
                });
              },
            ),
            SizedBox(height: 20.0),

            ElevatedButton(
              onPressed: () {
                _add_group(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _add_group(BuildContext context) async {
    ApiService apiService = ApiService();
    try {
      String group_response = await apiService.add_group(_groupName, _loggedInUserEmail);
      Map<String, dynamic> data = jsonDecode(group_response);
      if( data['status']==true){

        String group_id=data['group_id'].toString();
        String group_member_response = await apiService.add_group_member(group_id, _loggedInUserEmail);
        Map<String, dynamic> data1 = jsonDecode(group_member_response);
        ApiService.ShowMessage(context, "Message", data1['message']);

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




}
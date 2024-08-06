import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/ShowStaffTechnologies.dart';
import 'package:untitled/api_service.dart'; // Import your ApiService class

class ShowStaff extends StatefulWidget {
  @override
  _ShowStaffState createState() => _ShowStaffState();
}

class _ShowStaffState extends State<ShowStaff> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _staffList = [];

  @override
  void initState() {
    super.initState();
    _fetchStaff();
  }

  Future<void> _fetchStaff() async {
    try {
      String response = await _apiService.get_all_guides();
      List<dynamic> jsonResponse = jsonDecode(response);
      setState(() {
        _staffList = List<Map<String, dynamic>>.from(jsonResponse);
      });
    } catch (e) {
      // Handle errors here
      print('Error fetching staff: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Staff List'),
      ),
      body: ListView.builder(
        itemCount: _staffList.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> staff = _staffList[index];
          return ListTile(
            title: Text(staff['name']),
            onTap: () {
              // Navigate to ShowStaffTechnologies and pass staff_id
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowStaffTechnologies(staffId: staff['staff_id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

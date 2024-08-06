import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/api_service.dart';

class ShowStaffTechnologies extends StatefulWidget {
  final int staffId;

  ShowStaffTechnologies({required this.staffId});

  @override
  _ShowStaffTechnologiesState createState() => _ShowStaffTechnologiesState();
}

class _ShowStaffTechnologiesState extends State<ShowStaffTechnologies> {
  Map<String, dynamic> _staffDetails = {};
  List<Map<String, dynamic>> _staffTechnologies = [];

  @override
  void initState() {
    super.initState();
    _fetchStaffDetails();
    _fetchStaffTechnologies();
  }

  Future<void> _fetchStaffDetails() async {

      String response = await ApiService().get_staff_by_staff_id(widget.staffId.toString());
      Map<String, dynamic> jsonResponse = jsonDecode(response);

        setState(() {
          _staffDetails = jsonResponse;
        });
      }

  Future<void> _fetchStaffTechnologies() async {
        try {
      String response = await ApiService().get_staff_technologies_by_staff_id(widget.staffId.toString());

        List<dynamic> jsonResponse = jsonDecode(response);
        setState(() {
          _staffTechnologies = List<Map<String, dynamic>>.from(jsonResponse);
        });

    } catch (e) {
      print('Error fetching staff technologies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Technologies'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Staff Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: Text('Name: ${_staffDetails['name'] ?? ''}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Address: ${_staffDetails['address'] ?? ''}'),
                Text('Phone: ${_staffDetails['phone'] ?? ''}'),
                Text('Email: ${_staffDetails['email'] ?? ''}'),
                Text('Gender: ${_staffDetails['gender'] ?? ''}'),
                Text('Status: ${_staffDetails['status'] ?? ''}'),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Technologies',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _staffTechnologies.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> technology = _staffTechnologies[index];
                return ListTile(
                  title: Text(technology['tech_name'] ?? ''),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

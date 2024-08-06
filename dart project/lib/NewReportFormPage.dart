import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
class NewReportFormPage extends StatefulWidget {
  final String project_id;
  NewReportFormPage({required this.project_id});

  @override
  _ReportFormPageState createState() => _ReportFormPageState();
}

class _ReportFormPageState extends State<NewReportFormPage> {
  final TextEditingController _reportTitleController = TextEditingController();
   String _selectedFilePath='';

  late  Uint8List uint8list;

  void _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final bytes = result.files.single.bytes;
      if (bytes != null) {
        final fileBytes = bytes.toList();
        final fileName = result.files.single.name;

        setState(() {
           uint8list = Uint8List.fromList(fileBytes);
          _selectedFilePath = fileName;
          print(_selectedFilePath);
        });
      } else {
        print('No file selected');
      }
    }
  }


  Future<void> _saveReport(BuildContext context) async {
    if (_reportTitleController.text.isEmpty ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter report title and select PDF file')),
      );
      return;
    }

    String apiUrl = 'http://127.0.0.1:8000/upload_report'; // Replace with your API endpoint
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['report_title'] = _reportTitleController.text;
      request.fields['project_id'] = widget.project_id.toString();

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          uint8list,
          filename: _selectedFilePath,
        ),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report saved successfully')),
        );
        // Clear form fields and selected file
        _reportTitleController.clear();
        setState(() {

          _selectedFilePath = '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save report. Please try again.')),
        );
      }
    } catch (e) {
      print('Error saving report: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Report Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _reportTitleController,
              decoration: InputDecoration(labelText: 'Report Title'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _pickPDF,
              child: Text('Select PDF File'),
            ),
            SizedBox(height: 8.0),
            _selectedFilePath != null
                ? Text('Selected File: $_selectedFilePath')
                : SizedBox(),
            Spacer(),
            ElevatedButton(
              onPressed: () => _saveReport(context),
              child: Text('Save Report'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:untitled/MyProjectsWidget.dart';
import 'package:untitled/ShowReportList.dart';
import 'package:untitled/ShowStaff.dart';
import 'package:untitled/ShowTaskList.dart';
import 'package:untitled/create_group.dart';
import 'package:untitled/create_project_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/main.dart';
import 'package:untitled/my_project_group.dart';





class UserDashboard extends StatefulWidget {
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  Future<String> loggedInUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? ''; // Return empty string if username is null
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Dashboard'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: FutureBuilder<String>(
                future: loggedInUsername(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Display loading indicator while fetching username
                  } else {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return Text(
                        snapshot.data!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      );
                    } else {
                      return Text(
                        'Guest', // Show 'Guest' if username is not available
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      );
                    }
                  }
                },
              ),
            ),
            ListTile(
              title: Text('Project Group'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyProjectGroup()),
                );
              },
            ),
            ListTile(
              title: Text('Create New Project'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectFormWidget()),
                );
              },
            ),
            ListTile(
              title: Text('My Projects'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyProjectsWidget()),
                );
              },
            ),
            ListTile(
              title: Text('Project Guilde List'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShowStaff()),
                );
              },
            ),
            ListTile(
              title: Text('Task List'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShowTaskList()),
                );
              },
            ),
            ListTile(
              title: Text('Project Report List'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShowReportList()),
                );
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Welcome to User Dashboard!'),
      ),
    );
  }
}

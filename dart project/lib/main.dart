import 'package:flutter/material.dart';
import 'package:untitled/api_service.dart';
import 'package:untitled/models/login_response.dart'; // Import your LoginResponse model here
import 'package:untitled/user_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _login(context);
              },
              child: Text('Login'),
            ),
            SizedBox(height: 20.0),

          ],
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;

    ApiService apiService = ApiService();
    try {
      LoginResponse response = await apiService.isAuthorizedStudent(username, password);
      // Check the status of the login response
      if (response.status) {
        // If login is successful, navigate to the user dashboard
        // Save the username globally using shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserDashboard()),
        );
      } else {
        // If login fails, show an error message
     ApiService.ShowMessage(context, "Login Failed", response.message);

      }
    } catch (e) {
      // Handle error
      print('Login error: $e');
      ApiService.ShowMessage(context, "Error", 'An error occurred while logging in. Please try again later.');

    }
  }
}

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'api_service.dart';
import 'main.dart';
import 'package:campusalert/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _username;
  String? _password;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _username = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _login(
                    () => Navigator.pushReplacementNamed(context, '/main_app'),
                    appState);
              },
              child: Text('Login'),
            ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> _autoLogin() async {
    // Attempt to automatically log in using past stored user session. If the user is logged out, nothing happens and false is returned
    // This is called when the app first land on the login screen
    try {
      (await Credential.getLastCredential()).login();
      return true;
    } on LastCredentialMissingException {
      return false;
    }
  }

  void _login(VoidCallback onSuccess, AppState appState) async {
    // Implement the login logic here
    // You can validate the username and password, make API requests, etc.

    if (_username == null || _username == '') {
      setState(() {
        _errorMessage = 'Please enter the username';
      });
      return;
    }

    if (_password == null || _password == '') {
      setState(() {
        _errorMessage = 'Please enter the password';
      });
      return;
    }

    var credential =
        Credential(user: User(username: _username!), password: _password!);

    try {
      await credential.login();
      onSuccess();
    } on LoginFailedException {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });

      return;
    }
  }
}

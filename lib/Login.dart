import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show jsonEncode, json, base64, ascii;
import 'main.dart';
import 'Home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _selectedUserRole = 'ADMIN'; // Default selected value

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late double screenWidth, screenHeight;

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  Future<String> attemptLogIn(String username, String password) async {
    var res = await http.post(
      Uri.parse(
          '$SERVER_IP/login'), // or '$SERVER_IP/signup' based on your endpoint
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, // Set the content type
      body: 'username=' +
          username +
          '&password=' +
          password +
          '&type=' +
          _selectedUserRole,
    );
    if (res.statusCode == 200) return res.body;
    return "jwt";
  }

  Future<String> attemptSignUp(String username, String password) async {
    var res = await http.post(
      Uri.parse('$SERVER_IP/signup'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, // Set the content type
      body: 'username=' +
          username +
          '&password=' +
          password +
          '&type=' +
          _selectedUserRole,
    );
    return res.body;
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios_new),
          title: Text("BLean LogIn"),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 0.08 * screenWidth,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DropdownButton<String>(
                value: _selectedUserRole,
                style: const TextStyle(color: Colors.black),
                padding: EdgeInsets.symmetric(horizontal: 75),
                dropdownColor: Colors.orange[200],
                isExpanded: true,
                items: <String>['USER', 'ADMIN'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUserRole = newValue ?? "";
                  });
                },
              ),
              SizedBox(
                height: 0.05 * screenHeight,
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  icon: Icon(Icons.perm_identity_sharp),
                  iconColor: Colors.orange[600],
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.lock_open_sharp),
                  iconColor: Colors.orange[600],
                ),
              ),
              SizedBox(
                height: 0.06 * screenHeight,
              ),
              ElevatedButton(
                onPressed: () async {
                  var username = _usernameController.text;
                  var password = _passwordController.text;
                  var jwt = await attemptLogIn(username, password);

                  displayDialog(context, "Login Button", jwt);

                  if (jwt != null) {
                    storage.write(key: "jwt", value: jwt ?? "");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage.fromBase64(jwt)));
                  } else {
                    displayDialog(context, "An Error Occurred",
                        "No account was found matching that username and password");
                  }
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.orange[600],
                    ),
                    minimumSize: MaterialStateProperty.all(
                        Size(screenWidth * 0.75, screenHeight * 0.05))),
                child: const Text(
                  "Log In",
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
              SizedBox(
                height: 0.02 * screenHeight,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                      onPressed: () async {
                        var username = _usernameController.text;
                        var password = _passwordController.text;

                        if (username.length < 4)
                          displayDialog(context, "Invalid Username",
                              "The username should be at least 4 characters long");
                        else if (password.length < 4)
                          displayDialog(context, "Invalid Password",
                              "The password should be at least 4 characters long");
                        else {
                          var res = await attemptSignUp(username, password);
                          if (res == "\"ok\"")
                            displayDialog(context, "Success",
                                "The user was created. Log in now.");
                          else if (res == "409")
                            displayDialog(
                                context,
                                "That username is already registered",
                                "Please try to sign up using another username or log in if you already have an account.");
                          else {
                            displayDialog(
                                context, "Error", "An unknown error occurred.");
                          }
                        }
                      },
                      child: Text("Sign Up")),
                ],
              ),
              SizedBox(
                height: 0.1 * screenHeight,
              ),
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show jsonEncode , json, base64, ascii;
import 'main.dart';
import 'Home.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );

  Future<String> attemptLogIn(String username, String password) async {
    var res = await http.post(
      Uri.parse('$SERVER_IP/login'), // or '$SERVER_IP/signup' based on your endpoint
      headers: {'Content-Type': 'application/x-www-form-urlencoded'}, // Set the content type
      body: 'username='+username+'&password='+password,
    );
    if(res.statusCode == 200) return res.body;
    return "jwt";
  }

  Future<String> attemptSignUp(String username, String password) async {
    var res = await http.post(
      Uri.parse('$SERVER_IP/signup'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'}, // Set the content type
      body: 'username='+username+'&password='+password,
    );
    return res.body;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Log In"),),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    labelText: 'Username'
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password'
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;
                    var jwt = await attemptLogIn(username, password);
                    if(jwt != null) {
                      storage.write(key: "jwt", value: jwt ?? "");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage.fromBase64(jwt)
                          )
                      );
                    } else {
                      displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                    }
                  },
                  child: Text("Log In")
              ),
              ElevatedButton(
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;

                    if(username.length < 4)
                      displayDialog(context, "Invalid Username", "The username should be at least 4 characters long");
                    else if(password.length < 4)
                      displayDialog(context, "Invalid Password", "The password should be at least 4 characters long");
                    else{
                      var res = await attemptSignUp(username, password);
                      if(res == "\"ok\"")
                        displayDialog(context, "Success", "The user was created. Log in now.");
                      else if(res == "409")
                        displayDialog(context, "That username is already registered", "Please try to sign up using another username or log in if you already have an account.");
                      else {
                        displayDialog(context, "Error", "An unknown error occurred.");
                      }
                    }
                  },
                  child: Text("Sign Up")
              )
            ],
          ),
        )
    );
  }
}
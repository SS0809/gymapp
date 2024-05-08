import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show jsonEncode , json, base64, ascii;
import 'package:gymapp/Login.dart';
import 'package:gymapp/Home.dart';

const SERVER_IP = 'https://tahr-eminent-exactly.ngrok-free.app';
//const SERVER_IP = 'http://ec2-54-89-201-209.compute-1.amazonaws.com:8080';

final storage = FlutterSecureStorage();

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home :FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(); // If data is not available, show a loading indicator
            }
            if (snapshot.data != "") {
              var str = snapshot.data;
              Map<String, dynamic> data = json.decode(str ?? "");
              var token = data['token'];

              var jwt = str?.split(".");
              if (jwt?.length != 3) {
                return LoginPage(); // If the JWT token is invalid or empty, redirect to the LoginPage
              } else {
                var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt?[1] ?? ""))));
                if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000).isAfter(DateTime.now())) {
                  return HomePage(token ?? "", payload); // If the token is valid and not expired, show the HomePage
                } else {
                  return LoginPage(); // If the token is expired, redirect to the LoginPage
                }
              }
            } else {
              return LoginPage(); // If data is empty, redirect to the LoginPage
            }
          }
      ),

    );
  }
}






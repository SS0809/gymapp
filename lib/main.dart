import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show jsonEncode , json, base64, ascii;
import '../Login.dart';
import '../Home.dart';
import '../plans/plans_edit.dart';
import '../plans/PlanSelection.dart';
import 'package:permission_handler/permission_handler.dart';

const SERVER_IP = 'https://tahr-eminent-exactly.ngrok-free.app';
//const SERVER_IP = 'http://ec2-54-89-201-209.compute-1.amazonaws.com:82';

final storage = FlutterSecureStorage();


Future<void> requestPermissions() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}



void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }
  /*
  List<Plan> _plans = [
    Plan(type:"Beta",price:8000,validity:30),
    Plan(type:"Beta",price:8000,validity:30),
    Plan(type:"Beta",price:8000,validity:30),
  ]; // If data is empty, redirect to the LoginPage
   */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication Demo',
      theme: ThemeData.dark(),
      home :FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(); // If data is not available, show a loading indicator
            }
            if (snapshot.data != "") {
              var str = snapshot.data;
              print(str);
              var jwt = str?.split(".");
              requestPermissions();
              if (jwt?.length != 3) {
                return LoginPage(); // If the JWT token is invalid or empty, redirect to the LoginPage
              } else {
                var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt?[1] ?? ""))));
                if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000).isAfter(DateTime.now())) {
                  return HomePage(str ?? "", payload); // If the token is valid and not expired, show the HomePage
                } else {
                  return LoginPage(); // If the token is expired, redirect to the LoginPage
                }
              }
            } else {
              // test for editplanspage
              // return EditPlansPage(plans: _plans);
               return LoginPage();
              // return PlanSelectionPage();
            }
          }
      ),

    );
  }
}

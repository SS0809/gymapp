import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'main.dart';
import 'Login.dart';

class HomePage extends StatelessWidget {
  HomePage(this.jwt, this.payload);

  factory HomePage.fromBase64(String jwt) {
    if (jwt == null || jwt.isEmpty) {
      throw ArgumentError('JWT string is null or empty');
    }

    var jwtParts = jwt.split(".");
    if (jwtParts.length < 2) {
      throw ArgumentError('Invalid JWT string format');
    }

    var payload = json.decode(
        ascii.decode(
            base64.decode(base64.normalize(jwtParts[1]))
        )
    );

    return HomePage(jwt, payload);
  }

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Secret Data Screen")),
      body: Center(
        child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("An error occurred: ${snapshot.error}");
            } else if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  Text("${payload['username']}, here's the data:"),
                  ElevatedButton(
                    onPressed: () async {
                      await storage.delete(key: "jwt");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text("LOGOUT"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var res = await http.post(
                        Uri.parse('$SERVER_IP/add'),
                        headers: {
                          'Authorization': jwt,
                          'Content-Type': 'application/json',
                        },
                      );
                    },
                    child: Text("Count++"),
                  ),
                  Text((snapshot.data) ?? ""),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Future<String> fetchData() async {
    var res = await http.get(
      Uri.parse('$SERVER_IP/data'),
      headers: {
        'Authorization': jwt,
        'Content-Type': 'application/json',
      },
    );
    return res.body;
  }
}

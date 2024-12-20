import 'package:flutter/material.dart';
import 'package:gym_app/Home.dart';
import 'package:gym_app/main.dart';
import 'package:gym_app/User/users_edit.dart';
import 'package:gym_app/Login.dart';
import 'dart:convert'; // Import to decode JWT
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSelectionPage extends StatefulWidget {
  late List<User> users;
  final Function(List<User>) onUpdateUsers;
  UserSelectionPage({
    required this.users,
    required this.onUpdateUsers,
  });

  @override
  State<UserSelectionPage> createState() => _UserSelectionPageState();
}

class _UserSelectionPageState extends State<UserSelectionPage> {
  late double deviceHeight;
  late double deviceWidth;
  String? jwt, typeuser;
  Color? currentColor;

  final storage = FlutterSecureStorage(); // Initialize storage

  @override
  void initState() {
    super.initState();
  }

  Future<void> _initAsync() async {
    jwt = await storage.read(key: "jwt");
    typeuser = await storage.read(key: "type");
    typeuser = json.decode(typeuser!)["type"];
    await fetchColor();
  }

  Future<void> fetchColor() async {
    String colorValue = await storage.read(key: "color") ?? "FF1A1A1A";
    setState(() {
      currentColor = Color(int.parse(colorValue, radix: 16));
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: _initAsync(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Featured Users'),
              backgroundColor: Color(0xFF1A1A1A),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                  );
                },
              ),
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: deviceHeight * 0.4,
                  left: deviceWidth * 0.08,
                  right: deviceWidth * 0.08,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: deviceHeight * 0.03,
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.users.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Container(
                                height: 80,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: currentColor ?? Color(0xFF05AADC),
                                  borderRadius: BorderRadius.circular(31.0),
                                ),
                                child: Center(
                                  child: Text(
                                    widget.users[index].username,
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: deviceHeight * 0.02,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.009,
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: (typeuser != null && (typeuser == "ADMIN"))
                ? FloatingActionButton(
              elevation: 0.0,
              child: Icon(Icons.edit),
              backgroundColor: currentColor ?? Color(0xFF05AADC),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUsersPage(
                      users: widget.users,
                      onUpdateUsers: (updatedUsers) {
                        setState(() {
                          widget.onUpdateUsers(updatedUsers);
                        });
                      },
                    ),
                  ),
                );
              },
            )
                : null,
          );
        } else {
          return Center(child: Text('Error loading data'));
        }
      },
    );
  }
}

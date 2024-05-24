import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../User/userselection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../User/users_edit.dart';
import '../main.dart';
import '../Login.dart';

/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit Users',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EditUsersPage(),
    );
  }
}
*/

class User {
  String id;
  String type;
  String password;
  String username;

  User(
      {required this.id,
      required this.type,
      required this.password,
      required this.username});
}

class EditUsersPage extends StatefulWidget {
  final List<User> users;
  final Function(List<User>) onUpdateUsers;

  EditUsersPage({
    required this.users,
    required this.onUpdateUsers,
  });

  @override
  _EditUsersPageState createState() => _EditUsersPageState();
}

class _EditUsersPageState extends State<EditUsersPage> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Users'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UserSelectionPage(
                    users: widget.users,
                    onUpdateUsers: (updatedUsers) {
                      setState(() {
                        updatedUsers = widget.users;
                      });
                      print(widget.users);
                    },
                  ),
                ),
              );
            },
            child: Text("Back"),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: widget.users.length + 1, // Add one for the add button
          itemBuilder: (BuildContext context, int index) {
            if (index == widget.users.length) {
              return ElevatedButton(
                onPressed: () {
                  _showAddUserDialog(context);
                },
                child: Text("Add User"),
              );
            } else {
              return UserItem(
                users: widget.users,
                username: widget.users[index],
                onUpdate: (updatedUser) {
                  setState(() {
                    widget.users[index] = updatedUser;
                  });
                },
                onUpdateUsers: widget.onUpdateUsers,
              );
            }
          },
        ),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addElementToList(
                  _nameController.text,
                  _typeController.text!,
                 _passwordController.text!,
                );
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  /* Future<String> createuser(int billable_amount , String month , String username , String userid) async {
    print(await jwtOrEmpty);
    var res = await http.post(
      Uri.parse('$SERVER_IP/createuser'),
      headers: {
        'Authorization': json.decode(await jwtOrEmpty)["token"],
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'billable_amount':billable_amount,
        'month':month,
        'username':username,
        'userid':userid
      },
    );
    print(res.body);
    return res.body;
  }*/
  Future<String> createuser(
      String user_user, String user_type , String user_password) async {
    print(await jwtOrEmpty);
    var res = await http.post(
      Uri.parse('$SERVER_IP/createuser'),
      headers: {
        'Authorization': json.decode(await jwtOrEmpty)["token"],
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'username': user_user.toString(),
        'password': user_password.toString()
      },
    );
    print(res.body);
    print(res.statusCode);
    return res.statusCode.toString();
  }

  void _addElementToList(String a1, String a2, String a3) async {
    var res = await createuser(a1, a2, a3);
    if (res == "200") {
      //new created
      setState(() {
        widget.users.add(
          User(id: "1000", type: a1, username: a2, password: a3),
        );
      });
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('New User Created'),
          action: SnackBarAction(
              label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    } else if (res == "201") {
      //username already exits
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('New User already exits'),
          /*action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),*/
        ),
      );
    }
  }
}

class UserItem extends StatefulWidget {
  final List<User> users;
  final User username;
  final Function(User) onUpdate;
  final Function(List<User>) onUpdateUsers;

  UserItem({
    required this.users,
    required this.username,
    required this.onUpdate,
    required this.onUpdateUsers,
  });

  @override
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  late TextEditingController _typeController;
  late TextEditingController _userController;
  late TextEditingController _passwordController;
  bool _isEditing = false;
  Future<String> updateuser(String id,
      String user_type, String user_user, String user_password) async {
    print(await jwtOrEmpty);
    var res = await http.post(
      Uri.parse('$SERVER_IP/updateuser'),
      headers: {
        'Authorization': json.decode(await jwtOrEmpty)["token"],
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'id':widget.username.id,
        'user_type': user_type,
        'user_user': user_user.toString(),
        'user_password': user_password.toString()
      },
    );
    print(res.body);
    print(res.statusCode);
    return res.statusCode.toString();
  }
  @override
  void initState() {
    super.initState();
    _typeController = TextEditingController(text: widget.username.type);
    _userController =
        TextEditingController(text: widget.username.username.toString());
    _passwordController =
        TextEditingController(text: widget.username.password.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          controller: _userController,
          enabled: _isEditing,
          decoration: InputDecoration(labelText: 'username'),
        ),
        SizedBox(height: 20.0),
        TextField(
          controller: _typeController,
          enabled: _isEditing,
          decoration: InputDecoration(labelText: 'TYPE'),
        ),
        SizedBox(height: 20.0),
        TextField(
          controller: _passwordController,
          enabled: _isEditing,
          decoration: InputDecoration(labelText: 'password'),
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed:  () async {
                if (_isEditing) {
                  await updateuser(widget.username.id,   _typeController.text, _userController.text, _passwordController.text);
                  }
                setState(() {
                  if (_isEditing) {
                    widget.onUpdate(
                      User(
                        id: widget.username.id,
                        type: _typeController.text,
                        username: _userController.text,
                        password: _passwordController.text,
                      ),
                    );
                  }
                  _isEditing = !_isEditing;
                });
              },
              child: Text(_isEditing ? 'Save' : 'Edit'),
            ),
            SizedBox(width: 90.0),
            ElevatedButton(
              onPressed: _isEditing
                  ? null
                  : () {
                      _removeUserAndUpdateList(widget.username.username);
                      deleteuser(widget.username.username);
                      onUpdateUsers:
                      (updatedUsers) {
                        setState(() {
                          widget.onUpdateUsers(updatedUsers);
                        });
                      };
                      print(widget.users);
                    },
              child: Text('Delete'),
            )
          ],
        ),
        Divider(),
      ],
    );
  }

  void _removeUserAndUpdateList(String name) {
    setState(() {
      int indexToRemove = widget.users.indexWhere((username) => username.username == name);
      if (indexToRemove != -1) {
        widget.users.removeAt(indexToRemove);
        // Call onUpdate after removing the username
        widget.onUpdate(widget.username);
      }
    });
  }

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  Future<String> deleteuser(String idd) async {
    print(idd);
    print(await jwtOrEmpty);
    var res = await http.post(
      Uri.parse('$SERVER_IP/deleteuser'),
      headers: {
        'Authorization': json.decode(await jwtOrEmpty)["token"],
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'username': idd,
      },
    );
    print(res.body);
    return res.body;
  }

  @override
  void dispose() {
    _typeController.dispose();
    _userController.dispose();
    super.dispose();
  }
}

//TODO add a top bar navigation to go back to PLanselection.dart

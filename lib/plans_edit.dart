import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymapp/PlanSelection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gymapp/plans_edit.dart';
import 'main.dart';
import 'Login.dart';



/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit Plans',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EditPlansPage(),
    );
  }
}
*/

class Plan {
  String id;
  String type;
  int price;
  int validity;

  Plan({required this.id, required this.type, required this.price, required this.validity});
}


class EditPlansPage extends StatefulWidget {
  final List<Plan> plans;
  final Function(List<Plan>) onUpdatePlans;

  EditPlansPage({
    required this.plans,
    required this.onUpdatePlans,
  });

  @override
  _EditPlansPageState createState() => _EditPlansPageState();
}

class _EditPlansPageState extends State<EditPlansPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Plans'),
        actions: [
          /*IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),*/
          ElevatedButton(
            onPressed: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>   PlanSelectionPage(plans: widget.plans,
                  onUpdatePlans: (updatedPlans) {
                    setState(() {
                      updatedPlans = widget.plans;
                    });
                    print(widget.plans);
                  },),
                ),);
            },
            child: Text("Save"),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: widget.plans.length + 1, // Add one for the add button
          itemBuilder: (BuildContext context, int index) {
            if (index == widget.plans.length) {
              return ElevatedButton(
                onPressed: () {
                  _addElementToList();
                },
                child: Text("Add Plan"),
              );
            } else {
              return PlanItem(
                plans: widget.plans,
                plan: widget.plans[index],
                onUpdate: (updatedPlan) {
                  setState(() {
                    widget.plans[index] = updatedPlan;
                  });
                },
                onUpdatePlans: widget.onUpdatePlans,
              );
            }
          },
        ),
      ),
    );
  }

  void _addElementToList() {
    setState(() {
      widget.plans.add(Plan(id:"1000",type:"Beta",price:8000,validity:30),);
    });
  }
}

class PlanItem extends StatefulWidget {
  final List<Plan> plans;
  final Plan plan;
  final Function(Plan) onUpdate;
  final Function(List<Plan>) onUpdatePlans;

  PlanItem({
    required this.plans,
    required this.plan,
    required this.onUpdate,
    required this.onUpdatePlans,
  });

  @override
  _PlanItemState createState() => _PlanItemState();
}

class _PlanItemState extends State<PlanItem> {
  late TextEditingController _typeController;
  late TextEditingController _priceController;
  late TextEditingController _validityController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _typeController = TextEditingController(text: widget.plan.type);
    _priceController = TextEditingController(text: widget.plan.price.toString());
    _validityController = TextEditingController(text: widget.plan.validity.toString());

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          controller: _typeController,
          enabled: _isEditing,
          decoration: InputDecoration(labelText: 'Name'),
        ),
        SizedBox(height: 20.0),
        TextField(
          controller: _priceController,
          enabled: _isEditing,
          decoration: InputDecoration(labelText: 'Age'),
        ),
        SizedBox(height: 20.0),
        TextField(
          controller: _validityController,
          enabled: _isEditing,
          decoration: InputDecoration(labelText: 'Validity'),
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_isEditing) {
                    widget.onUpdate(
                      Plan(
                        id: widget.plan.id,
                        type: _typeController.text,
                        price: int.parse(_priceController.text),
                        validity: int.parse(_validityController.text),
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
              onPressed: _isEditing ? null : () {
                _removePlanAndUpdateList(widget.plan.type);
                 deleteplan(widget.plan.id);
                  onUpdatePlans: (updatedPlans) {
                    setState(() {
                      widget.onUpdatePlans(updatedPlans);
                    });
                  };
                  print(widget.plans);
              },
              child: Text('Delete'),
            )
          ],
        ),
        Divider(),
      ],
    );
  }

  void _removePlanAndUpdateList(String name) {
    setState(() {
      int indexToRemove = widget.plans.indexWhere((plan) => plan.type == name);
      if (indexToRemove != -1) {
        widget.plans.removeAt(indexToRemove);
        // Call onUpdate after removing the plan
        widget.onUpdate(widget.plan);
      }
    });
  }
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }

    Future<String> deleteplan(String idd) async {
            print(idd);
      print(await jwtOrEmpty);
    var res = await http.post(
      Uri.parse('$SERVER_IP/deleteplan'),
      headers: {
        'Authorization': json.decode(await jwtOrEmpty)["token"],
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'id': idd,
      },
    );
    print(res.body);
    return res.body;
  }




  @override
  void dispose() {
    _typeController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}



//TODO add a top bar navigation to go back to PLanselection.dart

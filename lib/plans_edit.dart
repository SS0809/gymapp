import 'package:flutter/material.dart';
import 'package:gymapp/PlanSelection.dart';
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
import 'package:flutter/material.dart';
import 'package:gymapp/PlanSelection.dart';

class Plan {
  String name;
  String age;

  Plan({required this.name, required this.age});
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
      widget.plans.add(Plan(name: 'New Plan', age: '25'));
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
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plan.name);
    _ageController = TextEditingController(text: widget.plan.age);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          controller: _nameController,
          enabled: _isEditing,
          decoration: InputDecoration(labelText: 'Name'),
        ),
        SizedBox(height: 20.0),
        TextField(
          controller: _ageController,
          enabled: _isEditing,
          decoration: InputDecoration(labelText: 'Age'),
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
                        name: _nameController.text,
                        age: _ageController.text,
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
                _removePlanAndUpdateList(widget.plan.name);
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
      int indexToRemove = widget.plans.indexWhere((plan) => plan.name == name);
      if (indexToRemove != -1) {
        widget.plans.removeAt(indexToRemove);
        // Call onUpdate after removing the plan
        widget.onUpdate(widget.plan);
      }
    });
  }





  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}



//TODO add a top bar navigation to go back to PLanselection.dart

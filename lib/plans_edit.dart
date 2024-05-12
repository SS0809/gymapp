import 'package:flutter/material.dart';

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
  String name;
  String age;

  Plan({required this.name, required this.age});
}

class EditPlansPage extends StatefulWidget {
  late List<Plan> plans; // Declare _plans

  EditPlansPage({
    required this.plans,
  });
  @override
  _EditPlansPageState createState() => _EditPlansPageState();
}
class _EditPlansPageState extends State<EditPlansPage> {
  List<Plan> _plans = [
    Plan(name: 'Plan 1', age: '20'),
    Plan(name: 'Plan 2', age: '25'),
    Plan(name: 'Plan 3', age: '30'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Plans'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: _plans.length,
          itemBuilder: (BuildContext context, int index) {
            return PlanItem(
              plans:_plans,
              plan: _plans[index],
              onUpdate: (updatedPlan) {
                setState(() {
                  _plans[index] = updatedPlan;
                });
              },
              onUpdatePlans: (updatedPlans) {
                setState(() {
                  _plans = updatedPlans;
                });
              },
            );
          },
        ),
      ),
    );
  }
}

class PlanItem extends StatefulWidget {
  late List<Plan> plans; // Declare _plans here
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
        widget.onUpdatePlans(widget.plans);
      }
      print(widget.plans);
      print(widget.plan);

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
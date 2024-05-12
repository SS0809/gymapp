import 'package:flutter/material.dart';
import 'package:gymapp/Home.dart';
import 'package:gymapp/main.dart';
import 'package:gymapp/plans_edit.dart';
import 'package:gymapp/Login.dart';
class PlanSelectionPage extends StatefulWidget {
  late List<Plan> plans;
  final Function(List<Plan>) onUpdatePlans;
  PlanSelectionPage({
    required this.plans,
    required this.onUpdatePlans,
  });

  @override
  State<PlanSelectionPage> createState() => _PlanSelectionPageState();
}

class _PlanSelectionPageState extends State<PlanSelectionPage> {
  late double deviceHeight;
  late double deviceWidth;
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text('Featured Plans'), backgroundColor: Color(0xFF05AADC)),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: deviceHeight * 0.06,
            horizontal: deviceWidth * 0.08,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'Select a Plan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                  );
                },
                child: Text("Go back"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditPlansPage(
                              plans: widget.plans,
                              onUpdatePlans: (updatedPlans) {
                                setState(() {
                                  widget.onUpdatePlans(updatedPlans);
                                });
                              },
                            )),
                  );
                },
                child: Text("Edit"),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.plans.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: deviceHeight * 0.04,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF05AADC),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      height: 100,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          widget.plans[index].type,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

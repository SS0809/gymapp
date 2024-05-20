import 'package:flutter/material.dart';
import 'package:gym_app/Home.dart';
import 'package:gym_app/main.dart';
import 'package:gym_app/plans/plans_edit.dart';
import 'package:gym_app/Login.dart';

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
      appBar: AppBar(
          title: Text('Featured Plans'),
          backgroundColor:  Color(0xFF1A1A1A),
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
             /* Center(
                child: Text(
                  'Select a Plan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),*/
              SizedBox(
                height: deviceHeight*0.03,
              ),

              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.plans.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFF05AADC),
                          borderRadius: BorderRadius.circular(31.0),
                        ),

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
                      SizedBox(
                        height: deviceHeight*0.02,
                      )
                    ],
                  );

                },
              ),

              // SizedBox(
              //   height: deviceHeight*0.03,
              // ),

            /*  ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange[600],
                  textStyle: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 17, horizontal: 10), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Button border radius
                  ),
                ),
                child: Text("Edit"),
              ),*/
              SizedBox(
                height: deviceHeight*0.009,
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => MyApp(),
              //       ),
              //     );
              //   },
              //   child: Text("Go back"),
              // ),
            ],
          ),
        ),
      ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.edit),
            backgroundColor: Color(0xFF05AADC),
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
        )
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gymapp/Home.dart';
import 'package:gymapp/main.dart';
import 'package:gymapp/plans/plans_edit.dart';
import 'package:gymapp/Login.dart';

class Payment {
  int billable_amount;
  String month;
  String plan;
  String userid;
  Payment(
      {required this.billable_amount,
      required this.month,
      required this.plan,
      required this.userid});
}

class PaymentPage extends StatefulWidget {
  final List<Payment> plans;
  final dynamic currentrevenue;
  final Function(List<Payment>) onUpdatePlans;

  PaymentPage({
    required this.plans,
    required this.currentrevenue,
    required this.onUpdatePlans,
  });

  @override
  State<PaymentPage> createState() => _PlanSelectionPageState();
}

class _PlanSelectionPageState extends State<PaymentPage> {
  late double deviceHeight;
  late double deviceWidth;
  late dynamic currentrevenue_total;
  late dynamic currentrevenue_year;
  late dynamic currentrevenue_month;

  @override
 void initState() {
    super.initState();
    // Parse the JSON string and extract the 'total' value
    final revenueList = jsonDecode(widget.currentrevenue);
    if (revenueList is List && revenueList.isNotEmpty) {
      currentrevenue_total = revenueList[0]['total'];
      currentrevenue_year = revenueList[0]['year'];
      currentrevenue_month = revenueList[0]['month'];
    } else {
      currentrevenue_total = 0; // Fallback value in case of an unexpected JSON structure
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text('Payments section'),
        backgroundColor: Color(0xFF00875F),
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
               Center(
                  child: Text(
                  'total revenue : '+ currentrevenue_total.toString()+'Rs.  for this month ('+currentrevenue_year.toString()+'/'+currentrevenue_month.toString() +')',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              SizedBox(
                height: deviceHeight * 0.03,
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
                          color: Color(0xFF00B37E),
                          borderRadius: BorderRadius.circular(31.0),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                widget.plans[index].billable_amount.toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.plans[index].plan.toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.plans[index].month.toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.plans[index].userid.toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
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
                height: deviceHeight * 0.009,
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
      /*    floatingActionButton: new FloatingActionButton(
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
        )*/
    );
  }
}

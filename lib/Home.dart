import 'package:flutter/material.dart';
import 'package:gymapp/plans/PlanSelection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gymapp/plans/plans_edit.dart';
import 'main.dart';
import 'Login.dart';
import 'package:gymapp/payments/payment.dart';
class Revenue {
  final int year;
  final String month;
  final double total;

  Revenue({required this.year, required this.month, required this.total});

  factory Revenue.fromJson(Map<String, dynamic> json) {
    return Revenue(
      year: json['year'],
      month: json['month'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month': month,
      'total': total,
    };
  }
}

class HomePage extends StatefulWidget {
  final String jwt;
  final Map<String, dynamic> payload;

  HomePage(this.jwt, this.payload);

  factory HomePage.fromBase64(String jwt) {
    if (jwt == null || jwt.isEmpty) {
      throw ArgumentError('JWT string is null or empty');
    }

    var jwtParts = jwt.split(".");
    if (jwtParts.length < 2) {
      throw ArgumentError('Invalid JWT string format');
    }

    var payload =
        json.decode(ascii.decode(base64.decode(base64.normalize(jwtParts[1]))));
    return HomePage(jwt, payload);
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /* List<Plan> plans = [
    Plan(name: 'Plan 1', age: '20'),
    Plan(name: 'Plan 2', age: '25'),
    Plan(name: 'Plan 3', age: '30'),
  ];
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Screen")),
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
                  Text("WELCOME ${widget.payload['username']}, here's the data:"),
                  ElevatedButton(
                    onPressed: () async {
                      var response = await fetchplans();
                      print(json.decode(response));
                      List<Plan> plans =
                      (json.decode(response) as List<dynamic>)
                          .map<Plan>((planData) {
                        return Plan(
                          id: planData['_id'],
                          type: planData['plan_type'],
                          price: planData['plan_price'],
                          validity: planData['plan_validity'],
                        );
                      }).toList();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlanSelectionPage(
                            plans: plans,
                            onUpdatePlans: (updatedPlans) {
                              setState(() {
                                plans = updatedPlans;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Text("Plans"),
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      DateTime _now = DateTime.now();
                      var response = await fetchpayments();
                      var response2 = await fetchtotalrevenue(_now);
                      print(json.decode(response2));

                      List<Payment> plans =
                      (json.decode(response) as List<dynamic>)
                          .map<Payment>((planData) {
                        return Payment(
                          billable_amount: planData['billable_amount'],
                          month: planData['month'],
                          plan: planData['plan'],
                          userid: planData['userid'],
                        );
                      }).toList();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            currentrevenue:response2,
                            plans: plans,
                            onUpdatePlans: (updatedPlans) {
                              setState(() {
                                plans = updatedPlans;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Text("Payments"),
                  ),
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
                          'Authorization': json.decode(widget.jwt)["token"],
                          'Content-Type': 'application/json',
                        },
                      );
                      // Handle response
                    },
                    child: Text("Count++"),
                  ),
                  //Text((snapshot.data) ?? ""),
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
        'Authorization': json.decode(widget.jwt)["token"],
        'Content-Type': 'application/json',
      },
    );
    return res.body;
  }

  Future<String> fetchplans() async {
    var res = await http.get(
      Uri.parse('$SERVER_IP/getplans'),
      headers: {
        'Authorization': json.decode(widget.jwt)["token"],
        'Content-Type': 'application/json',
      },
    );
    return res.body;
  }
  Future<String> fetchpayments() async {
    var res = await http.get(
      Uri.parse('$SERVER_IP/getpayments'),
      headers: {
        'Authorization': json.decode(widget.jwt)["token"],
        'Content-Type': 'application/json',
      },
    );
    return res.body;
  }
  Future<String> fetchtotalrevenue(DateTime _now) async {
    var res = await http.post(
      Uri.parse('$SERVER_IP/revenuetotal'),
      headers: {
        'Authorization': json.decode(widget.jwt)["token"],
      },
      body:{
        'year':_now.year.toString(),
        'month':_now.month.toString()
      }
    );
    return res.body;
  }
  Future<String> deleteplan(int idd) async {
    var res = await http.post(
      Uri.parse('$SERVER_IP/deleteplan'),
      headers: {
        'Authorization': json.decode(widget.jwt)["token"],
        'Content-Type': 'application/json',
      },
      body: {
        json.encode({
          'id': idd,
        })
      },
    );
    return res.body;
  }
}

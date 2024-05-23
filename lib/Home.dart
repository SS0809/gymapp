import 'package:flutter/material.dart';
import '../plans/PlanSelection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../plans/plans_edit.dart';
import 'main.dart';
import 'Login.dart';
import '../payments/payment.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../docs/docs.dart';
import '../drag.dart';

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
  late double deviceHeight;
  late double deviceWidth;
  // create some values
  Color pickerColor = Color(0xFF741BA0);
  Color currentColor = Color(0xFF00875F);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 40,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /* IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                  ),*/
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 16, top: 8),
                    child: Builder(
                      builder: (context) {
                        return GestureDetector(
                          onLongPress: () {
                            final RenderBox overlay = Overlay.of(context)
                                .context
                                .findRenderObject() as RenderBox;
                            showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(
                                overlay.size.width - 30,
                                0,
                                overlay.size.width,
                                overlay.size.height,
                              ),
                              items: <PopupMenuEntry<int>>[
                                const PopupMenuItem<int>(
                                  value: 0,
                                  child: Text('MyTheme'),
                                ),
                                const PopupMenuItem<int>(
                                  value: 1,
                                  child: Text('Logout'),
                                ),
                              ],
                            ).then((int? result) async {
                              if (result != null) {
                                switch (result) {
                                  case 0:
                                    // Handle "Details" action
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Pick a color!'),
                                          content: SingleChildScrollView(
                                            child: ColorPicker(
                                              pickerColor: pickerColor,
                                              onColorChanged: changeColor,
                                            ),
                                          ),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              child: const Text('Got it'),
                                              onPressed: () {
                                                storage.write(
                                                    key: "color",
                                                    value: pickerColor
                                                            .toHexString() ??
                                                        "");
                                                setState(() =>
                                                    currentColor = pickerColor);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    break;
                                  case 1:
                                    // Handle "Logout" action
                                    await storage.delete(key: "jwt");
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
                                    );
                                    break;
                                }
                              }
                            });
                          },
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/ic_launcher1.png"),
                            radius: 25,
                            backgroundColor: Colors
                                .black, // Set the background color to black
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )),
          Center(
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
                      SizedBox(
                        height: deviceHeight * 0.20,
                      ),
                      Center(
                        child: Image.asset(
                          "assets/images/gymlogo.png",
                          width: deviceWidth * 0.46,
                          height: deviceHeight * 0.16,
                        ),
                      ),
                      Text(
                        "WELCOME!", //${widget.payload['username']},",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.03,
                      ),

                      Container(
                        height: deviceHeight * 0.087,
                        width: deviceWidth * 0.74,
                        decoration: BoxDecoration(
                          color: currentColor,
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: deviceWidth * 0.1,
                            ),
                            Text(
                              "Plans",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: deviceWidth * 0.18,
                            ),
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
                              child: Text("View"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.01 ,
                      ),
                      Container(
                        height: deviceHeight * 0.087,
                        width: deviceWidth * 0.74,
                        decoration: BoxDecoration(
                          color: currentColor,
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: deviceWidth * 0.1,
                            ),
                            Text(
                              "Payment",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: deviceWidth * 0.10,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (json.decode(widget.jwt)["type"] ==
                                    "ADMIN") {
                                  DateTime _now = DateTime.now();
                                  var response = await fetchpayments();
                                  var response2 = await fetchtotalrevenue(_now);
                                  print(json.decode(response2));

                                  List<Payment> plans =
                                      (json.decode(response) as List<dynamic>)
                                          .map<Payment>((planData) {
                                    return Payment(
                                      billable_amount:
                                          planData['billable_amount'],
                                      month: planData['month'],
                                      plan: planData['plan'],
                                      userid: planData['userid'],
                                    );
                                  }).toList();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaymentPage(
                                        //currentrevenue:response2,
                                        plans: plans,
                                        onUpdatePlans: (updatedPlans) {
                                          setState(() {
                                            plans = updatedPlans;
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                } else {
                                  var response = await fetchuserpayments();
                                  List<Payment> plans =
                                      (json.decode(response) as List<dynamic>)
                                          .map<Payment>((planData) {
                                    return Payment(
                                      billable_amount:
                                          planData['billable_amount'],
                                      month: planData['month'],
                                      plan: planData['plan'],
                                      userid: planData['userid'],
                                    );
                                  }).toList();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaymentPage(
                                        //currentrevenue:response2,
                                        plans: plans,
                                        onUpdatePlans: (updatedPlans) {
                                          setState(() {
                                            plans = updatedPlans;
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text("View"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
                      Container(
                        height: deviceHeight * 0.087,
                        width: deviceWidth * 0.74,
                        decoration: BoxDecoration(
                          color: currentColor,
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: deviceWidth * 0.1,
                            ),
                            Text(
                              "Content",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: deviceWidth * 0.12,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (json.decode(widget.jwt)["type"] ==
                                    "ADMIN") {
                                  var response = await fetchalldata();
                                  print(response);
                                  List<Docs> docs =
                                      (json.decode(response) as List<dynamic>)
                                          .map<Docs>((planData) {
                                    return Docs(
                                      filename: planData['filename'],
                                      resource_type: planData['resource_type'],
                                      secure_url: planData['secure_url'],
                                    );
                                  }).toList();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyDocs(
                                        docs: docs,
                                      ), //admin
                                    ),
                                  );
                                } else {
                                  var response = await fetchalldata();
                                  List<Docs> docs =
                                      (json.decode(response) as List<dynamic>)
                                          .map<Docs>((planData) {
                                    return Docs(
                                      filename: planData['filename'],
                                      resource_type: planData['resource_type'],
                                      secure_url: planData['secure_url'],
                                    );
                                  }).toList();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyDocs(
                                        docs: docs,
                                      ), //admin
                                    ),
                                  );
                                }
                              },
                              child: Text("View"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
                      Container(
                        height: deviceHeight * 0.087,
                        width: deviceWidth * 0.74,
                        decoration: BoxDecoration(
                          color: currentColor,
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: deviceWidth * 0.1,
                            ),
                            Text(
                              "DragDrop",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: deviceWidth * 0.10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ExampleDragAndDrop(), //admin
                                  ),
                                );
                              },
                              child: Text("View"),
                            ),
                          ],
                        ),
                      ),

                      // ElevatedButton(
                      //   onPressed: () async {
                      //     await storage.delete(key: "jwt");
                      //     Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => LoginPage()),
                      //     );
                      //   },
                      //   child: Text("LOGOUT"),
                      // ),
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     var res = await http.post(
                      //       Uri.parse('$SERVER_IP/add'),
                      //       headers: {
                      //         'Authorization': json.decode(widget.jwt)["token"],
                      //         'Content-Type': 'application/json',
                      //       },
                      //     );
                      //     // Handle response
                      //   },
                      //   child: Text("Count++"),
                      // ),
                      //Text((snapshot.data) ?? ""),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
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

  Future<String> fetchalldata() async {
    var res = await http.get(
      Uri.parse('$SERVER_IP/getalldata'),
      headers: {
        'Authorization': json.decode(widget.jwt)["token"],
        'Content-Type': 'application/json',
      },
    );
    return res.body;
  }

  Future<String> fetchuserpayments() async {
    var res = await http.get(
      Uri.parse('$SERVER_IP/getuserpayment'),
      headers: {
        'Authorization': json.decode(widget.jwt)["token"],
        'Content-Type': 'application/json',
      },
    );
    return res.body;
  }

  Future<String> fetchtotalrevenue(DateTime _now) async {
    var res = await http.post(Uri.parse('$SERVER_IP/revenuetotal'), headers: {
      'Authorization': json.decode(widget.jwt)["token"],
    }, body: {
      'year': _now.year.toString(),
      'month': _now.month.toString()
    });
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

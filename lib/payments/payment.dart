import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import '../Home.dart';
import '../main.dart';
import '../plans/plans_edit.dart';
import '../Login.dart';

class Payment {
  int billable_amount;
  String month;
  String plan;
  String userid;

  Payment({
    required this.billable_amount,
    required this.month,
    required this.plan,
    required this.userid,
  });
}

class PaymentPage extends StatefulWidget {
  final List<Payment> plans;
  final Function(List<Payment>) onUpdatePlans;

  const PaymentPage({
    required this.plans,
    required this.onUpdatePlans,
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PlanSelectionPageState();
}

class _PlanSelectionPageState extends State<PaymentPage> {
  late double deviceHeight;
  late double deviceWidth;
  String? selectedDate;
  final storage = FlutterSecureStorage();
  String? jwt;
  Color? currentColor;

  @override
  void initState() {
    super.initState();
    fetchJwtAndColor();
  }

  Future<void> fetchJwtAndColor() async {
    String jwtValue = await storage.read(key: "jwt") ?? "";//TODO
    String colorValue = await storage.read(key: "color") ?? "FF1A1A1A";
    setState(() {
      jwt = jwtValue;
      currentColor = Color(int.parse(colorValue, radix: 16));
    });
  }
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  Future<String> fetchTotalRevenue(DateTime date) async {
    var res = await http.post(
      Uri.parse('$SERVER_IP/revenuetotal'),
      headers: {
        'Authorization': json.decode(await jwtOrEmpty)["token"],
      },
      body: {
        'year': date.year.toString(),
        'month': date.month.toString(),
      },
    );
    return res.body;
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text('Payments section'),
        backgroundColor: currentColor ?? Color(0xFF00875F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
              ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(3000),
                  );
                  if (picked != null) {
                    String revenue = await fetchTotalRevenue(picked);
                    final List<dynamic> revenueList = json.decode(revenue);
                    final int totalRevenue = revenueList.isNotEmpty
                        ? revenueList[0]['total']
                        : 0;
                    setState(() {
                      selectedDate = "Revenue for ${picked.month}/${picked.year}: $totalRevenue";
                    });
                  }
                },
                child: Text(selectedDate == null ? "Revenue Date" : selectedDate!),
              ),
              SizedBox(
                height: deviceHeight * 0.03,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.plans.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                          height: 80,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: currentColor ?? Color(0xFF00B37E),
                            borderRadius: BorderRadius.circular(31.0),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  widget.plans[index].billable_amount.toString(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  widget.plans[index].plan.toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  widget.plans[index].month.toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  widget.plans[index].userid.toString(),
                                  style: const TextStyle(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

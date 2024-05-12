import 'package:flutter/material.dart';

class PlanSelectionPage extends StatefulWidget {
  const PlanSelectionPage({Key? key}) : super(key: key);

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
        title: Text('Featured Plans'),
         backgroundColor: Color(0xFF05AADC)
    ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: deviceHeight* 0.06,
            horizontal: deviceWidth*0.08,
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
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF05AADC),
              borderRadius: BorderRadius.circular(20.0),
            ),
            height: 100,
            width: double.infinity,
            child: Center(
                child: Text(
                    '999',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
            ),
          ),
              SizedBox( height: deviceHeight*0.04),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF05AADC),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                height: 100,
                width: double.infinity,
                child: Center(
                  child: Text(
                      '1999',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox( height: deviceHeight*0.04),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF05AADC),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                height: 100,
                width: double.infinity,
                child: Center(
                  child: Text(
                      '2999',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
     ),
    );
  }
}

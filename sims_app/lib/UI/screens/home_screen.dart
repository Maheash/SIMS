import 'package:SIMS/UI/auth/login_screen.dart';
import 'package:SIMS/UI/screens/profile_screen.dart';
import 'package:SIMS/UI/screens/soil_moisture.dart';
import 'package:SIMS/UI/screens/water_level.dart';
import 'package:SIMS/UI/utils/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../utils/utils.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final auth = FirebaseAuth.instance;
  String UserId = " ";
  final databaseRef = FirebaseDatabase.instance.ref('realtimeSoilData');

  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      UserId = user!.uid;
    });
  }

  void turnOnRelay() async {
    // var url = Uri.parse('http://192.168.1.34:80/on');
    // var response = await http.get(url);
    // debugPrint('Response status: ${response.statusCode}');
    // debugPrint('Response body: ${response.body}');

    Utils().successMessage("Motor On");
  }

  void turnOffRelay() async {
    var url = Uri.parse('http://192.168.1.34:80/off');
    var response = await http.get(url as Uri);
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text("S.I.M.S Home"),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    auth.signOut().then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  icon: const Icon(Icons.logout_outlined));
            }),
            const SizedBox(width: 10),
          ],
        ),
        drawer: const AppDrawer(),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                          child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "\t\t\tSIMS always monitors the field and the changes that take place get updated in realtime with the help of various sensors that are deployed in the field. \n\n\t\t\tHere are some quick updates from the field that might be helpful!",
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 20),
                        ),
                      )),
                    ],
                  )),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Card(
                        child: StreamBuilder<dynamic>(
                          stream: databaseRef
                              .child(UserId)
                              .child('Soil Moisture')
                              .onValue,
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              double moistureLevel =
                                  snapshot.data.snapshot.value ?? 0;
                              String moistureText;
                              if (moistureLevel < 20) {
                                moistureText = 'DRY';
                              } else if (moistureLevel > 20 &&
                                  moistureLevel < 60) {
                                moistureText = 'A BIT MOIST';
                              } else if (moistureLevel > 60 &&
                                  moistureLevel < 75) {
                                moistureText = 'MOIST';
                              } else if (moistureLevel > 75 &&
                                  moistureLevel <= 100) {
                                moistureText = 'OVER WATERED';
                              } else {
                                moistureText = 'NOT CONNECTED';
                              }
                              return Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Soil Moisture',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(height: 10.0),
                                    Text(
                                      moistureText,
                                      style: TextStyle(
                                        fontSize: 35.0,
                                        fontWeight: FontWeight.bold,
                                        color: moistureText == 'DRY'
                                            ? Colors.red
                                            : moistureText == 'A BIT MOIST'
                                                ? Color.fromARGB(255, 8, 70, 10)
                                                : moistureText == 'MOIST'
                                                  ? Colors.teal
                                                    : moistureText == 'OVER WATERED'
                                                      ? Colors.blueGrey
                                                      :Colors.yellow
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 0),
                      Card(
                        child: StreamBuilder<dynamic>(
                          stream: databaseRef
                              .child(UserId)
                              .child('Temperature')
                              .onValue,
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              double tempLevel =
                                  snapshot.data.snapshot.value ?? 0;
                              return Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Temperature',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(height: 10.0),
                                    Text(
                                      "$tempLevel°C",
                                      style: TextStyle(
                                        fontSize: 35.0,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      SizedBox(width: 310,
                      child: Card(
                          child: StreamBuilder<dynamic>(
                            stream: databaseRef
                                .child(UserId)
                                .child('Tank Volume')
                                .onValue,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                double waterLeft =
                                    snapshot.data.snapshot.value ?? 0 as double;
                                waterLeft = 250 - waterLeft;
                                waterLeft =
                                    double.parse(waterLeft.toStringAsFixed(2));
                                return Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Water in the Tank',
                                          style: TextStyle(fontSize: 20)),
                                      SizedBox(height: 10.0),
                                      Text("$waterLeft litres left",
                                          style: TextStyle(
                                              fontSize: 35.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue)),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),)
                    ],
                  )
                ])));
  }
}

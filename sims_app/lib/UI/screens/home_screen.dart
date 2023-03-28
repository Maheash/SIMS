import 'package:SIMS/UI/auth/login_screen.dart';
import 'package:SIMS/UI/screens/profile_screen.dart';
import 'package:SIMS/UI/screens/soil_moisture.dart';
import 'package:SIMS/UI/screens/water_level.dart';
import 'package:SIMS/UI/utils/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../utils/bool.dart';
import '../utils/utils.dart';

import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // bool isOn = false;
  late Function currentFunction;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final auth = FirebaseAuth.instance;
  // ignore: non_constant_identifier_names
  String UserId = " ";
  final databaseRef = FirebaseDatabase.instance.ref('realtimeSoilData');

  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      UserId = user!.uid;
    });
    MotorStatus();
  }

  // ignore: non_constant_identifier_names
  Future<bool> MotorStatus() async {
    var url = Uri.parse('http://192.168.1.34/status');
    var response = await http.get(url);
    if (response.body == "ON") {
      isOn = true;
      debugPrint("isOn value is updated as True");
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return true;
    } else if (response.body == 'OFF') {
      isOn = false;
      debugPrint("isOn value is updated as False");
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return false;
    }
    return false;
  }

  void turnOnRelay() async {
    var url = Uri.parse('http://192.168.1.34/on');
    var response = await http.get(url);
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    Utils().successMessage("Motor On");
  }

  void turnOffRelay() async {
    var url = Uri.parse('http://192.168.1.34/off');
    var response = await http.get(url);
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    Utils().toastMessage("Motor Off");
  }

  void toggleButton() {
    setState(() {
      isOn = !isOn;
    });
    isOn ? turnOnRelay() : turnOffRelay();
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
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          shadowColor: Colors.blue,
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
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 206,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Color.fromARGB(255, 178, 252, 174),
                          shadowColor: Color.fromARGB(255, 178, 252, 174),
                          child: StreamBuilder<dynamic>(
                            stream: databaseRef
                                .child(UserId)
                                .child('Soil Moisture')
                                .onValue,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                double moistureLevel =
                                    (snapshot.data.snapshot.value ??
                                            0.00 as double)
                                        .toDouble();
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Soil Moisture',
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        moistureText,
                                        style: TextStyle(
                                            fontSize: 35.0,
                                            fontWeight: FontWeight.bold,
                                            color: moistureText == 'DRY'
                                                ? Colors.red
                                                : moistureText == 'A BIT MOIST'
                                                    ? Color.fromARGB(
                                                        255, 8, 70, 10)
                                                    : moistureText == 'MOIST'
                                                        ? Colors.teal
                                                        : moistureText ==
                                                                'OVER WATERED'
                                                            ? Colors.blueGrey
                                                            : Colors.yellow),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 1),
                      Card(
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.amber,
                        shadowColor: Colors.amber,
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
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                    SizedBox(height: 10.0),
                                    Text(
                                      "$tempLevel°C",
                                      style: TextStyle(
                                          fontSize: 35.0, color: Colors.white),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 350,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          shadowColor: Color.fromARGB(255, 196, 216, 252),
                          color: Color.fromARGB(255, 196, 216, 252),
                          child: StreamBuilder<dynamic>(
                            stream: databaseRef
                                .child(UserId)
                                .child('Tank Volume')
                                .onValue,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                double waterLeft =
                                    (snapshot.data.snapshot.value ??
                                            0 as double)
                                        .toDouble();
                                waterLeft = 250 - waterLeft;
                                waterLeft =
                                    double.parse(waterLeft.toStringAsFixed(2));
                                return Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Water in the Tank',
                                          style: TextStyle(fontSize: 20)),
                                      SizedBox(height: 10.0),
                                      Text("$waterLeft litres left",
                                          style: const TextStyle(
                                              fontSize: 35.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue)),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 350,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Color.fromARGB(255, 235, 116, 116),
                          shadowColor: Color.fromARGB(255, 235, 116, 116),
                          child: Center(
                            child: StreamBuilder<dynamic>(
                              stream: databaseRef
                                  .child(UserId)
                                  .child('Soil Moisture')
                                  .onValue,
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasData) {
                                  return Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isOn ? 'Water Motor: ON' : 'Water Motor: OFF',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        SizedBox(width: 100,),
                                          Center(
                                            child: ElevatedButton(
                                            onPressed: () {
                                              toggleButton();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shadowColor: Colors.blue,
                                              shape: CircleBorder(),
                                              padding: EdgeInsets.all(14),
                                              minimumSize: Size(10, 10),
                                            ),
                                            child: Icon(isOn
                                                ? Icons.stop
                                                : Icons.play_arrow_sharp),
                                          ),
                                          )
                                      ],
                                    ),
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ])));
  }
}

import 'dart:async';
import 'package:SIMS/UI/utils/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../utils/bool.dart';
import 'home_screen.dart';

import '../auth/login_screen.dart';
import '../utils/utils.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../widgets/round_button.dart';

class SoilMoisture extends StatefulWidget {
  const SoilMoisture({super.key});

  @override
  State<SoilMoisture> createState() => _SoilMoistureState();
}

class _SoilMoistureState extends State<SoilMoisture> {
  // bool isOn = false;
  late Function currentFunction;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('realtimeSoilData');
  String UserId = '';

  double soilMoisture = 0.0;
  double tankVolume = 0.0;
  double tankCapacity = 0.0;

  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      UserId = user!.uid;
    });
  }

  void turnOnRelay() async {
    var url = Uri.parse('http://192.168.43.248/on');
    var response = await http.get(url);
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    Utils().successMessage("Motor On");
  }

  void turnOffRelay() async {
    var url = Uri.parse('http://192.168.43.248/off');
    var response = await http.get(url as Uri);
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
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
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Realtime data from the Field",
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
            SizedBox(height: 15),
            Text(
                "\t\t\tThe Soil Moisture level of the field is measured continously and displayed in terms of percentage here.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify),
            SizedBox(height: 15),
            Center(
                child: StreamBuilder(
              stream: ref.onValue,
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) {
                  // debugPrint("$soilMoisture");
                  return CircularProgressIndicator();
                } else {
                  ref
                      .child(UserId)
                      .child('Soil Moisture')
                      .onValue
                      .listen((event) {
                    soilMoisture =
                        double.parse(event.snapshot.value.toString());
                    soilMoisture =
                        double.parse(soilMoisture.toStringAsFixed(3));
                    // debugPrint("Moisture: $soilMoisture");
                  });

                  return SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: 100,
                        interval: 10,
                        ranges: [
                          GaugeRange(
                            startValue: 0,
                            endValue: 25,
                            color: Colors.orange,
                          ),
                          GaugeRange(
                            startValue: 25,
                            endValue: 60,
                            color: Colors.green,
                          ),
                          GaugeRange(
                            startValue: 60,
                            endValue: 75,
                            color: Colors.yellow,
                          ),
                          GaugeRange(
                              startValue: 75, endValue: 100, color: Colors.blue)
                        ],
                        pointers: <GaugePointer>[
                          NeedlePointer(
                            value: soilMoisture,
                            enableAnimation: true,
                          )
                        ],
                        annotations: [
                          GaugeAnnotation(
                            widget: Text("Moisture level: $soilMoisture%",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15)),
                            positionFactor: 1,
                            angle: 90,
                          ),
                        ],
                      )
                    ],
                  );
                }
              },
            )),
            SizedBox(height: 15),
            Text(
              isOn
                  ? 'Water motor ON. Tap to turn it OFF'
                  : "Tap the button to water the field",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    toggleButton();
                  },
                  child: Icon(isOn ? Icons.stop : Icons.play_arrow_sharp),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(17),
                    minimumSize: Size(10, 10),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

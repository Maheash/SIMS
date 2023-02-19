import 'dart:ffi';
import 'dart:math';

import 'package:SIMS/UI/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('realtimeSoilData/l3ghZjCm9Rf2F8LChrT2YaWZvOI3/Water Distance');
  final _valRef = FirebaseDatabase.instance
      .ref('realtimeSoilData/l3ghZjCm9Rf2F8LChrT2YaWZvOI3/Soil Moisture');
  double soilMoisture = 0;
  double waterDistance = 0;
  double tankCapacity = 50; //cm
  double value = 0;
  String _userId = " ";
  late DatabaseReference _databaseReference;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
    return _userId;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("S.I.M.S"),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout_outlined)),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Realtime data from the Field",
              style: TextStyle(color: Colors.deepPurple, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Expanded(
                child: StreamBuilder(
              stream: _valRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  // Map<dynamic, dynamic> map =
                  //     snapshot.data!.snapshot.value as dynamic;
                  // List<dynamic> list = [];
                  // list.clear();
                  // list = map.values.toList();
                  // soilMoisture = list[3];
                  // return Text("$list");
                  _valRef.onValue.listen((event) {
                    soilMoisture =
                        double.parse(event.snapshot.value.toString());
                    debugPrint("Moisture: $soilMoisture");
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
                            endValue: 20,
                            color: Colors.orange,
                          ),
                          GaugeRange(
                            startValue: 20,
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
            Expanded(
                child: StreamBuilder(
              stream: ref.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  ref.onValue.listen((event) {
                    waterDistance =
                        double.parse(event.snapshot.value.toString());
                    // value = tankCapacity - waterDistance;
                    // waterDistance = value;
                    debugPrint("Water left: $waterDistance");
                  });

                  return SfRadialGauge(axes: <RadialAxis>[
                    RadialAxis(
                        showLabels: false,
                        showTicks: false,
                        radiusFactor: 0.8,
                        maximum: tankCapacity,
                        axisLineStyle: const AxisLineStyle(
                            cornerStyle: CornerStyle.startCurve, thickness: 5),
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                              angle: 90,
                              widget: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('$waterDistance',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 20)),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 2, 0, 0),
                                    child: Text(
                                      'cm',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12),
                                    ),
                                  )
                                ],
                              )),
                               GaugeAnnotation(
                            widget: Text("Water level",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15)),
                            positionFactor: 1,
                            angle: 90,
                          ),
                          GaugeAnnotation(
                            angle: 124,
                            positionFactor: 1.1,
                            widget: Text('0', style: TextStyle(fontSize: 12)),
                          ),
                          GaugeAnnotation(
                            angle: 54,
                            positionFactor: 1.1,
                            widget: Text('$tankCapacity',
                                style: TextStyle(fontSize: 12)),
                          ),
                        ],
                        pointers: <GaugePointer>[
                          RangePointer(
                            value: waterDistance,
                            width: 18,
                            pointerOffset: -6,
                            cornerStyle: CornerStyle.bothCurve,
                            color: Color.fromARGB(255, 79, 180, 243),
                            gradient: SweepGradient(colors: <Color>[
                              Color.fromARGB(255, 79, 180, 243),
                              Color.fromARGB(255, 78, 164, 245)
                            ], stops: <double>[
                              0.25,
                              0.75
                            ]),
                          ),
                          MarkerPointer(
                            value: waterDistance,
                            color: Colors.white,
                            markerType: MarkerType.circle,
                          ),
                        ])
                  ]);
                }
              },
            )),

            // Expanded(
            //   child: FirebaseAnimatedList(
            //       query: _valRef,
            //       defaultChild: Text("loading"),
            //       itemBuilder:
            //           (BuildContext context, snapshot, animation, index) {
            //         return ListTile(
            //           // ignore: unnecessary_const
            //           // title: Text(
            //           //   // "Realtime Data from the field",
            //           title: Text("${snapshot.child('S1').value}"),
            //           subtitle: Text("${snapshot.child('S2').value}"),
            //         );
            //       }),
            // ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

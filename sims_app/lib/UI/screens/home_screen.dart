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
  final ref = FirebaseDatabase.instance.ref('realtimeSoilData/Test');
  final _valRef = FirebaseDatabase.instance.ref('realtimeSoilData/Test/S2');
  double soilMoisture = 0;
  int value = 0;

  void initState() {
    super.initState();
    // _activateListeners();
  }

  // _activateListeners() {
  //   ref.child('realtimeSoilData/Test/S2').onValue.listen((event) {
  //     final value = event.snapshot.value;
  //     debugPrint("$value");
  //     setState(() {
  //       soilMoisture = double.parse("$value");
  //       debugPrint("$soilMoisture");
  //     });
  //   });
  // }

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
              "Realtime Soil data from the Field",
              style: TextStyle(color: Colors.deepPurple, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Expanded(
                child: StreamBuilder(
              stream: ref.onValue,
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
                        debugPrint("$soilMoisture");
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
                            startValue: 50,
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
                                    color: Colors.deepPurple, fontSize: 15)),
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
              child: FirebaseAnimatedList(
                  query: ref,
                  defaultChild: Text("loading"),
                  itemBuilder:
                      (BuildContext context, snapshot, animation, index) {
                    return ListTile(
                      // ignore: unnecessary_const
                      // title: Text(
                      //   // "Realtime Data from the field",
                      title: Text("${snapshot.child('S1').value}"),
                      subtitle: Text("${snapshot.child('S2').value}"),
                    );
                  }),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

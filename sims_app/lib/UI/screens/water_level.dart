import 'package:SIMS/UI/utils/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../auth/login_screen.dart';
import '../utils/utils.dart';

class WaterLevel extends StatefulWidget {
  const WaterLevel({super.key});

  @override
  State<WaterLevel> createState() => _WaterLevelState();
}

class _WaterLevelState extends State<WaterLevel> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    bool loading = false;
    final auth = FirebaseAuth.instance;
    final ref = FirebaseDatabase.instance.ref('realtimeSoilData');
    String UserId = '';

    double soilMoisture = 0.0;
    double tankVolume = 0.0;
    double tankCapacity = 250;
    double value = 0;
    String val = "";

    void initState() {
      final user = FirebaseAuth.instance.currentUser;
      setState(() {
        UserId = user!.uid;
        ref.child(UserId).child('Tank Capacity').onValue.listen((event) {
          tankCapacity = double.parse(event.snapshot.value.toString());
          debugPrint("Tank Capacity: $tankCapacity");
        });
      });
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Realtime Water Level Data",
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
              SizedBox(height: 10),
              Text("\t\t\tThe water in the tank is updated in realtime according to the changes in the water level of the tank. Make sure the tank contains enough water so that the field stays irrigated.",
              style: TextStyle(fontSize:18),
              textAlign: TextAlign.justify,),
              const SizedBox(height: 20),
              Center(
                  child: StreamBuilder(
                stream: ref.onValue,
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator.adaptive();
                  } else {
                    ref
                        .child(UserId)
                        .child('Tank Volume')
                        .onValue
                        .listen((event) {
                      tankVolume =
                          double.parse(event.snapshot.value.toString());
                      tankVolume = tankCapacity - tankVolume;
                      tankVolume = double.parse(tankVolume.toStringAsFixed(3));
                      debugPrint("Water left: $tankVolume");
                    });

                    return SfRadialGauge(axes: <RadialAxis>[
                      RadialAxis(
                          showLabels: false,
                          showTicks: false,
                          radiusFactor: 0.8,
                          maximum: tankCapacity,
                          axisLineStyle: const AxisLineStyle(
                              cornerStyle: CornerStyle.startCurve,
                              thickness: 5),
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                angle: 90,
                                widget: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text('$tankVolume',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 20)),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 2, 0, 0),
                                      child: Text(
                                        'litres left',
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
                                      color: Colors.blue, 
                                      fontSize: 18,)),
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
                              value: tankVolume,
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
                              value: tankVolume,
                              color: Colors.white,
                              markerType: MarkerType.circle,
                            ),
                          ])
                    ]);
                  }
                },
              ),
              ),
              const SizedBox(
              height: 20,
            ),
            Text("\t\t\tIn case of low level of water try to fill the tank asap.",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.justify)              
            ],
          ),
        ),
      );
    }
  }
// import 'dart:async';
// import 'dart:ffi';
// import 'dart:math';

// import 'package:SIMS/UI/auth/login_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';

// import '../utils/utils.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   bool loading = false;
//   final auth = FirebaseAuth.instance;
//   final ref = FirebaseDatabase.instance
//       .ref('realtimeSoilData/l3ghZjCm9Rf2F8LChrT2YaWZvOI3/Water Distance');
//   final _valRef = FirebaseDatabase.instance
//       .ref('realtimeSoilData/l3ghZjCm9Rf2F8LChrT2YaWZvOI3/Soil Moisture');

//   double soilMoisture = 0;
//   double waterDistance = 0;
//   double tankCapacity = 50; //cm
//   double value = 0;
//   String _userId = " ";

//   void initState() {
//     super.initState();
//     Timer.periodic(Duration(seconds: 5), (Timer t) => getCurrentUser());
//   }

//   // Future<void> getCurrentUser() async {
//   //   final user = FirebaseAuth.instance.currentUser;
//   //   if (user != null) {
//   //     setState(() {
//   //       _userId = user.uid;
//   //       debugPrint(_userId);
//   //     });
//   //   }
//   //   final ref =
//   //       FirebaseDatabase.instance.ref('realtimeSoilData').child(_userId);
//   //   ref.child('Soil Moisture').onValue.listen((event) {
//   //     final Object? value = event.snapshot.value;
//   //     setState(() {
//   //       soilMoisture = double.parse(value.toString());
//   //     });
//   //     debugPrint("Above all: $soilMoisture");
//   //   });
//   //   ref.child('Water Distance').onValue.listen((event) {
//   //     final Object? value = event.snapshot.value;
//   //     setState(() {
//   //       waterDistance = double.parse(value.toString());
//   //     });
//   //     debugPrint("One Above all: $waterDistance");
//   //   });
//   // }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SfRadialGauge(
//           axes: <RadialAxis>[
//             RadialAxis(
//               minimum: 0,
//               maximum: 100,
//               showLabels: false,
//               showTicks: false,
//               axisLineStyle: AxisLineStyle(
//                 thickness: 0.2,
//                 cornerStyle: CornerStyle.bothCurve,
//                 color: Colors.black,
//                 thicknessUnit: GaugeSizeUnit.factor,
//               ),
//               pointers: <GaugePointer>[
//                 NeedlePointer(
//                   value: soilMositure,
//                   enableAnimation: true,
//                   animationType: AnimationType.ease,
//                   animationDuration: 1500,
//                   knobStyle: KnobStyle(
//                     knobRadius: 0.05,
//                     sizeUnit: GaugeSizeUnit.factor,
//                     borderColor: Colors.white,
//                     color: Colors.black,
//                     borderWidth: 0.05,
//                   ),
//                 ),
//               ],
//               annotations: <GaugeAnnotation>[
//                 GaugeAnnotation(
//                   positionFactor: 0.1,
//                   angle: 90,
//                   widget: Text(
//                     'Gauge Value: $soilMoisture',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

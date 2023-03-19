// import 'dart:async';
// import 'package:SIMS/UI/utils/navbar.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:SIMS/UI/screens/soil_moisture.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class HistoryScreen extends StatefulWidget {
//   @override
//   _HistoryScreenState createState() => _HistoryScreenState();
// }

// class _HistoryScreenState extends State<HistoryScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final databaseReference = FirebaseDatabase.instance.ref('realtimeSoilData');
//   List<dynamic> history = [];
//   late Timer _timer;
//   final auth = FirebaseAuth.instance;
//   String UserId = '';

//   @override
//   void initState() {
//     super.initState();
//     syncData();
//   }

//   Future<void> syncData() async {
//     // Reference to Realtime Database
//     final databaseRef = FirebaseDatabase.instance
//         .ref('realtimeSoilData')
//         .child(UserId)
//         .child('Soil Moisture');

//     // Reference to Firestore
//     final firestoreRef = FirebaseFirestore.instance;

//     // Listen for Realtime Database changes
//     databaseRef.onValue.listen((event) async {
//       // Get the data snapshot from Realtime Database
//       final dataSnapshot = event.snapshot;

//       // Convert the data to a Map
//       final data = dataSnapshot.value as double;

//       // Write the data to Firestore
//       await firestoreRef
//           .collection('firestoreSoilData')
//           .doc(UserId)
//           .update({'Soil Moisture': data});
//       debugPrint("$data");
//     });
//   }

// @override
// void initState() {
//   super.initState();
//   final user = FirebaseAuth.instance.currentUser;
//   UserId = user!.uid;
//   debugPrint("$UserId");
//   databaseReference
//       .child(UserId)
//       .child('Soil Moisture')
//       .onValue
//       .listen((event) {
//     var snapshot = event.snapshot;
//     var data = snapshot.value;
//     setState(() {
//       history.add(data);
//     });
//   });

//   // Set a timer to clear the history list after 5 hours
//   _timer = Timer(Duration(hours: 5), () {
//     setState(() {
//       history.clear();
//     });
//   });
// }

// @override
// void dispose() {
//   super.dispose();
//   _timer.cancel(); // Cancel the timer to avoid memory leaks
// }

// @override
// Widget build(BuildContext context) {
//   // var chartData = _getChartData();
//   return Scaffold(
//     key: _scaffoldKey,
//     appBar: AppBar(
//       centerTitle: true,
//       automaticallyImplyLeading: false,
//       title: Text("History"),
//       leading: IconButton(
//         icon: Icon(Icons.menu),
//         onPressed: () {
//           _scaffoldKey.currentState?.openDrawer();
//         },
//       ),
//     ),
//     drawer: const AppDrawer(),
//   //    body: Center(
//   //     child: Column(
//   //       mainAxisAlignment: MainAxisAlignment.center,
//   //       children: [
//   //         Text(
//   //           'Last 1 hour',
//   //           style: TextStyle(fontSize: 18),
//   //         ),
//   //         SizedBox(height: 10),
//   //         Expanded(
//   //           child: charts.TimeSeriesChart(
//   //             _getChartData(),
//   //             animate: true,
//   //             dateTimeFactory: charts.LocalDateTimeFactory(),
//   //             primaryMeasureAxis: charts.NumericAxisSpec(
//   //               tickProviderSpec: charts.BasicNumericTickProviderSpec(
//   //                 zeroBound: true,
//   //               ),
//   //             ),
//   //             domainAxis: charts.DateTimeAxisSpec(
//   //               renderSpec: charts.SmallTickRendererSpec(
//   //                 labelStyle: charts.TextStyleSpec(
//   //                   fontSize: 12,
//   //                   color: charts.MaterialPalette.black,
//   //                 ),
//   //                 lineStyle: charts.LineStyleSpec(
//   //                   thickness: 0,
//   //                   color: charts.MaterialPalette.transparent,
//   //                 ),
//   //                 tickLengthPx: 0,
//   //               ),
//   //               tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
//   //                 hour: charts.TimeFormatterSpec(
//   //                   format: 'h:mm a',
//   //                   transitionFormat: 'h:mm a',
//   //                 ),
//   //               ),
//   //             ),
//   //             behaviors: [
//   //               charts.PanAndZoomBehavior(),
//   //             ],
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   ),
//   // );
// }

//   List<charts.Series<ChartData, DateTime>> _getChartData() {
//     List<ChartData> chartData = [];

//     // Convert history list to chart data
//     for (int i = 0; i < history.length; i++) {
//       chartData.add(ChartData(
//           DateTime.now().subtract(Duration(minutes: history.length - i)),
//           history[i]));
//     }

//     return [
//       charts.Series<ChartData, DateTime>(
//         id: 'soilData',
//         colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//         domainFn: (ChartData data, _) => data.time,
//         measureFn: (ChartData data, _) => data.value,
//         data: chartData,
//       ),
//     ];
//   }

// }

// class ChartData {
//   final DateTime time;
//   final dynamic value;

//   ChartData(this.time, this.value);
// }
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:workmanager/workmanager.dart';

// import '../utils/uid.dart';

// class HistoryScreen extends StatefulWidget {
//   @override
//   HistoryScreenState createState() => HistoryScreenState();
// }

// class HistoryScreenState extends State<HistoryScreen> {
//   String UserId=" ";
//   Workmanager workmanager = Workmanager();

//   @override
//   void initState() {
//     super.initState();
//     final user = FirebaseAuth.instance.currentUser;
//     UserId = user!.uid;
    

//     // Initialize the workmanager
//     workmanager.initialize(callbackDispatcher);

//     // Register a periodic task to run every 5 minutes
//     workmanager.registerPeriodicTask(
//       'saveData',
//       'saveDataBackground',
//       frequency: Duration(minutes: 5),
//       initialDelay: Duration(minutes: 5),
//     );
//   }

  
// void callbackDispatcher() {
//     workmanager.executeTask((taskName, inputData) async {
//       // Get the current soil moisture value and timestamp
//       double currentValue =
//           50.0; // Replace with your actual code to get the value
//       String timestamp = DateTime.now().toString();

//       // Save the current data to the historical location in the database
//       DatabaseReference databaseRef = FirebaseDatabase.instance
//           .ref('historicaldata')
//           .child(UserId);
//       String? key = databaseRef.push().key;
//       await databaseRef
//           .child(key!)
//           .set({'value': currentValue, 'timestamp': timestamp});

//       return Future.value(true);
//     });
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Soil Moisture'),
//       ),
//       body: Center(
//         child: Text(
//           'Monitoring soil moisture...',
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }

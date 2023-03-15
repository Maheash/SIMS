// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'dart:async';

// class ChartData {
//   final DateTime time;
//   final int value;

//   ChartData(this.time, this.value);
// }

// class HistoryScreen extends StatefulWidget {
//   @override
//   _HistoryScreenState createState() => _HistoryScreenState();
// }

// class _HistoryScreenState extends State<HistoryScreen> {
//   List<int> history = [];
//   final databaseReference = FirebaseDatabase.instance.ref('realtimeSoilData');
//   late Timer _timer;

//    @override
//   void initState() {
//     super.initState();
//     databaseReference.child('your_data_reference').onValue.listen((event) {
//       var snapshot = event.snapshot;
//       var data = snapshot.value;
//       setState(() {
//         history.add(data);
//       });
//     });

//     // Set a timer to clear the history list after 5 hours
//     _timer = Timer(Duration(hours: 5), () {
//       setState(() {
//         history.clear();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _timer.cancel(); // Cancel the timer to avoid memory leaks
//   }

//   @override
//   Widget build(BuildContext context) {
//     var chartData = _getChartData();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('History'),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(8),
//         child: charts.TimeSeriesChart(
//           chartData,
//           animate: true,
//           dateTimeFactory: const charts.LocalDateTimeFactory(),
//         ),
//       ),
//     );
//   }

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
//         id: 'data',
//         colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//         domainFn: (ChartData data, _) => data.time,
//         measureFn: (ChartData data, _) => data.value,
//         data: chartData,
//       ),
//     ];
//   }
// }

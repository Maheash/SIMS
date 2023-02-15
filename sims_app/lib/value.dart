// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   DatabaseReference _valRef = FirebaseDatabase.instance.ref('realtimeSoilData/Land1');
//   fetchData() {
//     _valRef.onValue.listen((DatabaseEvent event) {
//       final data = event.snapshot.value;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("SIMS"),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//                 stream: _valRef.onValue,
//                 builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//                   if (!snapshot.hasData) {
//                     return CircularProgressIndicator();
//                   } else {
//                     Map<dynamic, dynamic> map =
//                         snapshot.data!.snapshot.value as dynamic;
//                     List<dynamic> list = [];
//                     list.clear();
//                     list = map.values.toList();

//                     return ListView.builder(
//                       itemCount: snapshot.data!.snapshot.children.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(list[index]['Soil Moisture']),
//                           subtitle: Text(list[index]['Water Distance']),
//                         );
//                       },
//                     );
//                   }
//                 }),
//           ),
//           Expanded(
//             child: FirebaseAnimatedList(
//                 query: fetchData(),
//                 defaultChild: Text("loading"),
//                 itemBuilder: (context, snapshot, animation, index) {
//                   return ListTile(
//                       title: Text(
//                           snapshot.child('Soil Moisture').value.toString()),
//                       subtitle: Text(
//                           snapshot.child('Water Distance').value.toString()));
//                 }),
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:SIMS/UI/screens/profile_screen.dart';
import 'package:SIMS/UI/screens/soil_moisture.dart';
import 'package:SIMS/UI/screens/water_level.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:SIMS/UI/screens/home_screen.dart';

import '../screens/history_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String UserId = '';
  String userName = '';
  String userEmail = '';
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('realtimeSoilData');

  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    UserId = user!.uid;

    setState(() {
      ref.child(UserId).child('User Name').onValue.listen((event) {
        setState(() {
          userName = event.snapshot.value.toString();
          // debugPrint("User Name: $userName");
        });
      });
      ref.child(UserId).child('User email').onValue.listen((event) {
        setState(() {
          userEmail = event.snapshot.value.toString();
          // debugPrint("User email: $userEmail");
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              "Welcome, $userName!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text("$userEmail"),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                  child: Image.asset(
                'assets/dp.webp',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              )),
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.water_drop),
            title: Text("Soil Moisture"),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => SoilMoisture()));
            },
          ),
          ListTile(
            leading: Icon(Icons.monitor),
            title: Text("Water Level"),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => WaterLevel()));
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.person),
          //   title: Text("Profile"),
          //   onTap: () {
          //     Navigator.of(context).pushReplacement(MaterialPageRoute(
          //         builder: (BuildContext context) => ProfileScreen()));
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.data_exploration),
          //   title: Text("History"),
          //   onTap: () {
          //     Navigator.of(context).pushReplacement(MaterialPageRoute(
          //         builder: (BuildContext context) => HistoryScreen()));
          //   },
          // )
        ],
      ),
    );
  }
}

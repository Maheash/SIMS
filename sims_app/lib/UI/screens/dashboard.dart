import 'package:SIMS/UI/screens/profile_screen.dart';
import 'package:SIMS/UI/screens/soil_moisture.dart';
import 'package:SIMS/UI/screens/water_level.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'home_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  final screens = [HomeScreen(), Dashboard(), WaterLevel(), SoilMoisture()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text("Dashboard", style: TextStyle(fontSize: 20),)
        // body: IndexedStack(
        //   index: _currentIndex,
        //   children: screens,
        // ),
        // bottomNavigationBar: BottomNavigationBar(
        //   type: BottomNavigationBarType.fixed,
        //   backgroundColor: Colors.deepPurple,
        //   selectedItemColor: Colors.white,
        //   unselectedItemColor: Colors.white70,
        //   iconSize: 30,
        //   selectedFontSize: 15,
        //   unselectedFontSize: 12,
        //   showUnselectedLabels: false,
        //   currentIndex: _currentIndex,
        //   onTap: (index) => setState(() => _currentIndex = index),
        //   items: [
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.home),
        //         label: "Home",
        //         backgroundColor: Colors.deepPurple),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.pin_drop),
        //         label: "Soil Moisture",
        //         backgroundColor: Colors.deepPurple),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.water),
        //         label: "Water level",
        //         backgroundColor: Colors.deepPurple),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.person),
        //         label: "Profile",
        //         backgroundColor: Colors.deepPurple),
        //   ],
        // )
        );
  }
}

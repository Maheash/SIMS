import 'package:SIMS/UI/auth/login_screen.dart';
import 'package:SIMS/UI/screens/profile_screen.dart';
import 'package:SIMS/UI/screens/soil_moisture.dart';
import 'package:SIMS/UI/screens/water_level.dart';
import 'package:SIMS/UI/utils/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../utils/utils.dart';
import 'dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final auth = FirebaseAuth.instance;
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
            Builder(
              builder: (context) {
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
              }
            ),
            const SizedBox(width: 10),
          ],
        ),
        drawer: const AppDrawer(),
        body: Text("This is the home page"),        );
  }
}

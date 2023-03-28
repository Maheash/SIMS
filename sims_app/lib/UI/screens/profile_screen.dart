import 'package:SIMS/UI/utils/navbar.dart';
import 'package:SIMS/UI/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final auth = FirebaseAuth.instance;
  String UserId = " ";
  DatabaseReference _userRef =
      FirebaseDatabase.instance.ref('realtimeSoilData');

  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      UserId = user!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text("S.I.M.S Profile"),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
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
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "User Profile",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Center(
                  //    child: StreamBuilder(
                  //   stream: _userRef.onValue,
                  //   builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  //     if (!snapshot.hasData) {
                  //       return CircularProgressIndicator();
                  //     } else {
                  //       _userRef
                  //           .child(UserId)
                  //           .child('Soil Moisture')
                  //           .onValue
                  //           .listen((event) {
                          
                  //         // debugPrint("Moisture: $soilMoisture");
                  //       });
                  //     }
                  //   },
                  // )
                    
                      )
                ])));
  }
}

import 'package:SIMS/UI/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('realtimeSoilData');
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
            const SizedBox(height: 20,),
            const Text("Realtime Data from the Field",
            style: TextStyle(
              color: Colors.deepPurple, 
              fontSize: 20
              ),
              ),
            Expanded(
              child: FirebaseAnimatedList(
                  query: ref,
                  // defaultChild: loading,
                  itemBuilder:
                      (BuildContext context, snapshot, animation, index) {
                    return ListTile(
                      // ignore: unnecessary_const
                      // title: Text(
                      //   // "Realtime Data from the field",
                        title: Text("Soil Moisture: ${snapshot.child('Soil Moisture').value}"),
                        subtitle: Text("Water Level: ${snapshot.child('Water Distance').value}"),
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

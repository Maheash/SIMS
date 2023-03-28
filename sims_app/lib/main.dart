import 'dart:async';
import 'package:SIMS/UI/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'UI/utils/bool.dart';
bool isOn = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stack) {
    debugPrint("Error thrown!");
    debugPrint(stack.toString());
  });
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: SplashScreen(),
      home: FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error occured! ${snapshot.error.toString()}');
            return Text('Something went wrong..!');
          } else if (snapshot.hasData) {
            return SplashScreen();
          } else {
            return Center(child: null);
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

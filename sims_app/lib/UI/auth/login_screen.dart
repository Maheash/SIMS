import 'dart:convert';

import 'package:SIMS/UI/auth/phone_auth/login_with_phone.dart';
import 'package:SIMS/UI/screens/home_screen.dart';
import 'package:SIMS/UI/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String userId = " ";

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<String> signInUser(
      {required String email, required String password}) async {
    email.trim();
    password.trim();
    String output = "Something went wrong";
    if (email != "" && password != "") {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        output = "success";
      } on FirebaseAuthException catch (e) {
        output = e.message.toString();
      }
    } else {
      output = "Please fill up all the fields.";
    }
    return output;
  }

  void Login() async {
    String output = await signInUser(
        email: emailController.text, password: passwordController.text);
    setState(() {
      loading = false;
    });
    if (output == "success") {
      setState(() {
        loading = false;
        Utils().successMessage("Welcome!");
        // sendUserId();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      });
    } else {
      //error
      Utils().toastMessage(output);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "S.I.M.S - Login",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 30,
                      fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Icon(
                  Icons.login_rounded,
                  color: Colors.blue,
                  size: 100,
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'E-mail',
                          helperText: 'Enter your e-mail id here',
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter e-mail address';
                          }
                          return null;
                        }),
                    const SizedBox(height: 30),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          helperText: 'Enter your password here',
                          prefixIcon: Icon(Icons.lock_open),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        }),
                  ]),
                ),
                const SizedBox(height: 30),
                RoundButton(
                  title: 'Login',
                  loading: loading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      Login();
                    }
                  },
                ),
                const SizedBox(height: 30),
                // InkWell(
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => LogInWithPhoneNumber()));
                //   },
                //   child: Container(
                //     height: 50,
                //     width: 150,
                //     decoration: BoxDecoration(
                //         color: Colors.blue,
                //         borderRadius: BorderRadius.circular(10)),
                //     child: Center(
                //         child: Text(
                //       "Login with Phone",
                //       style: TextStyle(color: Colors.white),
                //     )),
                //   ),
                // )
              ]),
        ),
      ),
    );
  }
}

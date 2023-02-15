import 'package:SIMS/UI/auth/verify_code.dart';
import 'package:SIMS/UI/utils/utils.dart';
import 'package:SIMS/UI/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogInWithPhoneNumber extends StatefulWidget {
  const LogInWithPhoneNumber({super.key});

  @override
  State<LogInWithPhoneNumber> createState() => _LogInWithPhoneNumberState();
}

class _LogInWithPhoneNumberState extends State<LogInWithPhoneNumber> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login with Phone"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(
            height: 50,
          ),
          TextFormField(
            controller: phoneNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "+91 9987654321"),
          ),
          SizedBox(
            height: 30,
          ),
          RoundButton(
            loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                auth.verifyPhoneNumber(
                    phoneNumber: phoneNumberController.text,
                    verificationCompleted: (_) {},
                    verificationFailed: (e) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(e.toString());
                    },
                    codeSent: (String verificationId, int? token) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerifyCodeScreen(
                                    VerificationId: verificationId,
                                  )));
                      setState(() {
                        loading = false;
                      });
                    },
                    codeAutoRetrievalTimeout: (e) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(e.toString());
                    });
              },
              title: 'Login')
        ]),
      ),
    );
  }
}

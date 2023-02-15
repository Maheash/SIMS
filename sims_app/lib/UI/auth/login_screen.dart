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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    } else {
      //error
      Utils().toastMessage(output);
    }
  }

  // void Login() async{
  //   setState(() {
  //     loading = true;
  //   });
  //     _auth
  //       .signInWithEmailAndPassword(
  //           email: emailController.text,
  //           password: passwordController.text.toString())
  //       .then((value) {
  //     Utils().toastMessage(value.user!.email.toString());
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => HomeScreen()));
  //     setState(() {
  //       loading = false;
  //     });
  //   }).onError((error, stackTrace) {
  //     if(error.runtimeType==FirebaseAuthException){
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content:
  //               Text(error.toString().replaceRange(0, 14, '').split(']')[1]),
  //           backgroundColor: Theme.of(context).colorScheme.error,
  //         ),
  //       );
  //     }
  //     debugPrint(error.toString());
  //     Utils().toastMessage(error.toString());
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'SIMS - Login',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                const SizedBox(height: 50),
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LogInWithPhoneNumber()));
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      "Login with Phone",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/material.dart';

// class SignInScreen extends StatefulWidget {
//   const SignInScreen({Key? key}) : super(key: key);

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   AuthenticationMethods authenticationMethods = AuthenticationMethods();

//   bool isLoading = false;
//   @override
//   void dispose() {
//     super.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = Utils().getScreenSize();
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: SizedBox(
//           height: screenSize.height,
//           width: screenSize.width,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Image.network(
//                   //   amazonLogo,
//                   //   height: screenSize.height * 0.10,
//                   // ),
//                   const Icon(
//                     Icons.rate_review_outlined,
//                     color: Colors.blueGrey,
//                     size: 130,
//                   ),
//                   Container(
//                     height: screenSize.height * 0.6,
//                     width: screenSize.width * 0.8,
//                     padding: const EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Colors.white,
//                         width: 0,
//                       ),
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Sign-In",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w500, fontSize: 33),
//                         ),
//                         TextFieldWidget(
//                           title: "Email",
//                           controller: emailController,
//                           obscureText: false,
//                           hintText: "Enter your email",
//                         ),
//                         TextFieldWidget(
//                           title: "Password",
//                           controller: passwordController,
//                           obscureText: true,
//                           hintText: "Enter your password",
//                         ),
//                         Align(
//                           alignment: Alignment.center,
//                           child: CustomMainButton(
//                               child: const Text(
//                                 "Sign In",
//                                 style: TextStyle(
//                                     letterSpacing: 0.6, color: Colors.black),
//                               ),
//                               color: yellowColor,
//                               isLoading: isLoading,
//                               onPressed: () async {
//                                 setState(() {
//                                   isLoading = true;
//                                 });

//                                 String output =
//                                     await authenticationMethods.signInUser(
//                                         email: emailController.text,
//                                         password: passwordController.text);
//                                 setState(() {
//                                   isLoading = false;
//                                 });
//                                 if (output == "success") {
//                                   //functions
//                                 } else {
//                                   //error
//                                   Utils().showSnackBar(
//                                       context: context, content: output);
//                                 }
//                               }),
//                         )
//                       ],
//                     ),
//                   ),],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

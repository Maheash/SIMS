import 'package:flutter/material.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String VerificationId;
  const VerifyCodeScreen({Key? key, required this.VerificationId}):super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify"),
      ),
      body: Column(children: []),
    );
  }
}

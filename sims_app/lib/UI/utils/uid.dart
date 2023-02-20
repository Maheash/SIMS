import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserId {
  static String _userId = " ";
  Future<void> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
    }
    ;
  }

  getUser() {
    debugPrint("$_userId");
    return _userId;
  }
}

import 'package:adminpanel/views/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoutController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  void mylogout() {
    try {
      auth.signOut().then((value) {
        Get.snackbar("Logout", "Logout Successfully");
        Get.offAll(() => LoginScreen());
      });
    } catch (e) {
      print(e.toString());
    }
  }
}

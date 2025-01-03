import 'package:adminpanel/views/displaycatscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailcontroller = TextEditingController();
  final usercontroller = TextEditingController();
  final passcontroller = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore get = FirebaseFirestore.instance;

  var isObscure = true.obs;

  void isToggle() {
    isObscure.value = !isObscure.value;
  }

  void mylogin() async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailcontroller.text.trim(),
          password: passcontroller.text.trim());

      String uid = userCredential.user!.uid;

      // role fetching firestore
      DocumentSnapshot userDoc = await get.collection('users').doc(uid).get();

      if (userDoc.exists) {
        String role = userDoc['role'];

        if (role == 'admin') {
          Get.to(() => DisplayCatScreen());
        } else {
          Get.snackbar("Error", "Wrong credentials");
        }
      } else {
        Get.snackbar("Error", "Wrong credentials");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

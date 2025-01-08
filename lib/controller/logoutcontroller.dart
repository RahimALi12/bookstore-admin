// ignore_for_file: avoid_print

import 'package:adminpanel/utils/snackbarutils.dart';
import 'package:adminpanel/views/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LogoutController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  // Logout Method
  void mylogout() {
    try {
      auth.signOut().then((value) {
        // Logout success
        SnackbarUtil.showSnackbar(
          "Logout",
          "Logout Successfully",
          type: 'success',
        );

        // Navigate to Admin Login Screen
        Get.offAll(() => const AdminLoginScreen());
      });
    } catch (e) {
      // Handle any errors during logout
      // print(e.toString());

      SnackbarUtil.showSnackbar(
        "Error",
        "Something went wrong during logging out",
        type: 'error',
      );
    }
  }
}

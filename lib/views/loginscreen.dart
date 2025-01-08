import 'package:adminpanel/utils/snackbarutils.dart';
import 'package:adminpanel/views/mainscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController passwordController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String hardcodedPassword = "admin123"; // Hardcoded password (if needed)

  Future<void> verifyPassword() async {
    try {
      // OPTIONAL: Fetch password from Firestore
      DocumentSnapshot snapshot =
          await firestore.collection("adminpanel").doc("admin").get();

      String storedPassword =
          snapshot.exists ? snapshot["password"] : hardcodedPassword;

      if (passwordController.text == storedPassword) {
        // Password matches
        SnackbarUtil.showSnackbar(
          "Successfully Login",
          "Welcome Admin",
          type: 'success',
        );
        // Navigate to admin dashboard
        Get.to(() => const MainScreen());
      } else {
        // Password doesn't match
        SnackbarUtil.showSnackbar(
          "Error",
          "Password in Incorrect",
          type: 'error',
        );
      }
    } catch (e) {
      SnackbarUtil.showSnackbar(
        "Error",
        "An Error occurred",
        type: 'error',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Login",
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Color.fromARGB(227, 24, 24, 24)),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Enter Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: verifyPassword,
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

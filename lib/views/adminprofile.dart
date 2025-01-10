import 'package:adminpanel/controller/logoutcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize LogoutController
    final logoutController = Get.put(LogoutController());

    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 171, 226, 255),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Admin Profile",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 19,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Admin Avatar
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage(
                    'assets/images/user.png'), // Local image from assets
              ),
              const SizedBox(height: 20),

              // Logout Button Centered
              ElevatedButton(
                onPressed: () {
                  logoutController.mylogout();
                },
                child: const Text("Logout",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 232, 229, 229))),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: const Color.fromARGB(
                      255, 32, 96, 214), // Red background for the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

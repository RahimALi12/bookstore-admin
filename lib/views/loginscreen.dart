// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:adminpanel/controller/logincontroller.dart';
import 'package:adminpanel/views/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final con = Get.put(LoginController());

    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                "Login",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              // TextField(

              //   decoration: InputDecoration(
              //     suffixIcon: Icon(Icons.email),
              //     border: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.black),

              //     ),
              //     hintText: "Enter your email...",
              //   ),
              // ),

              CustomTextField(
                  controller: con.emailcontroller,
                  sufIcon: Icon(Icons.email),
                  Hint: "Enter your email..."),

              SizedBox(
                height: 15,
              ),

              CustomTextField(
                  controller: con.usercontroller,
                  sufIcon: Icon(Icons.person),
                  Hint: "Enter your username..."),

              SizedBox(
                height: 15,
              ),

              Obx(() {
                return TextField(
                  decoration: InputDecoration(
                    // suffixIcon: Icon(Icons.visibility),
                    suffixIcon: IconButton(
                        onPressed: () {
                          con.isToggle();
                        },
                        icon: Icon(con.isObscure.value
                            ? Icons.visibility
                            : Icons.visibility_off)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintText: "Enter your password...",
                  ),
                  obscureText: con.isObscure.value,
                  controller: con.passcontroller,
                );
              }),
              SizedBox(
                height: 15,
              ),

              InkWell(
                onTap: () {
                  // print(con.emailcontroller.text.trim());
                  // print(con.usercontroller.text.trim());
                  // print(con.passcontroller.text.trim());

                  con.mylogin();
                },
                child: Container(
                  width: Get.width * 0.5,
                  height: Get.height * 0.05,
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Center(
                    child: Text("Login"),
                  ),
                ),
              ),

              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

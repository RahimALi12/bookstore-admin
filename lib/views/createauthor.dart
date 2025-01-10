// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:adminpanel/controller/authorcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddAuthorScreen extends StatefulWidget {
  const AddAuthorScreen({super.key});
  // const AddAuthorScreen({super.key, required String authors});

  @override
  State<AddAuthorScreen> createState() => _AddAuthorScreenState();
}

class _AddAuthorScreenState extends State<AddAuthorScreen> {
  @override
  Widget build(BuildContext context) {
    final con = Get.put(AuthorController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Author",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 19,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: con.authnameController,
              decoration: const InputDecoration(hintText: "Enter author name"),
            ),
            const SizedBox(
              height: 15,
            ),
            Obx(() {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await con.pickImage();
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: con.selectedFile.value != null
                                ? Colors.green
                                : Colors.grey,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              spreadRadius: 2,
                              blurRadius: 10,
                            ),
                          ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: con.selectedFile.value != null
                            ? Image.file(
                                con.selectedFile.value!,
                                fit: BoxFit.cover,
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo),
                                  Text(
                                    "Tap To Select an image",
                                    style: TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    con.selectedFileName.value.isNotEmpty
                        ? con.selectedFileName.value
                        : "Tap To Select Image..",
                    style: TextStyle(fontSize: 15),
                  )
                ],
              );
            }),
            ElevatedButton(
              onPressed: () async {
                // Image upload karna hoga pehle
                String? imageUrl = await con.uploadImagetocloudinary();

                // Agar image URL null hai (matlab image upload nahi hui), toh default image use karein
                String imageName = imageUrl ??
                    'assets/images/logo.png'; // Replace with your default image path

                // Fir author add karne ka method call karein
                con.addAuthor(con.authnameController.text.trim(), imageName);
              },
              child: const Text("Add Author"),
            )
          ],
        ),
      ),
    );
  }
}

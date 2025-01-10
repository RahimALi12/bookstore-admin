// ignore_for_file: prefer_const_constructors

import 'package:adminpanel/controller/authorcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class EditAuthorPage extends StatefulWidget {
  final String authorId;

  const EditAuthorPage({super.key, required this.authorId});

  @override
  _EditAuthorPageState createState() => _EditAuthorPageState();
}

class _EditAuthorPageState extends State<EditAuthorPage> {
// const _EditProductPageState(this.String cName , String cId);
  final TextEditingController authnameController = TextEditingController();

  // For image management
  // File? selectedImage;
  String imageUrl = "";
  String existingImageUrl = "";

  @override
  void initState() {
    super.initState();
    _loadAuthorDetails();
  }

  // // Load product details to pre-fill the form
  Future<void> _loadAuthorDetails() async {
    var authorDoc = await FirebaseFirestore.instance
        .collection('authors')
        .doc(widget.authorId)
        .get();

    authnameController.text = authorDoc['auname'];
    existingImageUrl = authorDoc['imagename']; // Assign the existing image URL
    imageUrl = existingImageUrl; // Assign to imageUrl as well
    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    final con = Get.put(AuthorController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Author',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 19,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display the current product image or a placeholder
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height *
                  0.3, // Adjust height based on screen size
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(8.0),
              //   image: DecorationImage(image: NetworkImage(imageUrl)),
              // ),
              // child: ClipRRect(
              //   borderRadius: BorderRadius.circular(8.0),
              //   child: Image.network(
              //     imageUrl,
              //     width: double.infinity,
              //     height: MediaQuery.of(context).size.height *
              //         0.3, // Adjust height based on screen size
              //     fit: BoxFit.cover, // Maintain aspect ratio without overflow
              //   ),
              // )),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(
                    imageUrl.isNotEmpty
                        ? imageUrl
                        : existingImageUrl, // Use existing image if new image is not provided
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl.isNotEmpty
                      ? imageUrl
                      : existingImageUrl, // Use existing image if new image is not provided
                  width: double.infinity,
                  height:
                      MediaQuery.of(context).size.height * 0.3, // Adjust height
                  fit: BoxFit.cover, // Maintain aspect ratio
                ),
              ),
            ),

            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  con.pickImage();
                },
                child: Text('Pick New Image')),
            SizedBox(height: 20),
            TextField(
                controller: authnameController,
                decoration: InputDecoration(labelText: 'Author Name')),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                final autname = authnameController.text.trim();

                con.editAuthor(
                  widget.authorId,
                  autname,
                );
              },
              child: Text('Update Author'),
            ),
          ],
        ),
      ),
    );
  }
}

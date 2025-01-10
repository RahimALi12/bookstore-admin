// ignore_for_file: avoid_print, invalid_use_of_protected_member, prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:adminpanel/utils/snackbarutils.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthorController extends GetxController {
  final FirebaseFirestore firebase = FirebaseFirestore.instance;
  final TextEditingController authnameController = TextEditingController();
  var authors = <DocumentSnapshot>[].obs;
  var isloading = false.obs;
  var authorsdata = <Map<String, dynamic>>[].obs;
  var authorsList = <Map<String, dynamic>>[].obs;

  var selectedFile = Rxn<File>();
  var selectedFilesByte = Rxn<List<int>>();
  var selectedFileName = ''.obs;

  // Pick Image from gallery
  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: false);

      if (result != null) {
        selectedFileName.value = result.files.single.name;

        if (kIsWeb) {
          selectedFilesByte.value = result.files.single.bytes;
        } else {
          selectedFile.value = File(result.files.single.path!);
        }
        SnackbarUtil.showSnackbar(
          "Success",
          "Image Selected!",
          type: 'info',
        );
      }
    } catch (e) {
      SnackbarUtil.showSnackbar(
        "Error",
        "Failed to Pick Image....",
        type: 'error',
      );
    }
  }

  // Upload image to Cloudinary
  Future<String?> uploadImagetocloudinary() async {
    const String cloudName =
        "ddpvb0run"; // Replace with your Cloudinary cloud name
    const String uploadPreset = "images"; // Replace with your upload preset

    if (selectedFile.value == null && selectedFilesByte.value == null) {
      // Get.snackbar("Error", "Please selectafadf an image");
      return null;
    }

    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    try {
      final request = http.MultipartRequest('POST', url);
      request.fields['upload_preset'] = uploadPreset;

      // Add file for mobile or web
      if (kIsWeb && selectedFilesByte.value != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          selectedFilesByte.value!,
          filename: selectedFileName.value,
        ));
      } else if (selectedFile.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath('file', selectedFile.value!.path),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);

      if (response.statusCode == 200) {
        final imageUrl = jsonResponse['secure_url'];
        // Get.snackbar("Success", "Image Uploaded Successfully");
        return imageUrl;
      } else {
        SnackbarUtil.showSnackbar(
          "Error",
          "Upload Files....",
          type: 'error',
        );
      }
    } catch (e) {
      SnackbarUtil.showSnackbar(
        "Error",
        "Failed to Upload Image....",
        type: 'error',
      );
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    fetchAuthors();
  }

  Future<void> fetchAuthors() async {
    try {
      isloading.value = true; // Start loading
      final QuerySnapshot data = await firebase.collection("authors").get();

      authorsList.clear(); // Clear the previous data
      if (data.docs.isNotEmpty) {
        List<Map<String, dynamic>> datalist = [];
        for (var doc in data.docs) {
          // Add 'id' explicitly to the data
          var authorData = doc.data() as Map<String, dynamic>;
          authorData['id'] = doc.id; // Assign Firestore document ID
          datalist.add(authorData);
        }
        authorsList.assignAll(datalist); // Assign fetched data to authorsList
      }
      isloading.value = false; // Stop loading
    } catch (e) {
      isloading.value = false; // Stop loading even if there's an error
      print("Error fetching authors: $e");
    }
  }

  // Clear text controllers
  void clearControllers() {
    authnameController.clear();
    selectedFile.value = null;
    selectedFilesByte.value = null;
    selectedFileName.value = '';
  }

  Future<void> addAuthor(String authorName, String imageName) async {
    // Upload image to Cloudinary
    final imageUrl = await uploadImagetocloudinary();

    // Default image URL (if no image is uploaded)
    const String defaultImagePath =
        'assets/images/logo.png'; // Path to your logo

    // Use the default image if no image is uploaded
    final String finalImagePath =
        imageUrl ?? defaultImagePath; // Default image path

    // Get input values
    String? authorName = authnameController.text.trim();

    // Validate inputs
    if (authorName.isEmpty) {
      SnackbarUtil.showSnackbar(
        "Error",
        "Please Provide Valid Details....",
        type: 'error',
      );
      return;
    }

    try {
      // Reference to product collection in Firebase
      DocumentReference authorRef =
          firebase.collection('authors').doc(authorName);

      // Add product data to Firebase
      await authorRef.set({
        'auname': authorName,
        'imagename':
            finalImagePath, // Use either uploaded image URL or default path
      });

      fetchAuthors();

      // Show success message and navigate back
      SnackbarUtil.showSnackbar(
        "Success",
        "Author Added Successfully!....",
        type: 'info',
      );

      // Wait for the Snackbar to display before navigating
      await Future.delayed(
          Duration(seconds: 2)); // Snackbar will display for 2 seconds

      Get.back(closeOverlays: true);
    } catch (e) {
      SnackbarUtil.showSnackbar(
        "Error",
        "Failed to Add Author!....",
        type: 'error',
      );
    }
  }

  Future<void> editAuthor(String authorId, String autname) async {
    if (autname.isEmpty) {
      SnackbarUtil.showSnackbar(
        "Error",
        "Author name cannot be empty!",
        type: 'error', // Snackbar disappears quickly
      );
      return;
    }

    try {
      // Reference to the specific author document in Firestore
      DocumentReference authorDoc =
          firebase.collection('authors').doc(authorId);

      // Fetch existing author details
      final authorSnapshot = await authorDoc.get();
      if (!authorSnapshot.exists) {
        SnackbarUtil.showSnackbar(
          "Error",
          "Author Not Found....",
          type: 'error',
        );
        return;
      }

      final existingData = authorSnapshot.data() as Map<String, dynamic>;
      final existingImageUrl = existingData['imagename'] ?? "";

      // Upload the image if a new one is picked
      final imageUrl = await uploadImagetocloudinary();

      // Prepare update data
      Map<String, dynamic> updateData = {
        'auname': autname, // Update the author name
        'imagename':
            imageUrl ?? existingImageUrl, // Use new image or existing image
      };
      fetchAuthors();

      // Update the document in Firestore
      await authorDoc.update(updateData);
      // Only show a single success snackbar
      SnackbarUtil.showSnackbar(
        'Success',
        'Author Details Updated Successfully',
        type: 'info',
      );

      await Future.delayed(
          Duration(seconds: 2)); // Snackbar will display for 2 seconds

      Get.back(closeOverlays: true); // Close the edit page
    } catch (e) {
      SnackbarUtil.showSnackbar(
        "Error",
        "Failed to Update Author Details....",
        type: 'error',
      );
    }
  }

  Future<void> deleteAuthor(String authorId) async {
    try {
      await firebase.collection('authors').doc(authorId).delete();
      fetchAuthors();

      SnackbarUtil.showSnackbar(
        "Success",
        "Author Deleted successfully....",
        type: 'error',
      );
    } catch (e) {
      SnackbarUtil.showSnackbar(
        "Error",
        "Error in Deletion....",
        type: 'error',
      );
    }
  }
}

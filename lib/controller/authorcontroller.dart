// ignore_for_file: avoid_print, invalid_use_of_protected_member, prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
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
        Get.snackbar("Success", "Image Selected!");
      } else {
        Get.snackbar("Error", "No image selected.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }

  // Upload image to Cloudinary
  Future<String?> uploadImagetocloudinary() async {
    const String cloudName =
        "ddpvb0run"; // Replace with your Cloudinary cloud name
    const String uploadPreset = "images"; // Replace with your upload preset

    if (selectedFile.value == null && selectedFilesByte.value == null) {
      Get.snackbar("Error", "Please select an image");
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
        Get.snackbar("Success", "Image Uploaded: $imageUrl");
        return imageUrl;
      } else {
        Get.snackbar("Error", "Upload failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading image: $e");
      Get.snackbar("Error", "Failed to upload image: $e");
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    fetchAuthors();
  }

// Observable list of authors
  // var authorsList = <Map<String, String>>[].obs;

  Future<void> fetchAuthors() async {
    try {
      isloading.value = true;
      final QuerySnapshot data = await firebase.collection("authors").get();
      // Har author ka data loop mein fetch kar rahe hain
      authorsList.clear();
      if (data.docs.isNotEmpty) {
        List<Map<String, dynamic>> datalist = [];
        for (var doc in data.docs) {
          datalist.add(doc.data() as Map<String, dynamic>);
        }
        authorsdata.value = datalist;
        authors.value = data.docs;
        isloading.value = false;

        print(authorsdata.value.toString());
      }
    } catch (e) {
      print(e.toString());
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
      Get.snackbar("Error", "Please provide valid details");
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

      // Show success message and navigate back
      Get.snackbar("Success", "Author Added!!");
      Get.back(closeOverlays: true);
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", "Failed to add Author!");
    }
  }

  Future<void> editAuthor(
      String autname, String authorId, String currentImageUrl) async {
    String? imageUrl;

    // If a new image is selected, upload it
    if (selectedFile.value != null) {
      imageUrl = await uploadImagetocloudinary();
      if (imageUrl == null) {
        Get.snackbar("Error", "Failed to upload image");
        return;
      }
    } else {
      // If no new image selected, use the current image URL
      imageUrl =
          currentImageUrl; // Keep the old image if no new one is selected
    }

    // Collect form data

    String? authname = authnameController.text.trim();

    // Validation
    if (authname.isEmpty) {
      Get.snackbar("Error", "Please provide valid details");
      return;
    }

    try {
      // Reference to the specific product document
      DocumentReference authorDoc = firebase
          .collection('authors')
          .doc(autname)
          .collection('author')
          .doc(authorId);

      // Prepare the data for update
      Map<String, dynamic> updateData = {
        'auname': authname,
      };

      // If a new image was uploaded, include the new image URL
      if (imageUrl.isEmpty) {
        updateData['imagename'] = imageUrl;
      }

      // Update the product details in Firebase
      await authorDoc.update(updateData);

      Get.snackbar("Success", "Author Updated!");
      Get.back(closeOverlays: true); // Close the edit page
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", "Failed to update Author!");
    }
  }

  Future<void> deleteAuthor(String autname, String authorId) async {
    try {
      // Reference to the specific product document
      DocumentReference authorDoc = firebase
          .collection('authors')
          .doc(autname)
          .collection('author')
          .doc(authorId);

      // Delete the product
      await authorDoc.delete();
      Get.snackbar("Success", "Author Deleted!");
      Get.back(closeOverlays: true);
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", "Failed to delete author!");
    }
  }
}

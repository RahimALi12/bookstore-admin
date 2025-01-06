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

class ProductController extends GetxController {
  final FirebaseFirestore firebase = FirebaseFirestore.instance;
  final TextEditingController pnameController = TextEditingController();
  final TextEditingController ppriceController = TextEditingController();
  final TextEditingController pquantityController = TextEditingController();
  final TextEditingController pdescController = TextEditingController();
  var products = <DocumentSnapshot>[].obs;
  var isloading = false.obs;
  var productdata = <Map<String, dynamic>>[].obs;

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
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isloading.value = true;
      final QuerySnapshot data = await firebase.collection("products").get();
      if (data.docs.isNotEmpty) {
        List<Map<String, dynamic>> datalist = [];
        for (var doc in data.docs) {
          datalist.add(doc.data() as Map<String, dynamic>);
        }
        productdata.value = datalist;
        products.value = data.docs;
        isloading.value = false;

        print(productdata.value.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Clear text controllers
  void clearControllers() {
    pnameController.clear();
    ppriceController.clear();
    pquantityController.clear();
    pdescController.clear();
    selectedFile.value = null;
    selectedFilesByte.value = null;
    selectedFileName.value = '';
  }

  Future<void> addProduct(String catname) async {
    // Upload image to Cloudinary
    final imageUrl = await uploadImagetocloudinary();

    // Default image URL (if no image is uploaded)
    const String defaultImagePath =
        'assets/images/logo.png'; // Path to your logo

    // Use the default image if no image is uploaded
    final String finalImagePath =
        imageUrl ?? defaultImagePath; // Default image path

    // Get input values
    String? pname = pnameController.text.trim();
    String? pdesc = pdescController.text.trim();
    double? price = double.tryParse(ppriceController.text);
    double? quantity = double.tryParse(pquantityController.text);

    // Validate inputs
    if (catname.isEmpty ||
        pname.isEmpty ||
        pdesc.isEmpty ||
        price == null ||
        quantity == null) {
      Get.snackbar("Error", "Please provide valid details");
      return;
    }

    try {
      // Reference to product collection in Firebase
      CollectionReference productCollection =
          firebase.collection('categories').doc(catname).collection('products');

      // Add product data to Firebase
      await productCollection.add({
        'pname': pname,
        'pprice': price,
        'pquantity': quantity,
        'pdesc': pdesc,
        'imagename':
            finalImagePath, // Use either uploaded image URL or default path
      });

      // Show success message and navigate back
      Get.snackbar("Success", "Product Added!!");
      Get.back(closeOverlays: true);
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", "Failed to add product!");
    }
  }

  Future<void> editProduct(String cattname, String producttId, String proName,
      double? pprice, double? pquantity, String pdescc) async {
    // String? imageUrl;

    // // If a new image is selected, upload it
    // if (selectedFile.value != null) {
    //   imageUrl = await uploadImagetocloudinary();
    //   if (imageUrl == null) {
    //     Get.snackbar("Error", "Failed to upload image");
    //     return;
    //   }
    // } else {
    //   // If no new image selected, use the current image URL
    //   imageUrl =
    //       currentImageUrl; // Keep the old image if no new one is selected
    // }

    // Collect form data
    double? price = pprice;
    double? quantity = pquantity;
    String? pname = proName;
    String? pdesc = pdescc;
    final imageUrl = await uploadImagetocloudinary();

    // Default image URL (if no image is uploaded)
    const String defaultImagePath =
        'assets/images/logo.png'; // Path to your logo

    // Use the default image if no image is uploaded
    final String finalImagePath = imageUrl ?? defaultImagePath;

    // Validation
    if (pname.isEmpty || pdesc.isEmpty || price == null || quantity == null) {
      Get.snackbar("Error", "Please provide valid details");
      return;
    }

    try {
      // Reference to the specific product document
      DocumentReference productDoc = firebase
          .collection('categories')
          .doc(cattname)
          .collection('products')
          .doc(producttId);
      // Prepare the data for update
      Map<String, dynamic> updateData = {
        'pname': pname,
        'pprice': price,
        'pquantity': quantity,
        'pdesc': pdesc,
        'imagename': finalImagePath,
      };

      // If a new image was uploaded, include the new image URL
      // if (imageUrl.isEmpty) {
      //   updateData['imagename'] = imageUrl;
      // }

      // Update the product details in Firebase
      await productDoc.update(updateData);

      Get.snackbar("Success", "Product Updated!");
      Get.back(closeOverlays: true); // Close the edit page
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", "Failed to update product!");
    }
  }

  Future<void> deleteProduct(String catname, String productId) async {
    try {
      // Reference to the specific product document
      DocumentReference productDoc = firebase
          .collection('categories')
          .doc(catname)
          .collection('products')
          .doc(productId);

      // Delete the product
      await productDoc.delete();
      Get.snackbar("Success", "Product Deleted!");
      Get.back(closeOverlays: true);
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", "Failed to delete product!");
    }
  }
}

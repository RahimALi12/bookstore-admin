// ignore_for_file: avoid_print, invalid_use_of_protected_member, prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:adminpanel/utils/snackbarutils.dart';
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

  var selectedAuthor = ''.obs; // Store selected author

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
          type: 'success',
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
    if (selectedAuthor.value.isEmpty) {
      Get.snackbar('Error', 'Please select an author');
      return;
    }
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
        'author': selectedAuthor.value, // Add selected author
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
    // Collect form data
    double? price = pprice;
    double? quantity = pquantity;
    String? pname = proName;
    String? pdesc = pdescc;
    // final imageUrl = await uploadImagetocloudinary();

    // // Default image URL (if no image is uploaded)
    // const String defaultImagePath =
    //     'assets/images/logo.png'; // Path to your logo

    // // Use the default image if no image is uploaded
    // final String finalImagePath = imageUrl ?? defaultImagePath;

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
      final authorSnapshot = await productDoc.get();
      final existingData = authorSnapshot.data() as Map<String, dynamic>;
      final existingImageUrl = existingData['imagename'] ?? "";

      // Upload the image if a new one is picked
      final imageUrl = await uploadImagetocloudinary();
      // Prepare the data for update
      Map<String, dynamic> updateData = {
        'pname': pname,
        'pprice': price,
        'pquantity': quantity,
        'pdesc': pdesc,
        'imagename': imageUrl ?? existingImageUrl,
      };

      // Update the product details in Firebase
      await productDoc.update(updateData);

      SnackbarUtil.showSnackbar(
        "Success",
        "Product Details Updated!",
        type: 'success',
      );
      // Wait for the Snackbar to display before navigating
      await Future.delayed(
          Duration(seconds: 2)); // Snackbar will display for 2 seconds

      Get.back(closeOverlays: true); // Close the edit page
    } catch (e) {
      SnackbarUtil.showSnackbar(
        "Error",
        "Failed to Update Product!",
        type: 'error',
      );
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
      SnackbarUtil.showSnackbar(
        "Success",
        "Product Deleted Successfully!",
        type: 'success',
      );
      await Future.delayed(Duration(seconds: 2));
      Get.back(closeOverlays: true);
    } catch (e) {
      SnackbarUtil.showSnackbar(
        "Error",
        "Failed to Delete Product!",
        type: 'error',
      );
    }
  }
}

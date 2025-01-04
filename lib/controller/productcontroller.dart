// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductControlller extends GetxController {
  final FirebaseFirestore firebase = FirebaseFirestore.instance;
  final TextEditingController pnameController = TextEditingController();
  final TextEditingController ppriceController = TextEditingController();
  final TextEditingController pquantityController = TextEditingController();
  final TextEditingController pdescController = TextEditingController();
  var products = <DocumentSnapshot>[].obs;
  var isloading = false.obs;
  var productdata = <Map<String, dynamic>>[].obs;

  var imageFile = Rxn<File>();

  // Pick Image from gallery
  var selectedFile = Rxn<File>();
  var selectedFilesByte = Rxn<List<int>>();
  var selectedFileName = ''.obs;

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
        Get.snackbar("Error", "Error in image picking...");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image");
    }
  }

  Future<String?> uploadImagetocloudinary() async {
    const String cloudName = "@ddpvb0run"; // Replace it with your cloud name
    const String uploadPreset = "images"; // Replace it with your preset name

    if (selectedFile.value == null && selectedFilesByte.value == null) {
      Get.snackbar("Error", "please select an image");
      return null;
    }
    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName /image/upload');
    try {
      final request = http.MultipartRequest('POST', url);
      request.fields['upload_preset'] = uploadPreset;

      if (kIsWeb && selectedFilesByte.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath('file', selectedFile.value!.path),
        );
      }
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);

      if (response.statusCode == 200) {
        final imageUrl = jsonResponse['secure_url'];
        Get.snackbar("Success", "Image Uploaded Successfully");
        return imageUrl;
      } else {
        Get.snackbar("Error", "failed to upload Image");
      }
    } catch (e) {
      Get.snackbar("Error", "Error in upload image");
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

  Future<void> addProduct(String catname) async {
    final imageUrl = await uploadImagetocloudinary();
    if (imageUrl == null) {
      Get.snackbar("Error", "Failed to uplaod image");
    }

    String? pname = pnameController.text.trim();
    String? pdesc = pdescController.text.trim();
    double? price = double.tryParse(ppriceController.text);
    double? quantity = double.tryParse(pquantityController.text);

    if (catname.isEmpty ||
        pname.isEmpty ||
        pdesc.isEmpty ||
        price == null ||
        quantity == null) {
      Get.snackbar("Error", "Please provide valid details");
      return;
    }
    try {
      CollectionReference productCollection =
          firebase.collection('categories').doc(catname).collection('products');
      await productCollection.add({
        'pname': pname,
        'pprice': price,
        'pquantity': quantity,
        'pdesc': pdesc,
        'imagename': imageUrl,
      });
      Get.snackbar("Success", "Product Added!!");
      Get.back(closeOverlays: true);
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", "Failed to add product!");
    }
  }

  Future<void> editProduct(String catname, String productId) async {
    double? price = double.tryParse(ppriceController.text);
    double? quantity = double.tryParse(pquantityController.text);
    String? pname = pnameController.text.trim();
    String? pdesc = pdescController.text.trim();

    if (catname.isEmpty ||
        pname.isEmpty ||
        pdesc.isEmpty ||
        price == null ||
        quantity == null) {
      Get.snackbar("Error", "Please provide valid details");
      return;
    }

    try {
      // Reference to the specific product document
      DocumentReference productDoc = firebase
          .collection('categories')
          .doc(catname)
          .collection('products')
          .doc(productId);

      // Update the product details
      await productDoc.update({
        'pname': pname,
        'pprice': price,
        'pquantity': quantity,
        'pdesc': pdesc,
      });
      Get.snackbar("Success", "Product Updated!");
      Get.back(closeOverlays: true);
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

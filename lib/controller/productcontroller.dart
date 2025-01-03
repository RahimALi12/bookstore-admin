import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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
      CollectionReference productCollection =
          firebase.collection('categories').doc(catname).collection('products');
      await productCollection.add({
        'pname': pname,
        'pprice': price,
        'pquantity': quantity,
        'pdesc': pdesc
      });
      Get.snackbar("Success", "Product Added!!");
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
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", "Failed to delete product!");
    }
  }
}

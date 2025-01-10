// ignore_for_file: avoid_print, invalid_use_of_protected_member

// import 'dart:io';

import 'package:adminpanel/utils/snackbarutils.dart';
// import 'package:adminpanel/views/displaycatscreen.dart';
import 'package:adminpanel/views/mainscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var categoryData =
      <Map<String, dynamic>>[].obs; // To store fetched categories

  final TextEditingController categorycontroller = TextEditingController();
  var categories = <DocumentSnapshot>[].obs;
  final FirebaseFirestore firebase = FirebaseFirestore.instance;
  var isloading = false.obs;
  var categorydata = <Map<String, dynamic>>[].obs;

  Future<void> fetchCategories() async {
    try {
      isloading.value = true; // Start loading
      final QuerySnapshot categorySnapshot =
          await firebase.collection("categories").get();

      if (categorySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> categoryList = [];
        for (var categoryDoc in categorySnapshot.docs) {
          var categoryData = categoryDoc.data() as Map<String, dynamic>;
          categoryData['id'] =
              categoryDoc.id; // Add the category ID to the data
          categoryList.add(categoryData);
        }
        categoryData.value = categoryList; // Assign fetched categories
      }
      isloading.value = false; // Stop loading
    } catch (e) {
      isloading.value = false; // Stop loading in case of error
      print("Error fetching categories: ${e.toString()}");
    }
  }
}

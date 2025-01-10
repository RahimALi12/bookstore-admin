// ignore_for_file: avoid_print, invalid_use_of_protected_member

// import 'dart:io';

import 'package:adminpanel/utils/snackbarutils.dart';
// import 'package:adminpanel/views/displaycatscreen.dart';
import 'package:adminpanel/views/mainscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  var categoryData =
      <Map<String, dynamic>>[].obs; // To store fetched categories
  final TextEditingController categorycontroller = TextEditingController();
  var categories = <DocumentSnapshot>[].obs;
  final FirebaseFirestore firebase = FirebaseFirestore.instance;
  var isloading = false.obs;
  var categorydata = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchdata();
  }

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

  Future<void> fetchdata() async {
    try {
      isloading.value = true;
      final QuerySnapshot data = await firebase.collection("categories").get();

      if (data.docs.isNotEmpty) {
        List<Map<String, dynamic>> datalist = [];
        for (var doc in data.docs) {
          datalist.add(doc.data() as Map<String, dynamic>);
        }
        categorydata.value = datalist;
        categories.value = data.docs;
        isloading.value = false;

        print(categorydata.value.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addCategory() async {
    try {
      DocumentReference categoryRef =
          firebase.collection('categories').doc(categorycontroller.text.trim());
      DocumentSnapshot categoryDoc = await categoryRef.get();

      if (!categoryDoc.exists) {
        // If category doesn't exist, create it
        await categoryRef.set({'name': categorycontroller.text.trim()});
        SnackbarUtil.showSnackbar(
          "Success",
          "Category Created Successfully!!!",
          type: 'info',
        );

        categorycontroller.clear(); // Clear the text field

        // Navigate to the display categories page
        Get.off(() => const MainScreen());
      } else {
        // If category already exists
        SnackbarUtil.showSnackbar(
          "Error",
          "This Category Already Exists",
          type: 'error',
        );
      }

      fetchdata(); // Fetch the updated categories
    } catch (e) {
      SnackbarUtil.showSnackbar(
        "Error",
        "Something Went Wrong",
        type: 'error',
      );
    }
  }

  // Update category name
  Future<void> updatecategory(String catId, String newCatName) async {
    try {
      if (newCatName.isEmpty) {
        SnackbarUtil.showSnackbar(
          "Error",
          "New Category name con not be empty!",
          type: 'error',
        );
      } else {
        await FirebaseFirestore.instance
            .collection('categories')
            .doc(catId)
            .update({'name': newCatName});

        fetchdata();

        SnackbarUtil.showSnackbar(
          "Success",
          "Category Updated Successfully!",
          type: 'info',
        );
      }
    } catch (e) {
      SnackbarUtil.showSnackbar(
        "Error",
        "Error in Category Update!....",
        type: 'error',
      );
    }
  }

  Future<void> deleteCategory(String catId) async {
    try {
      await firebase.collection('categories').doc(catId).delete();
      fetchdata();

      SnackbarUtil.showSnackbar(
        "Success",
        "Category Deleted Successfully!",
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

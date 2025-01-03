import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
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
        await categoryRef.set({'name': categorycontroller.text.trim()});
        Get.snackbar("Success", "Category Added!!");
      } else {
        Get.snackbar("Error", "Category already exists");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updatecategory(String catId, String newCatName) async {
    try {
      await firebase
          .collection('categories')
          .doc(catId)
          .update({'name': newCatName});
      fetchdata();

      print("category update successfully.....");
      Get.snackbar("Success", "category updated successfully....");
    } catch (e) {
      print(e.toString());
      Get.snackbar("Error", "error in updation......");
    }
  }

  Future<void> deleteCategory(String catId) async {
    try {
      await firebase.collection('categories').doc(catId).delete();
      fetchdata();

      print("category Deleted successfully.....");
      Get.snackbar("Success", "category Deleted successfully....");
    } catch (e) {
      print(e.toString());
      Get.snackbar("Error", "error in Deletion......");
    }
  }
}

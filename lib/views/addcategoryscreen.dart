import 'package:adminpanel/controller/categorycontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final con = Get.put(CategoryController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Text(
              "Create Category",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
            TextField(
              controller: con.categorycontroller,
              decoration: const InputDecoration(hintText: "Add category name"),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  con.addCategory();
                },
                child: Text("Create"))
          ],
        ),
      ),
    );
  }
}

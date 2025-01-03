import 'package:adminpanel/controller/productcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductScreen extends StatelessWidget {
  final Map mylist;
  const AddProductScreen({super.key, required this.mylist});

  @override
  Widget build(BuildContext context) {
    final con = Get.put(ProductControlller());
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text(
              "Add Product",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              mylist['name'],
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: con.pnameController,
              decoration: InputDecoration(hintText: "Enter product"),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: con.pquantityController,
              decoration:
                  InputDecoration(hintText: "Enter product quantity..."),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: con.pdescController,
              decoration: InputDecoration(hintText: "Enter product desc..."),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  con.addProduct(mylist['name']);
                },
                child: Text("Create Product")),
          ],
        ),
      ),
    );
  }
}

import 'package:adminpanel/controller/productcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key, required this.catname});
  final String catname;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  Widget build(BuildContext context) {
    final con = Get.put(ProductControlller());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.catname,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: con.pnameController,
              decoration: const InputDecoration(hintText: "Enter product"),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: con.pdescController,
              decoration:
                  const InputDecoration(hintText: "Enter product desc..."),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: con.ppriceController,
              decoration:
                  const InputDecoration(hintText: "Enter product price"),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: con.pquantityController,
              decoration:
                  const InputDecoration(hintText: "Enter product quantity..."),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  con.addProduct(widget.catname);
                },
                child: const Text("Create Product")),
          ],
        ),
      ),
    );
  }
}

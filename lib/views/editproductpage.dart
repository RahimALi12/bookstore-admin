// ignore_for_file: prefer_const_constructors

import 'package:adminpanel/controller/productcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProductPage extends StatefulWidget {
  final String catname;
  final String productId;

  const EditProductPage(
      {super.key, required this.catname, required this.productId});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
// const _EditProductPageState(this.String cName , String cId);
  final TextEditingController pnameController = TextEditingController();
  final TextEditingController ppriceController = TextEditingController();
  final TextEditingController pquantityController = TextEditingController();
  final TextEditingController pdescController = TextEditingController();

  // For image management
  // File? selectedImage;
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  // // Load product details to pre-fill the form
  Future<void> _loadProductDetails() async {
    var productDoc = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.catname)
        .collection('products')
        .doc(widget.productId)
        .get();

    pnameController.text = productDoc['pname'];
    ppriceController.text = productDoc['pprice'].toString();
    pquantityController.text = productDoc['pquantity'].toString();
    pdescController.text = productDoc['pdesc'];
    imageUrl = productDoc['imagename']; // Get the existing image URL
    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    final con = Get.put(ProductController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display the current product image or a placeholder
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height *
                    0.3, // Adjust height based on screen size
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(image: NetworkImage(imageUrl)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height *
                        0.3, // Adjust height based on screen size
                    fit: BoxFit.cover, // Maintain aspect ratio without overflow
                  ),
                )),

            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  con.pickImage();
                },
                child: Text('Pick New Image')),
            SizedBox(height: 20),
            TextField(
                controller: pnameController,
                decoration: InputDecoration(labelText: 'Product Name')),
            TextField(
                controller: ppriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price')),
            TextField(
                controller: pquantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Quantity')),
            TextField(
                controller: pdescController,
                decoration: InputDecoration(labelText: 'Description')),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  final price = double.tryParse(ppriceController.text.trim());
                  final name = pnameController.text.trim();
                  final desc = pdescController.text.trim();
                  final quan = double.tryParse(pquantityController.text.trim());
                  con.editProduct(widget.catname, widget.productId, name, price,
                      quan, desc);
                },
                child: Text('Update Product')),
          ],
        ),
      ),
    );
  }
}

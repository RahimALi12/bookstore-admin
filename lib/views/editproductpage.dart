import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProductPage extends StatefulWidget {
  final String catname;
  final String productId;

  EditProductPage({required this.catname, required this.productId});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final TextEditingController pnameController = TextEditingController();
  final TextEditingController ppriceController = TextEditingController();
  final TextEditingController pquantityController = TextEditingController();
  final TextEditingController pdescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

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
  }

  Future<void> _updateProduct() async {
    double? price = double.tryParse(ppriceController.text);
    double? quantity = double.tryParse(pquantityController.text);
    String? pname = pnameController.text.trim();
    String? pdesc = pdescController.text.trim();

    if (pname.isEmpty || pdesc.isEmpty || price == null || quantity == null) {
      Get.snackbar("Error", "Please provide valid details");
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.catname)
          .collection('products')
          .doc(widget.productId)
          .update({
        'pname': pname,
        'pprice': price,
        'pquantity': quantity,
        'pdesc': pdesc,
      });
      Get.snackbar("Success", "Product Updated!");
      Navigator.pop(context);
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", "Failed to update product!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                onPressed: _updateProduct, child: Text('Update Product')),
          ],
        ),
      ),
    );
  }
}

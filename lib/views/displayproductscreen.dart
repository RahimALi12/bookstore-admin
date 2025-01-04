import 'package:adminpanel/controller/categorycontroller.dart';
import 'package:adminpanel/views/addproductscreen.dart';
import 'package:adminpanel/views/productcard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key, required this.catname});

  final String catname; // Category name passed to this page

  @override
  Widget build(BuildContext context) {
    final con = Get.put(CategoryController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Get.to(AddProductScreen(catname: catname));
          }),
      appBar: AppBar(
        title: Text('$catname Products'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('categories')
            .doc(catname)
            .collection('products')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products available.'));
          }

          // List of products retrieved from Firestore
          var products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              var productId = product.id; // Unique product ID
              var pname = product['pname'];
              var pprice = product['pprice'];
              var pquantity = product['pquantity'];
              var pdesc = product['pdesc'];

              return ProductCard(
                productId: productId,
                pname: pname,
                pprice: pprice,
                pquantity: pquantity,
                pdesc: pdesc,
                catname: catname,
              );
            },
          );
        },
      ),
    );
  }
}

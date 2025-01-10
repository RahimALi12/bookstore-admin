// import 'package:adminpanel/controller/categorycontroller.dart';
import 'package:adminpanel/views/addproductscreen.dart';
import 'package:adminpanel/views/productcard.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final con = Get.put(CategoryController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 32, 96, 214),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Get.to(const AddProductScreen());
          }),
      appBar: AppBar(
        title: Text(
          'Products',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 19,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
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
              var imagename = product['imagename'];
              // var imagename = product['imagename']; // Retrieve the image URL

              return ProductCard(
                productId: productId,
                pname: pname ?? 'Unknown',
                pprice: pprice ?? 0.0,
                pquantity: pquantity ?? 0.0,
                // catname: catname,
                pdesc: pdesc ?? 'No description',
                imagename: imagename ?? '', // Default to empty string if null
              );
            },
          );
        },
      ),
    );
  }
}

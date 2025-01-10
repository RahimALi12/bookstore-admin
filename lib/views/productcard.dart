// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:adminpanel/views/editproductpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.productId,
    required this.pname,
    required this.pprice,
    required this.pquantity,
    // required this.catname,
    required this.pdesc,
    required this.imagename, // Image URL
  });

  final String productId;
  final String pname;
  final double pprice;
  final double pquantity;
  // final String catname;
  final String pdesc;
  final String imagename; // Image URL

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: (imagename.isNotEmpty)
              ? Image.network(
                  imagename,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 60);
                  },
                )
              : const Icon(
                  Icons.image_not_supported,
                  size: 60,
                  color: Colors.grey,
                ),
        ),
        title: Text(
          pname,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Price: \$${pprice.toString()} | Quantity: $pquantity',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              // Navigate to the edit page (pass catname and productId)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductPage(
                    // catname: catname,
                    productId: productId,
                  ),
                ),
              );
            } else if (value == 'delete') {
              // Show confirmation dialog for deleting the product
              _showDeleteConfirmation(context, productId);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            // TextButton(
            //   onPressed: () async {
            //     await deleteProduct(productId);
            //     Navigator.pop(context);
            //   },
            //   child: Text('Delete'),
            // ),
          ],
        );
      },
    );
  }

  Future<void> deleteProduct(String catname, String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(catname)
          .collection('products')
          .doc(productId)
          .delete();
      Get.snackbar("Success", "Product Deleted!");
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", "Failed to delete product!");
    }
  }
}

import 'package:adminpanel/views/editproductpage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'dart:developer';

class ProductCard extends StatelessWidget {
  final String productId;
  final String pname;
  final double pprice;
  final double pquantity;
  final String pdesc;
  final String catname;

  ProductCard({
    required this.productId,
    required this.pname,
    required this.pprice,
    required this.pquantity,
    required this.pdesc,
    required this.catname,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 5,
      child: ListTile(
        title: Text(pname),
        subtitle: Text('Price: \$${pprice.toString()} | Quantity: $pquantity'),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              // Navigate to the edit page (pass catname and productId)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductPage(
                    catname: catname,
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
            TextButton(
              onPressed: () async {
                await deleteProduct(catname, productId);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
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

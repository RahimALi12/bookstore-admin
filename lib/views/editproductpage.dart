// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  // For image management
  File? selectedImage;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  // Load product details to pre-fill the form
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

  // Upload image to Cloudinary
  Future<String?> uploadImageToCloudinary() async {
    const String cloudName =
        "ddpvb0run"; // Replace with your Cloudinary cloud name
    const String uploadPreset = "images"; // Replace with your upload preset

    if (selectedImage == null) {
      return null; // No image selected, return null to keep the old image
    }

    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    try {
      final request = http.MultipartRequest('POST', url);
      request.fields['upload_preset'] = uploadPreset;

      request.files
          .add(await http.MultipartFile.fromPath('file', selectedImage!.path));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);

      if (response.statusCode == 200) {
        return jsonResponse['secure_url']; // Get the uploaded image URL
      } else {
        Get.snackbar("Error", "Upload failed: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to upload image: $e");
    }
    return null;
  }

  // Update product details in Firebase
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
      // Upload image to Cloudinary if a new image is selected
      String? newImageUrl = await uploadImageToCloudinary();
      newImageUrl ??= imageUrl; // If no new image selected, keep the old one

      // Log the image URL to see if it's getting updated
      log('New Image URL: $newImageUrl');

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
        'imagename': newImageUrl, // Save the new image URL
      });

      // Refresh UI after updating product
      setState(() {
        imageUrl = newImageUrl;
      });

      Get.snackbar("Success", "Product Updated!");
      Navigator.pop(context);
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", "Failed to update product!");
    }
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        setState(() {
          selectedImage = File(result.files.single.path!);
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e");
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
            // Display the current product image or a placeholder
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height *
                  0.3, // Adjust height based on screen size
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: selectedImage == null && imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: selectedImage == null
                  ? imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            imageUrl!,
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height *
                                0.3, // Adjust height based on screen size
                            fit: BoxFit
                                .cover, // Maintain aspect ratio without overflow
                          ),
                        )
                      : Container(height: 100, color: Colors.grey)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        selectedImage!,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height *
                            0.3, // Adjust height based on screen size
                        fit: BoxFit.cover, // Prevent overflow
                      ),
                    ),
            ),

            SizedBox(height: 10),
            ElevatedButton(
                onPressed: _pickImage, child: Text('Pick New Image')),
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
                onPressed: _updateProduct, child: Text('Update Product')),
          ],
        ),
      ),
    );
  }
}

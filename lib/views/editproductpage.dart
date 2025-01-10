// ignore_for_file: prefer_const_constructors

import 'package:adminpanel/controller/productcontroller.dart';
// import 'package:adminpanel/utils/formsutils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProductPage extends StatefulWidget {
  // final String catname;
  final String productId;

  const EditProductPage({super.key, required this.productId});

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
  String? selectedAuthor; // To store selected author
  List<String> authors = []; // List of authors (replace with your source)
  String? selectedCategory;
  List<String> categories = [];
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
    _loadCategories();
    _loadAuthors();
  }

  // // Load product details to pre-fill the form
  Future<void> _loadProductDetails() async {
    var productDoc = await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productId)
        .get();

    pnameController.text = productDoc['pname'];
    ppriceController.text = productDoc['pprice'].toString();
    pquantityController.text = productDoc['pquantity'].toString();
    pdescController.text = productDoc['pdesc'];
    imageUrl = productDoc['imagename']; // Get the existing image URL
    selectedAuthor = productDoc['author']; // Set existing author
    selectedCategory = productDoc['category'];
    setState(() {}); // Refresh the UI
  }

  Future<void> _loadAuthors() async {
    // Example: Fetch authors from Firebase
    var authorsSnapshot =
        await FirebaseFirestore.instance.collection('authors').get();
    authors =
        authorsSnapshot.docs.map((doc) => doc['auname'].toString()).toList();
    setState(() {});
  }

  Future<void> _loadCategories() async {
    try {
      // Fetch categories from Firestore
      var categoriesSnapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      categories =
          categoriesSnapshot.docs.map((doc) => doc['name'].toString()).toList();

      // Debugging: Check what data is being fetched
      print('Fetched categories: $categories');

      setState(() {});
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final con = Get.put(ProductController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Product',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 19,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display the current product image or a placeholder
            Center(
              child: Container(
                width: 100, // Full width of the screen
                height: 100, // Adjust height based on screen size
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit
                        .cover, // Ensures the image covers the area without stretching
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageUrl,
                    width: 100, // Full width of the screen
                    height:
                        100, // Adjust height based on screen size// Dynamic height based on screen size
                    fit: BoxFit
                        .cover, // Ensures the image maintains aspect ratio and fills the container
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  con.pickImage();
                },
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.deepOrange,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                ),
                child: Text('Pick New Image', style: TextStyle(fontSize: 16))),
            SizedBox(height: 16.0),

            // Product Name Field
            _buildTextField(pnameController, 'Product Name'),
            SizedBox(height: 16.0),

            // Price Field
            _buildTextField(ppriceController, 'Price', isNumber: true),
            SizedBox(height: 16.0),

            // Quantity Field
            _buildTextField(pquantityController, 'Quantity', isNumber: true),
            SizedBox(height: 16.0),

            // Description Field
            _buildTextField(pdescController, 'Description'),
            SizedBox(height: 16.0),

            // Author Dropdown
            authors.isEmpty
                ? CircularProgressIndicator()
                : _buildAuthorDropdown(),
            SizedBox(height: 1.0),

            // Category Dropdown
            categories.isEmpty
                ? CircularProgressIndicator()
                : _buildCategoryDropdown(),
            SizedBox(height: 1.0),

            // Update Button
            ElevatedButton(
                onPressed: () {
                  final price = double.tryParse(ppriceController.text.trim());
                  final name = pnameController.text.trim();
                  final desc = pdescController.text.trim();
                  final quan = double.tryParse(pquantityController.text.trim());
                  con.editProduct(widget.productId, name, price, quan, desc,
                      selectedAuthor ?? '', selectedCategory ?? '');
                },
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.deepOrange,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                ),
                child: Text('Update Product', style: TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }

  // Utility method for building TextFields
  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  // Utility method for building Author Dropdown
  Widget _buildAuthorDropdown() {
    return DropdownButton<String>(
      value: selectedAuthor,
      hint: Text('Select Author'),
      isExpanded: true,
      items: authors.map((author) {
        return DropdownMenuItem<String>(
          value: author,
          child: Text(author),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedAuthor = value;
        });
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButton<String>(
      value: selectedCategory,
      hint: Text('Select Category'),
      isExpanded: true,
      items: categories.map((category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
        });
      },
    );
  }
}

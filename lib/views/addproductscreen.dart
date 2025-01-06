import 'package:adminpanel/controller/authorcontroller.dart';
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
  void initState() {
    super.initState();
    final authcontroller = Get.put(AuthorController());
    // Fetch authors when the screen is initialized
    if (authcontroller.authorsList.isEmpty) {
      authcontroller.fetchAuthors();
    }
  }

  @override
  Widget build(BuildContext context) {
    final con = Get.put(ProductController());
    final authcontroller = Get.put(AuthorController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: SingleChildScrollView(
        // Prevents overflow by allowing scrolling
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              widget.catname,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildTextField(
                controller: con.pnameController, hintText: "Enter product"),
            const SizedBox(height: 15),
            _buildTextField(
                controller: con.pdescController,
                hintText: "Enter product desc..."),
            const SizedBox(height: 15),
            _buildTextField(
                controller: con.ppriceController,
                hintText: "Enter product price"),
            const SizedBox(height: 10),
            _buildTextField(
                controller: con.pquantityController,
                hintText: "Enter product quantity..."),
            const SizedBox(height: 10),
            Obx(() {
              // Check if the authors list is still empty or loading
              if (authcontroller.authorsList.isEmpty) {
                authcontroller.fetchAuthors(); // Fetch authors when empty
                return const Center(
                    child:
                        CircularProgressIndicator()); // Show loading indicator while fetching
              }

              // Return the Dropdown only when authors list is populated
              return DropdownButton<String>(
                hint: const Text('Select Author'),
                onChanged: (selectedAuthor) {
                  print("Selected author: $selectedAuthor");
                },
                items: authcontroller.authorsList.map((author) {
                  return DropdownMenuItem<String>(
                    value: author['auname'],
                    child: Row(
                      children: [
                        Image.asset(
                          author['imagename'] ??
                              'assets/images/logo.png', // Default image if imagename is null
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(width: 10),
                        Text(author['auname'] ??
                            "Default Author Name"), // To avoid null, add a default value
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
            Obx(() {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await con.pickImage();
                    },
                    child: Container(
                      width: double.infinity, // Make it responsive
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: con.selectedFile.value != null
                              ? Colors.green
                              : Colors.grey,
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 2,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: con.selectedFile.value != null
                            ? Image.file(
                                con.selectedFile.value!,
                                fit: BoxFit.cover,
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(child: Icon(Icons.add_a_photo)),
                                  Text("Tap To Select a image",
                                      style: TextStyle(fontSize: 15)),
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    con.selectedFileName.value.isNotEmpty
                        ? con.selectedFileName.value
                        : "Tap To Select Image..",
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              );
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                con.addProduct(widget.catname);
              },
              child: const Text("Create Product"),
            ),
          ],
        ),
      ),
    );
  }

  // Custom method to avoid repeating code for text fields
  Widget _buildTextField(
      {required TextEditingController controller, required String hintText}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
    );
  }
}

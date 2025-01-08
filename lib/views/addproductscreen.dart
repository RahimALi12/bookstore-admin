import 'package:adminpanel/controller/authorcontroller.dart';
import 'package:adminpanel/controller/productcontroller.dart';
import 'package:adminpanel/utils/formsutils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
        title: Text(
          "Add Product",
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Color.fromARGB(228, 255, 255, 255)),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              widget.catname,
              style: headingTextStyle(),
            ),
            const SizedBox(height: 15),
            _buildTextField(
                controller: con.pnameController,
                hintText: "Enter product name"),
            const SizedBox(height: 15),
            _buildTextField(
                controller: con.pdescController,
                hintText: "Enter product description"),
            const SizedBox(height: 15),
            _buildTextField(
                controller: con.ppriceController,
                hintText: "Enter product price"),
            const SizedBox(height: 10),
            _buildTextField(
                controller: con.pquantityController,
                hintText: "Enter product quantity"),
            const SizedBox(height: 10),
            Obx(() {
              if (authcontroller.isloading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (authcontroller.authorsList.isEmpty) {
                return const Text("No authors available");
              }

              // return DropdownButton<String>(
              //   hint: const Text('Select Author'),
              //   value: con.selectedAuthor.value.isNotEmpty
              //       ? con.selectedAuthor.value
              //       : null,
              //   onChanged: (selectedAuthor) {
              //     con.selectedAuthor.value = selectedAuthor ?? '';
              //   },
              //   items: authcontroller.authorsList.map((author) {
              //     return DropdownMenuItem<String>(
              //       value: author['auname'],
              //       child: Row(
              //         children: [
              //           const SizedBox(width: 10),
              //           Text(author['auname'] ?? "Default Author Name"),
              //         ],
              //       ),
              //     );
              //   }).toList(),
              // );
              return dropdownButtonStyle(
                hintText: 'Select Author',
                selectedValue: con.selectedAuthor.value.isNotEmpty
                    ? con.selectedAuthor.value
                    : null,
                onChanged: (selectedAuthor) {
                  con.selectedAuthor.value = selectedAuthor ?? '';
                },
                authorsList: authcontroller.authorsList,
              );
            }),
            const SizedBox(height: 20),
            Obx(() {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await con.pickImage();
                    },
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 60,
                        decoration: imagePickerDecoration(
                            con.selectedFile.value != null),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: con.selectedFile.value != null
                              ? Image.file(con.selectedFile.value!,
                                  fit: BoxFit.cover)
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Center(
                                        child: Icon(Icons.add_a_photo)),
                                    Text(
                                      con.selectedFileName.value.isNotEmpty
                                          ? con.selectedFileName.value
                                          : "Tap to Select Image",
                                      style: imagetext(),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                con.addProduct(widget.catname);
              },
              style: elevatedButtonStyle(),
              child: Text(
                "Create Product", // Button text
                style: buttonTextStyle(), // Apply button text style here
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String hintText}) {
    return TextField(
      controller: controller,
      decoration: inputFieldDecoration(hintText),
      style: const TextStyle(
          color: Colors.black87), // Dark text color for readability
    );
  }
}

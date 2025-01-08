import 'package:adminpanel/controller/categorycontroller.dart';
import 'package:adminpanel/views/addcategoryscreen.dart';
import 'package:adminpanel/views/displayproductscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DisplayCatScreen extends StatelessWidget {
  const DisplayCatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final con = Get.put(CategoryController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Categories",
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Color.fromARGB(228, 255, 255, 255)),
        ),
        centerTitle: true,
        backgroundColor:
            const Color.fromARGB(255, 132, 76, 211), // Matches bottom nav theme
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(() {
                if (con.isloading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (con.categorydata.isEmpty) {
                  return const Center(
                    child: Text(
                      "No categories available",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: con.categorydata.length,
                  itemBuilder: (context, index) {
                    var category = con.categorydata[index];
                    var cId = con.categories[index].id;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        title: Text(
                          category['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            category['name'][0].toUpperCase(),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.to(
                                    ProductListPage(catname: category['name']));
                              },
                              icon: const Icon(Icons.remove_red_eye,
                                  color: Colors.green),
                              tooltip: "View Products",
                            ),
                            IconButton(
                              onPressed: () async {
                                final newName = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    final controller = TextEditingController(
                                        text: category['name']);
                                    return AlertDialog(
                                      title: const Text("Edit Category"),
                                      content: TextField(
                                        controller: controller,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Category Name",
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Cancel"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            con.updatecategory(
                                              cId,
                                              controller.text,
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Save"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (newName != null &&
                                    newName != category['name']) {
                                  await con.updatecategory(cId, newName.trim());
                                }
                              },
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              tooltip: "Edit Category",
                            ),
                            IconButton(
                              onPressed: () async {
                                final confirmed = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Delete Category"),
                                    content: const Text(
                                      "Are you sure you want to delete this category?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 237, 231, 231),
                                        ),
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed == true) {
                                  await con.deleteCategory(cId);
                                }
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: "Delete Category",
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const AddCategoryScreen());
        },
        backgroundColor: const Color.fromARGB(255, 132, 76, 211),
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: "Create Category",
      ),
    );
  }
}

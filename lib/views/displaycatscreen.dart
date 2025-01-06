// import 'dart:js_interop';

import 'package:adminpanel/controller/categorycontroller.dart';
import 'package:adminpanel/views/addcategoryscreen.dart';
import 'package:adminpanel/views/createauthor.dart';
import 'package:adminpanel/views/displayautscreen.dart';
import 'package:adminpanel/views/displayproductscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisplayCatScreen extends StatelessWidget {
  const DisplayCatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final con = Get.put(CategoryController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              if (con.isloading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (con.categorydata.isEmpty) {
                return const Text("There is no data");
              }
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: con.categorydata.length,
                  itemBuilder: (context, index) {
                    var category = con.categorydata[index];
                    var cId = con.categories[index].id;
                    return Row(
                      children: [
                        Text(
                          category['name'],
                          style: const TextStyle(
                            height: 3,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          onPressed: () {
                            Get.to(ProductListPage(catname: category['name']));
                          },
                          icon: const Icon(Icons.remove_red_eye),
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
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Cancel")),
                                        TextButton(
                                            onPressed: () {
                                              con.updatecategory(
                                                cId,
                                                controller.text,
                                              );
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Save")),
                                      ],
                                    );
                                  });
                              if (newName != null &&
                                  newName != category['name']) {
                                await con.updatecategory(cId, newName.trim());
                              }
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        IconButton(
                            onPressed: () async {
                              final confirmed = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text("Delete Category"),
                                        content: const Text(
                                            "Are you sure you want to delete category ?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text("Cancel")),
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text("Delete")),
                                        ],
                                      ));
                              if (confirmed == true) {
                                await con.deleteCategory(cId);
                              }
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    );
                  });
            }),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Get.to(const AddCategoryScreen());
                },
                child: const Text("Create Category")),
            ElevatedButton(
                onPressed: () {
                  Get.to(const AddAuthorScreen());
                },
                child: const Text("Authors")),
            ElevatedButton(
                onPressed: () {
                  Get.to(AuthorListScreen());
                },
                child: const Text("Authors List")),
          ],
        ),
      ),
    );
  }
}

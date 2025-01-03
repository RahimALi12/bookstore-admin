import 'package:adminpanel/controller/categorycontroller.dart';
import 'package:adminpanel/views/addcategoryscreen.dart';
import 'package:adminpanel/views/addproductscreen.dart';
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
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: con.categorydata.length,
                  itemBuilder: (context, index) {
                    var category = con.categorydata[index];
                    var cId = con.categories[index].id;
                    return Row(
                      children: [
                        Text(
                          category['name'],
                          style: TextStyle(
                              height: 3,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Get.to(AddProductScreen(
                                mylist: category,
                              ));
                            },
                            child: Text("Add Category")),
                        IconButton(
                            onPressed: () async {
                              final newName = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    final controller = TextEditingController(
                                        text: category['name']);
                                    return AlertDialog(
                                      title: Text("Edit Category"),
                                      content: TextField(
                                        controller: controller,
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("Cancel")),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("Save")),
                                      ],
                                    );
                                  });
                              if (newName != null &&
                                  newName != category['name']) {
                                await con.updatecategory(cId, newName.trim());
                              }
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        IconButton(
                            onPressed: () async {
                              final confirmed = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Delete Category"),
                                        content: Text(
                                            "Are you sure you want to delete category ?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: Text("Cancel")),
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: Text("Delete")),
                                        ],
                                      ));
                              if (confirmed == true) {
                                await con.deleteCategory(cId);
                              }
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    );
                  });
            }),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Get.to(AddCategoryScreen());
                },
                child: Text("Create Category")),
          ],
        ),
      ),
    );
  }
}

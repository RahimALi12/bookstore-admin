import 'package:adminpanel/views/addcategoryscreen.dart';
import 'package:adminpanel/views/editauthorpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:adminpanel/controller/categorycontroller.dart';
import 'package:adminpanel/controller/authorcontroller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'createauthor.dart';

class AdminHomePage extends StatelessWidget {
  AdminHomePage({super.key});

  final categoryController = Get.put(CategoryController());
  final authorController = Get.put(AuthorController());

  @override
  Widget build(BuildContext context) {
    categoryController.fetchdata();
    authorController.fetchAuthors();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Dashboard",
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Color.fromARGB(228, 255, 255, 255)),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: const Color.fromARGB(255, 32, 96, 214),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Section
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     _buildSummaryCard(
              //         title: "Categories",
              //         count: categoryController.categories.length,
              //         color: Colors.blue),
              //     _buildSummaryCard(
              //         title: "Authors",
              //         count: authorController.authorsList.length,
              //         color: Colors.green),
              //     _buildSummaryCard(
              //         title: "Total Posts", count: 128, color: Colors.orange),
              //   ],
              // ),
              const SizedBox(height: 20),

              // Categories Section
              _buildSectionTitle("Categories"),
              Obx(() {
                if (categoryController.isloading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (categoryController.categories.isEmpty) {
                  return const Text(
                    "No categories available",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  );
                }

                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: categoryController.categories
                      .map((category) => _buildCategoryCard(category))
                      .toList(),
                );
              }),
              const SizedBox(height: 30),

              // Authors Section
              _buildSectionTitle("Authors"),
              Obx(() {
                if (authorController.isloading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (authorController.authorsList.isEmpty) {
                  return const Text(
                    "No authors available",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  );
                }

                return Column(
                  children: authorController.authorsList
                      .map((author) => _buildAuthorRow(author))
                      .toList(),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "addCategory",
            backgroundColor: const Color.fromARGB(255, 32, 96, 214),
            onPressed: () {
              Get.to(const AddCategoryScreen());
            },
            child: const Icon(
              Icons.category,
              color: Colors.white,
            ),
            tooltip: 'Add Category',
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "addAuthor",
            backgroundColor: const Color.fromARGB(255, 32, 96, 214),
            onPressed: () {
              Get.to(const AddAuthorScreen());
            },
            child: const Icon(
              Icons.person_add,
              color: Colors.white,
            ),
            tooltip: 'Add Author',
          ),
        ],
      ),
    );
  }

  // Summary Card Widget
  Widget _buildSummaryCard(
      {required String title, required int count, required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  // Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // Category Card Widget
  Widget _buildCategoryCard(category) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        category['name'] ?? "Unnamed Category",
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }

  // Author Row Widget
  Widget _buildAuthorRow(author) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipOval(
            child: author['imagename'] != null
                ? Image.network(
                    author['imagename'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              author['auname'] ?? "Unknown Author",
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              Get.to(() => EditAuthorPage(authorId: author['id']));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Delete Author
            },
          ),
        ],
      ),
    );
  }
}

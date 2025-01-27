import 'package:adminpanel/views/addcategoryscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:adminpanel/controller/categorycontroller.dart';
import 'package:adminpanel/controller/authorcontroller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'createauthor.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final categoryController = Get.put(CategoryController());

  final authorController = Get.put(AuthorController());

  @override
  void initState() {
    super.initState();

    categoryController.fetchdata();
    authorController.fetchAuthors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Panel',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 32, 96, 214),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Section
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryCard(
                        title: "Categories",
                        count: categoryController.categories.length,
                        color: const Color.fromARGB(255, 32, 96, 214)),
                    const SizedBox(
                      width: 10,
                    ),
                    _buildSummaryCard(
                        title: "Authors",
                        count: authorController.authorsList.length,
                        color: const Color.fromARGB(255, 32, 96, 214)),
                    // _buildSummaryCard(
                    //     title: "Total Posts", count: 128, color: Colors.orange),
                  ],
                );
              }),

              const SizedBox(height: 20),

              // Categories Horizontal Scroll
              Obx(() {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryController.categorydata.length,
                    itemBuilder: (context, index) {
                      var category = categoryController.categorydata[index];
                      return GestureDetector(
                        onTap: () {
                          categoryController
                              .fetchdata(); // Load products for selected category
                        },
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 32, 96, 214),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              category['name'] ?? 'Category',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(
                height: 20,
              ),

              // Authors Section
              _buildSectionTitle("Authors"),
              Divider(),
              Obx(() {
                if (authorController.isloading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (authorController.authorsList.isEmpty) {
                  return Text(
                    "No authors available",
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 13, color: Colors.grey),
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
    );
  }

  // Summary Card Widget
  Widget _buildSummaryCard(
      {required String title, required int count, required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 32, 96, 214),
          borderRadius: BorderRadius.circular(12),
          // ignore: deprecated_member_use
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: const Color.fromARGB(221, 238, 233, 233)),
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
      style: GoogleFonts.plusJakartaSans(
        fontSize: 19,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 32, 96, 214),
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
        style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.black87),
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
              style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

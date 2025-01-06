import 'package:adminpanel/controller/authorcontroller.dart';
import 'package:adminpanel/views/createauthor.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthorListScreen extends StatefulWidget {
  const AuthorListScreen({super.key});

  @override
  State<AuthorListScreen> createState() => _AuthorListScreenState();
}

class _AuthorListScreenState extends State<AuthorListScreen> {
  @override
  Widget build(BuildContext context) {
    final con = Get.put(AuthorController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Author List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          // Fetching author data from controller
          if (con.authors.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              crossAxisSpacing: 10, // space between items horizontally
              mainAxisSpacing: 10, // space between items vertically
              childAspectRatio: 0.8, // Aspect ratio of each item
            ),
            itemCount: con.authors.length,
            itemBuilder: (context, index) {
              var author = con.authors[index];
              return Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: author['imagename'] != null
                              ? Image.network(
                                  author['imagename'],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Row(
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  // Edit functionality (navigate to edit page)
                                  // Get.to(AddAuthorScreen(authorId: author.id));
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Delete functionality
                                  // con.deleteAuthor(author.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      author['auname'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Author screen
          Get.to(const AddAuthorScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

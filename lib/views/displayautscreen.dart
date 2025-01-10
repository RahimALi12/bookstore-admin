import 'package:adminpanel/controller/authorcontroller.dart';
import 'package:adminpanel/views/createauthor.dart';
import 'package:adminpanel/views/editauthorpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthorListScreen extends StatefulWidget {
  const AuthorListScreen({super.key});

  @override
  State<AuthorListScreen> createState() => _AuthorListScreenState();
}

class _AuthorListScreenState extends State<AuthorListScreen> {
  @override
  Widget build(BuildContext context) {
    final con = Get.put(AuthorController());
    con.fetchAuthors();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Authors",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 19,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Obx(() {
          if (con.isloading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (con.authorsList.isEmpty) {
            return const Center(
              child: Text(
                "No authors found",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: con.authorsList.length,
            itemBuilder: (context, index) {
              var author = con.authorsList[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(16),
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
                child: Row(
                  children: [
                    // Author Image
                    ClipOval(
                      child: author['imagename'] != null
                          ? Image.network(
                              author['imagename'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),
                    // Author Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            author['auname'] ?? "Unknown Author",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Icons
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Edit Icon
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Color.fromARGB(255, 39, 126, 176)),
                          onPressed: () {
                            Get.to(
                                () => EditAuthorPage(authorId: author['id']));
                          },
                        ),
                        // Delete Icon
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Color.fromARGB(225, 255, 17, 0)),
                          onPressed: () async {
                            final confirmed = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Delete Author"),
                                content: const Text(
                                    "Are you sure you want to delete this author?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              await con.deleteAuthor(author['id']);
                            }
                          },
                        ),
                      ],
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
          Get.to(const AddAuthorScreen());
        },
        backgroundColor: const Color.fromARGB(255, 32, 96, 214),
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: "Create Author",
      ),
    );
  }
}

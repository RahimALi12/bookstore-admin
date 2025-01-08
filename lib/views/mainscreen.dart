import 'package:adminpanel/views/displayautscreen.dart';
import 'package:adminpanel/views/displaycatscreen.dart';
import 'package:adminpanel/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // Profile Screen

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Active tab index

  // Pages list
  final List<Widget> _pages = [
    AdminHomePage(),
    const DisplayCatScreen(),
    const AuthorListScreen(),
    // const (),
  ];

  // Background colors for each page
  // final List<Color> _backgroundColors = [
  //   Colors.green, // HomeScreen background
  //   Colors.purple, // BooksScreen background
  //   Colors.orange, // CartScreen background
  //   Colors.cyan, // ProfileScreen background
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Float navigation bar
      body: Stack(
        children: [
          // Page Content
          Container(
            // color: _backgroundColors[_currentIndex], // Dynamic page background
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 0), // Adjust content height
              child: SafeArea(
                child: _pages[_currentIndex], // Show current page
              ),
            ),
          ),
          // Curved Navigation Bar
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex, // Active index
        height: 55, // Navigation bar height
        backgroundColor: Colors.transparent, // Transparent to avoid overlap
        color: const Color.fromARGB(255, 132, 76, 211), // Bar color
        buttonBackgroundColor: const Color.fromARGB(255, 132, 76, 211),
        // Active icon background
        animationDuration:
            const Duration(milliseconds: 700), // Smooth animation
        animationCurve: Curves.easeInOut, // Animation curve
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Change active index
          });
        },
        items: const [
          Icon(Icons.home, size: 23, color: Colors.white),
          Icon(Icons.menu_book, size: 23, color: Colors.white),
          Icon(Icons.shopping_cart, size: 23, color: Colors.white),
          // Icon(Icons.person, size: 23, color: Colors.white),
        ],
      ),
    );
  }
}

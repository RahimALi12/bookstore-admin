import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

DropdownButton<String> AuthordropdownButtonStyle({
  required String hintText,
  required String? selectedValue,
  required Function(String?) onChanged,
  required List<Map<String, dynamic>> authorsList,
}) {
  return DropdownButton<String>(
    hint: Text(hintText),
    value: selectedValue?.isNotEmpty ?? false ? selectedValue : null,
    onChanged: onChanged,
    icon: const Icon(Icons.arrow_drop_down,
        color: Colors.blue), // Custom icon color
    isExpanded: true, // Make the dropdown take full width
    style: TextStyle(
      color: Colors.black87, // Text color for the selected value
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    underline: Container(
      height: 1,
      color: Colors.blue.shade300, // Border color below the dropdown
    ),
    // decoration: BoxDecoration(
    //   borderRadius: BorderRadius.circular(12),
    //   border: Border.all(color: Colors.blue.shade300, width: 1), // Border around the dropdown
    //   color: Colors.white,
    // ),
    items: authorsList.map((author) {
      return DropdownMenuItem<String>(
        value: author['auname'],
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            children: [
              Text(
                author['auname'] ?? "Default Author Name",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87, // Text color for each item
                ),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

DropdownButton<String> CategorydropdownButtonStyle({
  required String hintText,
  required String? selectedValue,
  required Function(String?) onChanged,
  required List<Map<String, dynamic>> categorydata,
}) {
  return DropdownButton<String>(
    hint: Text(hintText),
    value: selectedValue?.isNotEmpty ?? false ? selectedValue : null,
    onChanged: onChanged,
    icon: const Icon(Icons.arrow_drop_down,
        color: Colors.blue), // Custom icon color
    isExpanded: true, // Make the dropdown take full width
    style: TextStyle(
      color: Colors.black87, // Text color for the selected value
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    underline: Container(
      height: 1,
      color: Colors.blue.shade300, // Border color below the dropdown
    ),
    // decoration: BoxDecoration(
    //   borderRadius: BorderRadius.circular(12),
    //   border: Border.all(color: Colors.blue.shade300, width: 1), // Border around the dropdown
    //   color: Colors.white,
    // ),
    items: categorydata.map((category) {
      return DropdownMenuItem<String>(
        value: category['name'],
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            children: [
              Text(
                category['name'] ?? "Default Category Name",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87, // Text color for each item
                ),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

// Custom text style for headings with a clean, modern look
TextStyle headingTextStyle() {
  return const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: Colors.black87,
    letterSpacing: 1.5,
    fontFamily: 'Roboto',
  );
}

// Regular text style with a soft touch for better readability
TextStyle regularTextStyle() {
  return const TextStyle(
    fontSize: 18,
    color: Colors.black87,
    letterSpacing: 0.5,
    fontFamily: 'Roboto',
  );
}

TextStyle imagetext() {
  return const TextStyle(
    fontSize: 12,
    color: Colors.black87,
    letterSpacing: 0.5,
    fontFamily: 'Roboto',
  );
}

// Button text style with a bolder and more prominent look
TextStyle buttonTextStyle() {
  return GoogleFonts.notoSansNKo(
    fontSize: 15,
    color: Colors.white,
  );
}

// Input field decoration with a more elegant and contemporary style
InputDecoration inputFieldDecoration(String hintText) {
  return InputDecoration(
    labelText: hintText,
    labelStyle: TextStyle(color: Colors.grey.shade400), // Default label color
    hintStyle:
        TextStyle(color: Colors.grey.shade400), // Default hint text color
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide:
          BorderSide(color: Colors.grey.shade300), // Default border color
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
          color: Color(0xFF2060D6), width: 2), // Focused border color
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
          color: Colors.grey.shade300), // Default enabled border color
    ),
    // focusedLabelStyle: const TextStyle(
    //   color: Color(0xFF2060D6), // Focused label color
    //   fontWeight: FontWeight.bold,
    // ),
    // labelStyle: TextStyle(
    //   color: Colors.grey.shade400, // Normal label color
    // ),
  );
}

// Elevated button style with smooth gradient and shadow effects
ButtonStyle elevatedButtonStyle() {
  return ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
    backgroundColor: const Color(0xFF2060D6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 6,
    shadowColor: Colors.blueAccent.withOpacity(0.4),
  ).copyWith(
    textStyle: MaterialStateProperty.all(
      TextStyle(
        color: const Color.fromARGB(
            255, 255, 255, 255), // Set the text color to white
        fontSize: 16, // Optional: Adjust font size
      ),
    ),
  );
}

// Image picker container with a modern gradient and shadow effects
BoxDecoration imagePickerDecoration(bool isImageSelected) {
  return BoxDecoration(
    color: Colors.grey[200],
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: isImageSelected ? Colors.green : Colors.blue.shade200,
      width: 3,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        spreadRadius: 3,
        blurRadius: 20,
      ),
    ],
    gradient: LinearGradient(
      colors: isImageSelected
          ? [Colors.green.shade200, Colors.green.shade300]
          : [Colors.blue.shade50, Colors.blue.shade100],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}

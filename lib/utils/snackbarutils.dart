import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarUtil {
  /// Show a custom Snackbar based on the type
  static void showSnackbar(String title, String message,
      {String type = 'info'}) {
    // Styling variables
    Color backgroundColor;
    IconData icon;

    // Define styles for each type
    switch (type) {
      case 'success':
        backgroundColor = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case 'error':
        backgroundColor = Colors.red;
        icon = Icons.error_outline;
        break;
      case 'warning':
        backgroundColor = Colors.amber;
        icon = Icons.warning_amber_outlined;
        break;
      case 'info':
      default:
        backgroundColor = Colors.blue;
        icon = Icons.info_outline;
        break;
    }

    // Display the Snackbar
    Get.snackbar(
      title, // Title of the Snackbar
      message, // Message content
      snackPosition: SnackPosition.BOTTOM, // Position of the Snackbar
      backgroundColor:
          backgroundColor.withOpacity(0.9), // Background color with opacity
      colorText: Colors.white, // Text color (white for contrast)
      icon: Icon(icon, color: Colors.white, size: 30), // Icon with size
      duration: Duration(seconds: 3), // Duration of the Snackbar
      margin: EdgeInsets.symmetric(
          horizontal: 20, vertical: 10), // Margin around the Snackbar
      borderRadius: 15, // Rounded corners for a smooth look
      barBlur: 5, // Background blur effect to give a soft touch
      isDismissible: true, // Allow manual dismissal
      forwardAnimationCurve:
          Curves.fastOutSlowIn, // Smooth animation for showing
      reverseAnimationCurve:
          Curves.fastOutSlowIn, // Smooth animation for hiding
      snackStyle:
          SnackStyle.FLOATING, // Make the Snackbar float for better visibility
      padding: EdgeInsets.symmetric(
          horizontal: 20, vertical: 10), // Add padding inside the Snackbar
      borderWidth: 2, // Border width to highlight the Snackbar
      borderColor:
          Colors.white.withOpacity(0.6), // Border color with transparency
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2), // Light shadow for depth
          blurRadius: 8,
          offset: Offset(0, 4), // Shadow direction
        ),
      ],
    );
  }
}

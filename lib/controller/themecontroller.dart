import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var themeMode = ThemeMode.system;

  void changeTheme(ThemeMode mode) {
    themeMode = mode;
    Get.changeThemeMode(mode);
    update(); // Refresh the UI
  }
}

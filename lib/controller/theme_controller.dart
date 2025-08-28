import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ThemeController extends GetxController {
  ThemeMode get theme => ThemeMode.light;
  bool get isDarkMode => false;

  void toggleTheme() {
    update();
  }
}

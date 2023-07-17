import 'package:flutter/material.dart';
import 'package:get/get.dart';

TextStyle get bold {
  return TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  );
}

TextStyle get w700 {
  return TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  );
}

TextStyle get w100 {
  return TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w100,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  );
}

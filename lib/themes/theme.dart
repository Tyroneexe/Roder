import 'package:flutter/material.dart';
import 'package:get/get.dart';

// App Colors

// Blue Color Tints
const Color darkbl50 = Color(0xFF092068);
const Color darkbl40 = Color(0xFF0b267d);
const Color blueClr = Color(0xFF123fd0);
const Color lightBlueClr = Color(0xFF03D3F2);
// Colors
const Color catalinaBlue = Color(0xFF042A73);
const Color iceCold = Color(0xFFA4EAF4);
const Color vBlue = Color(0xFF055777);
// Construction Colors
const Color rred = Color(0xFFFF2400);
const Color darkGr = Color(0xFF1d855e);
const Color sandyClr = Color(0xFFD0B59A);
const Color purple = Color(0xFF7c14ff);
// Yellow Theme Colors
const Color oRange = Color(0xFFf9be0d);
const Color lightOrange = Color(0xFFFFB952);
const Color skinOrange = Color(0xFFFFBA84);
// Red Theme Colors
const Color themeRed = Color(0xFFef6448);
//const Color rred = Color(0xFFFF2400);
const Color darkRed = Color(0xFF660000);
// Filter Button for Home Page
const Color btnBlueClr = Color(0xFF315099);
const Color outlineBtnClr = Color(0xFF6A92F0);
const Color unselectedBtnClr = Color(0xFFD8E0F2);
// Notifications
const Color oldNotis = Color(0xFFF5F8FF);
const Color newNotis = Color(0xFFE9EEFB);
const Color textNotis = Color(0xFF5F6677);
// Search Page
const Color searchBarClr = Color(0xFFE2EAFA);
const Color searchBarTxtClr = Color(0xFFAEC3EE);
const Color recentTxtClr = Color(0xFF757575);
// Nav
const Color dividerClr = Color(0xFFD1DEFA);
const Color switchClr = Color(0xFFADB6CC);
const Color navBarBkgClr = Color(0xFFe7eeff);
// About Us
const Color infoPopUpClr = Color(0xFFF6F9FF);

//
const primaryClr = blueClr;

const bkgClr = Color.fromARGB(250, 250, 250, 255);

class Themes {
  static final light = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light()
        .copyWith(
          primary: primaryClr,
        )
        .copyWith(
          background: bkgClr,
        ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark()
        .copyWith(
          primary: Colors.grey[850],
        )
        .copyWith(
          background: Colors.grey[850],
        ),
  );
}

TextStyle get actPageTxt {
  return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w700,
      fontSize: 16,
      color: Colors.black);
}

TextStyle get roRegular14 {
  return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w700,
      fontSize: 14,
      color: Colors.black);
}

TextStyle get headingStyle {
  return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.bold,
      fontSize: 35,
      color: Get.isDarkMode ? Colors.white : Colors.black);
}

TextStyle get subHeadingStyle {
  return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: Get.isDarkMode ? Colors.grey[400] : Colors.grey);
}

TextStyle get titleStyle {
  return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 20,
      color: Get.isDarkMode ? Colors.white : Colors.black);
}

TextStyle get tyStyle {
  return const TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 17,
      color: Colors.white);
}

TextStyle get subTitleStyle {
  return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600]);
}

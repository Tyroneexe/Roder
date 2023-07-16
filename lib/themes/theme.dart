import 'package:flutter/material.dart';
import 'package:get/get.dart';

// App Colors
const Color blueClr = Color(0xFF315099);

// Construction Colors
const Color rred = Color(0xFFFE0000);
const Color sandyClr = Color(0xFFD0B59A);
// Notifications
const Color textNotis = Color(0xFF5F6677);
// Search Page
const Color searchBarClr = Color(0xFFE2EAFA);
const Color recentTxtClr = Color(0xFF757575);
// Nav
const Color switchClr = Color(0xFFADB6CC);

//Light blue color
const Color newNotis = Color(0xFFE9EEFB);
const Color dividerClr = Color(0xFFD1DEFA);
const Color infoPopUpClr = Color(0xFFF6F9FF);
const Color navBarBkgClr = Color(0xFFe7eeff);
const Color searchBarTxtClr = Color(0xFFAEC3EE);
const Color outlineBtnClr = Color(0xFF6A92F0);
const Color unselectedBtnClr = Color(0xFFD8E0F2);
const Color countryRideListClr = Color(0xFFA5BDF8);
const Color oldNotis = Color(0xFFF5F8FF);

//  Dark mode Colors
//Navbar Colors
const Color navBarSelectedIcon = Color(0xFF7098F6);
const Color navBarBackgroundClr = Color(0xFF282828);
const Color rideFilterDark = Color(0xFF282828);

const bkgClr = Color.fromARGB(250, 250, 250, 255);

class Themes {
  static final light = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light()
        .copyWith(
          primary: blueClr,
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

TextStyle get rideListItemTxt {
  return TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w100,
    fontSize: 14,
    color: Colors.white,
  );
}

TextStyle get roRegular14 {
  return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w700,
      fontSize: 14,
      color: Colors.black);
}


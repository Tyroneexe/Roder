import 'package:flutter/material.dart';
import 'colors.dart';

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




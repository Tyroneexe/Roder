import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/theme.dart';

class ColorProvider with ChangeNotifier {
  int _selectedColor = 0;
  Color _mainColor = Colors.blue;

  int get selectedColor => _selectedColor;

  set selectedColor(int index) {
    _selectedColor = index;
    _saveColor();
    notifyListeners();
  }

  Color get mainColor => _mainColor;

  Future<void> init() async {
    await _getColor();
    notifyListeners();
  }

  Future<void> _saveColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('_selectedColorKey', _selectedColor);
  }

  Future<void> _getColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedSelectedColor = prefs.getInt('_selectedColorKey');
    if (savedSelectedColor != null) {
      _selectedColor = savedSelectedColor;
      _getMainClr(savedSelectedColor); // Update the _mainColor field
    }
  }

  void _getMainClr(int no) {
    switch (no) {
      case 0:
        _mainColor = lightBlueClr;
        break;
      case 1:
        _mainColor = oRange;
        break;
      case 2:
        _mainColor = themeRed;
        break;
      default:
        _mainColor = lightBlueClr;
    }
  }
}

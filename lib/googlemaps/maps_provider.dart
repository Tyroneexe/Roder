import 'package:flutter/material.dart';

class ControllerProvider extends ChangeNotifier {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  // SearchBarController _fromController = SearchBarController();
  // SearchBarController _toController = SearchBarController();

  void updateFrom(String value) {
    fromController.text = value;
    notifyListeners();
  }

  void updateTo(String value) {
    toController.text = value;
    notifyListeners();
  }
}

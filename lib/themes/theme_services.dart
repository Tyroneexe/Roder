import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);
  //isJoined

  bool _loadThemeFormBox() => _box.read(_key) ?? false;
  ThemeMode get theme => _loadThemeFormBox() ? ThemeMode.dark : ThemeMode.light;
  void switchTheme() {
    Get.changeThemeMode(_loadThemeFormBox() ? ThemeMode.light : ThemeMode.dark);

    _saveThemeToBox(!_loadThemeFormBox());
  }
}

// ignore_for_file: unused_import, empty_constructor_bodies
import 'dart:typed_data';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:roder/googlemaps/maps.dart';
import 'package:roder/login/google_sign_in.dart';
import 'package:roder/provider/clrProvider.dart';
import 'package:roder/themes/theme_services.dart';
import 'package:roder/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'googlemaps/maps_provider.dart';
import 'login/login.dart';
import 'navbar/navbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //
  await loadFont();
  //
  await GetStorage.init();
  //
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'channelKey',
        channelName: 'channelName',
        channelDescription: 'channelDescription',
      )
    ],
    debug: true,
  );
  //
  await Firebase.initializeApp();
  //
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ControllerProvider>(
          create: (context) => ControllerProvider(),
        ),
        ChangeNotifierProvider<ColorProvider>(
          create: (context) => ColorProvider(),
        ),
        ChangeNotifierProvider<GoogleSignInProvider>(
          create: (context) => GoogleSignInProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> loadFont() async {
  await Future.wait([
    loadFontFromAsset('fonts/OpenSans-VariableFont_wdth,wght.ttf'),
  ]);
}

Future<void> loadFontFromAsset(String fontPath) async {
  final fontData =
      await rootBundle.load('fonts/OpenSans-VariableFont_wdth,wght.ttf');
  final font = FontLoader('OpenSans');
  font.addFont(Future.value(fontData));
  await font.load();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Roder',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: LogIn(),
    );
  }
}

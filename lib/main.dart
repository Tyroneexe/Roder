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
import 'package:roder/login/google_sign_in.dart';
import 'package:roder/themes/theme_services.dart';
import 'package:roder/themes/theme.dart';
import 'package:roder/ui/notification_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_ride/location_provider.dart';
import 'login/login.dart';
import 'navbar/navbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedNotificationTime = prefs.getString('notificationTime');

  if (storedNotificationTime != null) {
    notificationTime = DateTime.parse(storedNotificationTime);
  } else {
    // Set a default value for notificationTime if it is null
    notificationTime = DateTime.now();
    prefs.setString('notificationTime', notificationTime.toString());
  }

  // Calculate the time difference
  if (notificationTime != null) {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(notificationTime!);

    // Use the difference to display the appropriate message or perform any other necessary actions
    print('Time difference: $difference');
  }
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
        ChangeNotifierProvider<LocationProvider>(
          create: (context) => LocationProvider(),
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
    loadFontFromAsset('fonts/Roboto-Bold.ttf'),
    loadFontFromAsset('fonts/Roboto-Regular.ttf'),
  ]);
}

Future<void> loadFontFromAsset(String fontPath) async {
  final fontData = await rootBundle.load('fonts/Roboto-Bold.ttf');
  final fontData2 = await rootBundle.load('fonts/Roboto-Regular.ttf');
  final font = FontLoader('Roboto');
  font.addFont(Future.value(fontData));
  font.addFont(Future.value(fontData2));
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

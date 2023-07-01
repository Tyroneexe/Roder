// ignore_for_file: unused_field

import 'package:app_settings/app_settings.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roder/themes/theme.dart';
import 'package:roder/ui/update_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../homepage/home_page.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  void _initPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationsEnabled = prefs.getBool('notification_preference') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                ),
                child: Icon(
                  Icons.person,
                  size: 38,
                  color: btnBlueClr,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  top: 14,
                ),
                child: Text(
                  'Account',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 2,
            color: dividerClr,
            height: 20,
            indent: 25,
            endIndent: 100,
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: Text(
                    'Content Settings',
                    style: roRegular14,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                    top: 10,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: btnBlueClr,
                  ),
                ),
              ],
            ),
            onTap: () {},
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: Text(
                    'Language',
                    style: roRegular14,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                    top: 10,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: btnBlueClr,
                  ),
                ),
              ],
            ),
            onTap: () {},
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: Text(
                    'Privacy Policy',
                    style: roRegular14,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                    top: 10,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: btnBlueClr,
                  ),
                ),
              ],
            ),
            onTap: () {},
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: Text(
                    'Updates',
                    style: roRegular14,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                    top: 10,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: btnBlueClr,
                  ),
                ),
              ],
            ),
            onTap: () {
              Get.to(() => UpdatePage());
            },
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                ),
                child: Icon(
                  Icons.volume_up_rounded,
                  size: 38,
                  color: btnBlueClr,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  top: 14,
                ),
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 2,
            color: dividerClr,
            height: 20,
            indent: 25,
            endIndent: 100,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                ),
                child: Text(
                  'Push Notifications',
                  style: roRegular14,
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  top: 10,
                ),
                child: Switch(
                  value: isNotificationsEnabled,
                  trackColor: MaterialStatePropertyAll<Color>(switchClr),
                  inactiveThumbColor: Colors.white,
                  thumbColor: const MaterialStatePropertyAll<Color>(btnBlueClr),
                  onChanged: (bool value) {
                    setState(() {
                      isNotificationsEnabled = !isNotificationsEnabled;
                      if (isNotificationsEnabled == true) {
                        AwesomeNotifications()
                            .isNotificationAllowed()
                            .then((isAllowed) {
                          if (!isAllowed) {
                            _enableNotifications();
                          }
                        });
                      } else {
                        _disableNotifications();
                      }
                    });
                    _saveNotificationPreference(isNotificationsEnabled);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _enableNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: navBarBkgClr,
          title: Text(
            'Enable Notifications',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          content: Text(
            'Go to Notifications Settings to enable notifications?',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w100,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: recentTxtClr,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Yes',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: btnBlueClr,
                ),
              ),
              onPressed: () {
                setState(() {
                  AwesomeNotifications()
                      .isNotificationAllowed()
                      .then((isAllowed) {
                    if (!isAllowed) {
                      AwesomeNotifications()
                          .requestPermissionToSendNotifications();
                    }
                  });
                });
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 20,
        );
      },
    );
  }

  _disableNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: navBarBkgClr,
          title: Text(
            'Disable Notifications',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          content: Text(
            'Go to Notifications Settings to disable notifications?',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w100,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: recentTxtClr,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Yes',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: btnBlueClr,
                ),
              ),
              onPressed: () {
                setState(() {
                  AppSettings.openNotificationSettings();
                });
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 20,
        );
      },
    );
  }

  void _saveNotificationPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_preference', value);
  }

  _appbar() {
    return AppBar(
      iconTheme: IconThemeData(
        color: btnBlueClr,
      ),
      elevation: 0,
      title: Text(
        'App Settings',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          fontSize: 25,
          color: Colors.black,
        ),
      ),
      backgroundColor: context.theme.colorScheme.background,
    );
  }
}

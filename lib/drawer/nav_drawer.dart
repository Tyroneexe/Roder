// ignore_for_file: must_be_immutable, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:roder/login/google_sign_in.dart';
import 'package:roder/settings_page/settings_page.dart';
import 'package:roder/ui/theme.dart';
import 'package:roder/ui/update_page.dart';

import '../provider/clrProvider.dart';
import '../test.dart';

class NavitionDrawer extends StatelessWidget {
  NavitionDrawer({super.key});
  final user = FirebaseAuth.instance.currentUser!;
  Color _mainColor = lightBlueClr;

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[buildHeader(context), buildMenuItems(context)],
          ),
        ),
      );
  //
  //
  Widget buildHeader(BuildContext context) => Container(
        height: 340,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/RoderNavD.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      );
  //
  //
  Widget buildMenuItems(BuildContext context) => Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 30,
              color: Get.isDarkMode ? Colors.white : Colors.grey[600],
            ),
            title: const Text(
              'Settings',
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey),
            ),
            onTap: () {
              Get.to(() => Settings());
            },
          ),
          ListTile(
            leading: Icon(
              Icons.star,
              size: 30,
              color: Get.isDarkMode ? Colors.white : Colors.grey[600],
            ),
            title: const Text(
              'Review App',
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey),
            ),
            onTap: () {
              _openAppReview();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.checklist_rounded,
              size: 30,
              color: Get.isDarkMode ? Colors.white : Colors.grey[600],
            ),
            title: const Text(
              'Latest Update',
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey),
            ),
            onTap: () {
              Get.to(() => UpdatePage());
            },
          ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.person,
          //     size: 30,
          //   ),
          //   title: const Text(
          //     'Account',
          //     style: TextStyle(
          //         fontFamily: 'OpenSans',
          //         fontWeight: FontWeight.bold,
          //         fontSize: 20,
          //         color: Colors.grey),
          //   ),
          //   onTap: () {},
          // ),
          ListTile(
            leading: const Icon(
              Icons.info_rounded,
              size: 30,
            ),
            title: const Text(
              'About',
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey),
            ),
            onTap: () {
              _aboutRoder(context);
              Get.to(() => Test());
            },
          ),
          Divider(
            color: Get.isDarkMode ? Colors.white : Colors.black,
            height: 10,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              size: 30,
            ),
            title: const Text(
              'Sign Out',
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey),
            ),
            onTap: () async {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
            },
          ),
        ],
      );

  Future<dynamic> _aboutRoder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Roder\nYour Ride, Your Way',
            style: subHeadingStyle,
          ),
          content: Text(
            "Our app was created with a simple goal in mind: to provide a platform for riders to discover new routes and enjoy delicious breakfasts at the same time!\n\nOur team of dedicated developers and motorcycle enthusiasts have created an app that is easy to use. With Roder, you can:\n\n●Plan your ride: Once you've found a great breakfast spot, use our app to plan your ride.\n\n●Connect with other riders: Our app allows you to connect with other bikers who share your passion for breakfast runs.",
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Get.isDarkMode ? Colors.white : Colors.black),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'GREAT',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getMainClr(
                        Provider.of<ColorProvider>(context).selectedColor),
                  ),
                ))
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 20,
        );
      },
    );
  }

  void _openAppReview() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.openStoreListing(appStoreId: '...', microsoftStoreId: '...');
    }
  }

  _getMainClr(int no) {
    switch (no) {
      case 0:
        _mainColor = lightBlueClr;
        return lightBlueClr;
      case 1:
        _mainColor = oRange;
        return oRange;
      case 2:
        _mainColor = themeRed;
        return themeRed;
      default:
        _mainColor = lightBlueClr;
        return lightBlueClr;
    }
  }
}

// ignore_for_file: must_be_immutable, unused_field
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:roder/account/account_page.dart';
import 'package:roder/login/google_sign_in.dart';
import 'package:roder/settings_page/settings_page.dart';
import 'package:roder/themes/theme.dart';
import 'package:roder/ui/update_page.dart';
import '../homepage/home_page.dart';
import '../provider/clrProvider.dart';
import '../ui/contact_page.dart';

class NavitionDrawer extends StatefulWidget {
  NavitionDrawer({super.key});

  @override
  State<NavitionDrawer> createState() => _NavitionDrawerState();
}

class _NavitionDrawerState extends State<NavitionDrawer> {
  //
  int noImg = 0;
  Color _mainColor = lightBlueClr;
  //

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(
          25,
        ),
        bottomLeft: Radius.circular(
          25,
        ),
      ),
      child: Drawer(
        width: 290,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  //
  Widget buildHeader(BuildContext context) {
    return Container(
      height: 240,
      child: Stack(
        children: [
          Positioned(
            top: 28,
            left: 16,
            child: IconButton(
              icon: Text(
                String.fromCharCode(Icons.close_rounded.codePoint),
                style: TextStyle(
                  inherit: false,
                  color: btnBlueClr,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  fontFamily: Icons.close_rounded.fontFamily,
                  package: Icons.close_rounded.fontPackage,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 25,
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(
                        user.photoURL!,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName!,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (BuildContext context,
                            AsyncSnapshot<PackageInfo> snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                                'Software Patch: ${snapshot.data?.version}');
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  //
  Widget buildMenuItems(BuildContext context) {
    return Column(
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
                fontFamily: 'Roboto',
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
                fontFamily: 'Roboto',
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
            'Patch Notes',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey),
          ),
          onTap: () {
            Get.to(() => UpdatePage());
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.person,
            size: 30,
          ),
          title: const Text(
            'Account',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey),
          ),
          onTap: () {
            Get.to(() => AccountPage());
          },
        ),
        ListTile(
          leading: Icon(
            Icons.contact_support,
            size: 30,
            color: Get.isDarkMode ? Colors.white : Colors.grey[600],
          ),
          title: const Text(
            'Contact',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey),
          ),
          onTap: () {
            Get.to(() => ContactPage());
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.info_rounded,
            size: 30,
          ),
          title: const Text(
            'About',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey),
          ),
          onTap: () {
            _aboutRoder(context);
            // Get.to(() => Test());
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
                fontFamily: 'Roboto',
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
  }

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
                fontFamily: 'Roboto',
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

  _themeImage(int no) {
    if (Provider.of<ColorProvider>(context).selectedColor == 0) {
      no = 0;
    } else if (Provider.of<ColorProvider>(context).selectedColor == 1) {
      no = 1;
    } else if (Provider.of<ColorProvider>(context).selectedColor == 2) {
      no = 2;
    } else {
      no = 0;
    }

    switch (no) {
      case 0:
        return AssetImage('assets/RoderNavD.jpg');
      case 1:
        return AssetImage('assets/NavYell.png');
      case 2:
        return AssetImage('assets/NavRed.jpg');
      default:
        return AssetImage('assets/RoderNavD.jpg');
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

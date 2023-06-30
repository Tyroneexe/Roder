// ignore_for_file: must_be_immutable, unused_field
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:roder/account/account_page.dart';
import 'package:roder/login/google_sign_in.dart';
import 'package:roder/settings_page/settings_page.dart';
import 'package:roder/themes/theme.dart';
import '../homepage/home_page.dart';
import '../themes/theme_services.dart';
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
  final MaterialStateProperty<Color?> trackColor =
      MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      // Track color when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return Colors.amber;
      }
      // Otherwise return null to set default track color
      // for remaining states such as when the switch is
      // hovered, focused, or disabled.
      return null;
    },
  );
  final MaterialStateProperty<Color?> overlayColor =
      MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      // Material color when switch is selected.
      if (states.contains(MaterialState.selected)) {
        return Colors.amber.withOpacity(0.54);
      }
      // Material color when switch is disabled.
      if (states.contains(MaterialState.disabled)) {
        return Colors.grey.shade400;
      }
      // Otherwise return null to set default material color
      // for remaining states such as when the switch is
      // hovered, or focused.
      return null;
    },
  );

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
    return Stack(
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
                CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(
                    user.photoURL!,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName!,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (BuildContext context,
                          AsyncSnapshot<PackageInfo> snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            'Software Patch ${snapshot.data?.version}',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ],
    );
  }

  //
  Widget buildMenuItems(BuildContext context) {
    return Column(
      children: [
        Divider(
          thickness: 2,
          color: dividerClr,
          height: 20,
          indent: 25,
          endIndent: 25,
        ),
        ListTile(
          leading: Icon(Icons.home, size: 30, color: btnBlueClr),
          title: const Text(
            'Home',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black),
          ),
          onTap: () {
            //
          },
        ),
        ListTile(
          leading: const Icon(Icons.person, size: 30, color: btnBlueClr),
          title: const Text(
            'Account',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black),
          ),
          onTap: () {
            Get.to(() => AccountPage());
          },
        ),
        ListTile(
          leading: Icon(Icons.settings, size: 30, color: btnBlueClr),
          title: const Text(
            'App Settings',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black),
          ),
          onTap: () {
            Get.to(() => Settings());
          },
        ),
        ListTile(
          leading: Icon(Icons.phone, size: 30, color: btnBlueClr),
          title: const Text(
            'Contact Us',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black),
          ),
          onTap: () {
            Get.to(() => ContactPage());
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_rounded, size: 30, color: btnBlueClr),
          title: const Text(
            'About Us',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black),
          ),
          onTap: () {
            // Get.to(() => Test());
          },
        ),
        Divider(
          thickness: 2,
          color: dividerClr,
          height: 20,
          indent: 25,
          endIndent: 25,
        ),
        Switch(
          // This bool value toggles the switch.
          value: Get.isDarkMode,
          overlayColor: overlayColor,
          trackColor: trackColor,
          thumbColor: const MaterialStatePropertyAll<Color>(Colors.black),
          onChanged: (bool value) {
            // This is called when the user toggles the switch.
            setState(() {
              ThemeService().switchTheme();
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: TextButton(
            onPressed: () async {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
            },
            style: ButtonStyle(
              textStyle: MaterialStateProperty.all<TextStyle>(
                TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              foregroundColor: MaterialStateProperty.all<Color>(
                Colors.white,
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                btnBlueClr,
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    6,
                  ),
                ),
              ),
              minimumSize: MaterialStateProperty.all<Size>(
                Size(MediaQuery.of(context).size.width,
                    38), // Set the desired width and height
              ),
            ),
            child: Text('Log Out'),
          ),
        ),
      ],
    );
  }
}

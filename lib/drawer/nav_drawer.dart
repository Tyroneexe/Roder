// ignore_for_file: must_be_immutable, unused_field, non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:roder/account/account_page.dart';
import 'package:roder/login/google_sign_in.dart';
import 'package:roder/themes/theme.dart';
import 'package:roder/ui/about_us.dart';
import 'package:url_launcher/url_launcher.dart';
import '../homepage/home_page.dart';
import '../settings_page/settings_page.dart';

class NavitionDrawer extends StatefulWidget {
  NavitionDrawer({super.key});

  @override
  State<NavitionDrawer> createState() => _NavitionDrawerState();
}

class _NavitionDrawerState extends State<NavitionDrawer> {
  //
  int noImg = 0;
  //
  final Uri _urlInsta = Uri.parse(
      'https://www.instagram.com/roderbiker/?igshid=MzNlNGNkZWQ4Mg%3D%3D');

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
  }

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Permission has not been granted
      await requestLocationPermission();
    } else if (permission == LocationPermission.deniedForever) {
      await requestLocationPermission();
    }
  }

  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      await Geolocator.openLocationSettings();
    }
  }

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
    return GestureDetector(
      onTap: () {
        Get.to(() => AccountPage());
      },
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
                  color: blueClr,
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
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser.uid)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircleAvatar(
                          backgroundImage: NetworkImage(currentUser.photoURL!),
                          radius: 32,
                        );
                      }
                      if (snapshot.hasData) {
                        final user =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return CircleAvatar(
                          backgroundImage: NetworkImage(user['foto']),
                          radius: 32,
                        );
                      } else {
                        return CircleAvatar(
                          backgroundImage: NetworkImage(
                            currentUser.photoURL!,
                          ),
                          radius: 32,
                        );
                      }
                    },
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUser.uid)
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text(
                              currentUser.displayName!,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            );
                          } else if (snapshot.hasData) {
                            final userData =
                                snapshot.data!.data() as Map<String, dynamic>;
                            final userName = userData['name'] as String;

                            return Text(
                              userName,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            );
                          } else {
                            final userData =
                                snapshot.data!.data() as Map<String, dynamic>;
                            final userName = userData['name'] as String;

                            return Text(
                              userName,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            );
                          }
                        },
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
      ),
    );
  }

  //
  Widget buildMenuItems(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Divider(
            thickness: 2,
            color: dividerClr,
            height: 20,
            indent: 25,
            endIndent: 25,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              leading: Icon(Icons.home, size: 30, color: blueClr),
              title: const Text(
                'Home',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                leading: const Icon(Icons.person, size: 30, color: blueClr),
                title: const Text(
                  'Account',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Get.to(() => AccountPage());
                }),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              leading: Icon(Icons.settings, size: 30, color: blueClr),
              title: const Text(
                'App Settings',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Get.to(() => SettingsPage());
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              leading: Icon(Icons.phone, size: 30, color: blueClr),
              title: const Text(
                'Contact Us',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 4,
                        color: navBarBkgClr,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Contact Us Via',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _showEmailPopup();
                                  },
                                  child: Icon(
                                    Icons.email_outlined,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: blueClr,
                                    elevation: 8.0,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    minimumSize: Size(130, 80),
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _showInstaPopup();
                                  },
                                  child: Icon(
                                    FontAwesomeIcons.instagram,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: blueClr,
                                    elevation: 8.0,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    minimumSize: Size(130, 80),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 5,
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              leading: const Icon(Icons.info_rounded, size: 30, color: blueClr),
              title: const Text(
                'About Us',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Get.to(() => AboutUsPage());
                // Get.to(() => Test());
              },
            ),
          ),
          Divider(
            thickness: 2,
            color: dividerClr,
            height: 20,
            indent: 25,
            endIndent: 25,
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextButton(
              onPressed: () {
                _logOutAlert();
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
                  blueClr,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                minimumSize: MaterialStateProperty.all<Size>(
                  Size(
                    MediaQuery.of(context).size.width,
                    38,
                  ),
                ),
              ),
              child: Text('Log Out'),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  _logOutAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: navBarBkgClr,
          title: Text(
            'Log Out',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          content: Text(
            'Are you sure you want to log out of the existing account?',
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
                  color: blueClr,
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
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

  Future<void> _launchInsta() async {
    if (!await launchUrl(_urlInsta)) {
      throw Exception('Could not launch $_urlInsta');
    }
  }

  _showEmailPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: navBarBkgClr,
          title: Text(
            'Contact Email',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          content: RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w100,
                fontSize: 18,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: 'Message the Developer of Roder with this Email:\n\n',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w100,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: 'roderteam@gmail.com',
                  style: TextStyle(
                    fontSize: 18,
                    color: blueClr,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      //copy the email to the clipboard of the user
                      final email = 'roderteam@gmail.com';
                      Clipboard.setData(ClipboardData(text: email));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Email copied to Clipboard')),
                      );
                    },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: blueClr,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                //copy the email to the clipboard of the user
                final email = 'roderteam@gmail.com';
                Clipboard.setData(ClipboardData(text: email));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Email copied to Clipboard')),
                );
                Navigator.pop(context);
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

  _showInstaPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: navBarBkgClr,
          title: Text(
            'Contact Instagram',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          content: Text(
            'Visit the Roder Instagram Page',
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
                  color: Colors.grey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text(
                'Go to Instagram',
                style: TextStyle(
                  color: blueClr,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                _launchInsta();
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
}

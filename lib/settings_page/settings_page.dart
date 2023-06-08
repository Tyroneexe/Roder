// ignore_for_file: unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_container/flutter_fancy_container.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:roder/provider/clrProvider.dart';
import 'package:roder/ui/theme.dart';
import '../services/theme_services.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Color _mainColor = blueClr;
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appbar(),
      body: Column(
        children: [
          Center(
            child: Text(
              'Settings',
              style: headingStyle,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _switchTheme(),
          SizedBox(
            height: 30,
          ),
          _chooseMainClr(),
          Expanded(
            child: SizedBox(
              height: 1,
            ),
          ),
          _deleteAcc(),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }

  _switchTheme() {
    return FlutterFancyContainer(
      height: 150,
      colorOne: Get.isDarkMode ? Colors.white : Colors.grey[850],
      colorTwo: Get.isDarkMode ? Colors.grey[850] : Colors.white,
      onTap: () {
        ThemeService().switchTheme();
      },
      child: Center(
        child: Text(
          'Switch Theme',
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Get.isDarkMode ? Colors.black : Colors.white),
        ),
      ),
    );
  }

  _chooseMainClr() {
    int selectedColor =
        Provider.of<ColorProvider>(context, listen: false).selectedColor;
    int no;

    if (selectedColor == 0) {
      no = 3;
    } else if (selectedColor == 1) {
      no = 4;
    } else {
      no = 5;
    }

    Color colorOne = _getMainClr(no);
    Color colorTwo = _getMainClr(selectedColor);

    return FlutterFancyContainer(
      height: 130,
      colorOne: colorOne,
      colorTwo: colorTwo,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Theme Color',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.white,
              ),
            ),
          ),
          _colorPallete(),
        ],
      ),
    );
  }

  _getMainClr(int no) {
    switch (no) {
      case 0:
        setState(() {
          _mainColor = blueClr;
        });
        return blueClr;
      case 1:
        setState(() {
          _mainColor = oRange;
        });
        return oRange;
      case 2:
        setState(() {
          _mainColor = themeRed;
        });
        return themeRed;
      case 3:
        setState(() {
          _mainColor = lightBlueClr;
        });
        return lightBlueClr;
      case 4:
        setState(() {
          _mainColor = Colors.orange;
        });
        return Colors.orange;
      case 5:
        setState(() {
          _mainColor = Colors.red;
        });
        return Colors.red;
      default:
        setState(() {
          _mainColor = blueClr;
        });
        return blueClr;
    }
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8.0,
        ),
        Wrap(
          children: List<Widget>.generate(
            3,
            (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    Provider.of<ColorProvider>(context, listen: false)
                        .selectedColor = index;
                    _getMainClr(index);
                    // _saveColor();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: index == 0
                            ? blueClr
                            : index == 1
                                ? oRange
                                : themeRed,
                      ),
                      if (Provider.of<ColorProvider>(context).selectedColor ==
                          index)
                        Positioned.fill(
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _deleteAcc() {
    return GestureDetector(
      child: Container(
        width: 120,
        height: 40,
        decoration:
            BoxDecoration(color: rred, borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text(
            'Delete Account',
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Get.isDarkMode ? Colors.white : Colors.white),
          ),
        ),
      ),
      onTap: () {
        _showAlertDialog();
      },
    );
  }

  _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Account',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Text(
            'Confirm account deletion. Allow up to 24 hours for processing.',
            style: TextStyle(
              fontSize: 16,
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
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                try {
                  User? user = FirebaseAuth.instance.currentUser;

                  // Prompt the user to reauthenticate with Google
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  GoogleSignInAccount? googleUser = await googleSignIn.signIn();

                  if (googleUser != null) {
                    GoogleSignInAuthentication googleAuth =
                        await googleUser.authentication;
                    AuthCredential credential = GoogleAuthProvider.credential(
                      accessToken: googleAuth.accessToken,
                      idToken: googleAuth.idToken,
                    );

                    // Reauthenticate the user
                    await user!.reauthenticateWithCredential(credential);

                    // User has been successfully reauthenticated
                    // Proceed with deleting the account
                    await user.delete();

                    // Account deleted successfully
                    Navigator.of(context).pop();
                  } else {
                    _errorMsg();
                  }
                  // Account deleted successfully
                  Navigator.of(context).pop();
                } catch (e) {
                  _errorMsg();
                }
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

  _errorMsg() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'An Error Has Occurred',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Text(
            "Could not delete account.",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Try Again',
                style: TextStyle(
                  color: rred,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
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

  _appbar() {
    return AppBar(
      iconTheme:
          IconThemeData(color: Get.isDarkMode ? Colors.white : Colors.black),
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
    );
  }
}

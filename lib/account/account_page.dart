import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:roder/ui/theme.dart';

import '../login/google_sign_in.dart';
import '../ui/home_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Account Details',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 70,
          ),
          Expanded(
            // Add Expanded widget to allow the row to occupy available height
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Adjust cross-axis alignment
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(user.photoURL!),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        user.email!,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            color: rred,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'Sign Out',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          _showAlertDialog();
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sign Out',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out of the existing account?',
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Yes',
                style: TextStyle(
                  color: rred,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
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

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
    );
  }
}

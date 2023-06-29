import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roder/drawer/nav_drawer.dart';
import 'package:roder/themes/theme.dart';

import '../login/google_sign_in.dart';

class NotiPage extends StatefulWidget {
  const NotiPage({super.key});

  @override
  State<NotiPage> createState() => _NotiPageState();
}

class _NotiPageState extends State<NotiPage> {
  bool welcomeViwed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      endDrawer: NavitionDrawer(),
      backgroundColor: context.theme.colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                ),
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                'Recently',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          GoogleSignInProvider().isSignedIn
              ? SizedBox()
              : _welcomeNotification(),
        ],
      ),
    );
  }

  _welcomeNotification() {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 90,
              width: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    4,
                  ),
                  bottomLeft: Radius.circular(
                    4,
                  ),
                ),
                color: btnBlueClr,
              ),
            ),
            Container(
              height: 90,
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  4,
                ),
                color: newNotis,
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.waving_hand_rounded,
                          color: btnBlueClr,
                          size: 36,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome to ',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          color: textNotis,
                        ),
                      ),
                      TextSpan(
                        text: 'Roder',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: btnBlueClr,
                        ),
                      ),
                      TextSpan(
                        text: '\nFind your Ride, your Way.',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          color: textNotis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //Text date
          ],
        )
      ],
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: context.theme.colorScheme.background,
      elevation: 0,
      foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,
    );
  }
}

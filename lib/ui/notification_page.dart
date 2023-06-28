import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roder/drawer/nav_drawer.dart';
import 'package:roder/themes/theme.dart';

class NotiPage extends StatefulWidget {
  const NotiPage({super.key});

  @override
  State<NotiPage> createState() => _NotiPageState();
}

class _NotiPageState extends State<NotiPage> {
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
          _welcomeNotification(),
        ],
      ),
    );
  }

  _welcomeNotification() {
    return Stack(
      children: [
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
        Column(
          children: [
            Row(
              children: [
                Text(
                  'Welcome to Roder, Find your Ride, your way',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: textNotis),
                ),
              ],
            ),
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

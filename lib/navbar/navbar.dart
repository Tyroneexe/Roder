// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roder/account/account_page.dart';
import 'package:roder/navbar/barcontroller.dart';
import 'package:roder/search/search_page.dart';
import 'package:roder/ui/notification_page.dart';
import '../homepage/home_page.dart';
import '../themes/colors.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key, final String? payload});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final controller = Get.put(NavBarController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavBarController>(
      builder: (context) {
        return Scaffold(
          body: IndexedStack(
            index: controller.tabIndex,
            children: [HomePage(), NotificationPage(), Search(), AccountPage()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor:
                Get.isDarkMode ? navBarBackgroundClr : navBarBkgClr,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            selectedItemColor: Get.isDarkMode ? navBarSelectedIcon : blueClr,
            unselectedItemColor: Get.isDarkMode ? Colors.white : Colors.black,
            currentIndex: controller.tabIndex,
            onTap: controller.changeTabIndex,
            selectedFontSize: 0,
            selectedIconTheme: IconThemeData(size: 0),
            unselectedIconTheme: IconThemeData(size: 0),
            items: [
              _bottombarItem(Icons.home, "", 26),
              BottomNavigationBarItem(
                icon: Badge(
                  backgroundColor: Colors.red,
                  isLabelVisible: notificationBadgeVisible,
                  child: Icon(
                    Icons.notifications,
                    size: 26,
                  ),
                ),
                label: "",
              ),
              _bottombarItem(
                Icons.search_rounded,
                "",
                26,
              ),
              // _bottombarItem(Icons.message, "", 24),
              BottomNavigationBarItem(
                icon: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser.uid)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircleAvatar(
                        backgroundImage: NetworkImage(currentUser.photoURL!),
                        radius: 16,
                      );
                    }
                    if (snapshot.hasData) {
                      final user =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return CircleAvatar(
                        backgroundImage: NetworkImage(user['foto']),
                        radius: 16,
                      );
                    } else {
                      return CircleAvatar(
                        backgroundImage: NetworkImage(
                          currentUser.photoURL!,
                        ),
                        radius: 16,
                      );
                    }
                  },
                ),
                label: '',
              )
            ],
          ),
        );
      },
    );
  }
}

_bottombarItem(IconData icon, String label, double size) {
  return BottomNavigationBarItem(
    icon: Icon(
      icon,
      size: size,
    ),
    label: label,
  );
}

// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roder/messages/messages_page.dart';
import 'package:roder/navbar/barcontroller.dart';
import 'package:roder/search/search_page.dart';
import 'package:roder/themes/theme.dart';
import 'package:roder/ui/notification_page.dart';
import '../homepage/home_page.dart';

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
            children: [HomePage(), NotificationPage(), Search(), MessagePage()],
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
              _bottombarItem(Icons.message, "", 24),
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

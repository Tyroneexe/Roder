// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:roder/navbar/barcontroller.dart';
import 'package:roder/search/search_page.dart';
import 'package:roder/themes/theme.dart';
import 'package:roder/ui/add_task_bar.dart';
import 'package:roder/ui/notification_page.dart';

import '../homepage/home_page.dart';
import '../provider/clrProvider.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key, final String? payload});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final controller = Get.put(NavBarController());
  static const Color navBarBkgClr = Color(0xFFe7eeff);

  @override
  void initState() {
    super.initState();
    Provider.of<ColorProvider>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavBarController>(
      builder: (context) {
        return Scaffold(
          body: IndexedStack(
            index: controller.tabIndex,
            children: const [HomePage(), NotiPage(), Search(), AddTaskPage()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: navBarBkgClr,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            selectedItemColor: btnBlueClr,
            unselectedItemColor: Colors.black,
            currentIndex: controller.tabIndex,
            onTap: controller.changeTabIndex,
            selectedFontSize: 0,
            selectedIconTheme: IconThemeData(size: 0),
            unselectedIconTheme: IconThemeData(size: 0),
            items: [
              _bottombarItem(Icons.home, ""),
              _bottombarItem(Icons.notifications, ""),
              _bottombarItem(Icons.search_rounded, ""),
              _bottombarItem(
                Icons.add_circle_outline,
                "",
              ),
            ],
          ),
        );
      },
    );
  }
}

_bottombarItem(IconData icon, String label) {
  return BottomNavigationBarItem(
    icon: Icon(
      icon,
      size: 26,
    ),
    label: label,
  );
}

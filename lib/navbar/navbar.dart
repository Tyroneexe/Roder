// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:roder/controllers/barcontroller.dart';
import 'package:roder/favourites/favourites.dart';
import 'package:roder/search/search_page.dart';
import 'package:roder/themes/theme.dart';
import 'package:roder/ui/add_task_bar.dart';

import '../homepage/home_page.dart';
import '../provider/clrProvider.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key, final String? payload});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final controller = Get.put(NavBarController());
  Color _mainColor = blueClr;

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
            children: const [HomePage(), Search(), Favourites(), AddTaskPage()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            selectedItemColor: btnBlueClr,
            unselectedItemColor: Colors.black,
            selectedFontSize: 16,
            currentIndex: controller.tabIndex,
            onTap: controller.changeTabIndex,
            items: [
              _bottombarItem(Icons.home, "Home"),
              _bottombarItem(Icons.notifications, "Search"),
              _bottombarItem(Icons.search_rounded, "Joined"),
              _bottombarItem(
                Icons.add_circle_outline,
                "Add",
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
      size: 24,
    ),
    label: label,
  );
}

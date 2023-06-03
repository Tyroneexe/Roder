// ignore_for_file: unused_field

import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:roder/controllers/barcontroller.dart';
import 'package:roder/favourites/favourites.dart';
import 'package:roder/search/search_page.dart';
import 'package:roder/ui/add_task_bar.dart';
import 'package:roder/ui/home_page.dart';
import 'package:roder/ui/theme.dart';

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
    return GetBuilder<NavBarController>(builder: (context) {
      return Scaffold(
        body: IndexedStack(
          index: controller.tabIndex,
          children: const [HomePage(), Search(), Favourites(), AddTaskPage()],
        ),
        bottomNavigationBar: Consumer<ColorProvider>(
          builder: (context, provider, child) => BottomNavigationBar(
            elevation: 0,
            selectedItemColor: _getMainClr(provider.selectedColor),
            unselectedItemColor: Colors.grey[700],
            selectedFontSize: 16,
            currentIndex: controller.tabIndex,
            onTap: controller.changeTabIndex,
            items: [
              _bottombarItem(AkarIcons.home, "Home"),
              _bottombarItem(AkarIcons.search, "Search"),
              _bottombarItem(AkarIcons.heart, "Joined"),
              _bottombarItem(
                Icons.add_circle_outline,
                "Add",
              ),
            ],
          ),
        ),
      );
    });
  }

  _getMainClr(int no) {
    switch (no) {
      case 0:
        _mainColor = blueClr;
        return blueClr;
      case 1:
        _mainColor = oRange;
        return oRange;
      case 2:
        _mainColor = themeRed;
        return themeRed;
      default:
        _mainColor = blueClr;
        return blueClr;
    }
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

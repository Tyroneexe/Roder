// ignore_for_file: unused_field

import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:roder/controllers/barcontroller.dart';
import 'package:roder/favourites/favourites.dart';
import 'package:roder/search/search_page.dart';
import 'package:roder/ui/add_task_bar.dart';
import 'package:roder/homepage/home_page.dart';
import 'package:roder/themes/theme.dart';

import '../provider/clrProvider.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key, final String? payload}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
  final controller = Get.put(NavBarController());
  Color _mainColor = blueClr;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    Provider.of<ColorProvider>(context, listen: false).init();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
            onTap: (index) {
              final rotationAngle = (index == controller.tabIndex) ? 0.5 : 1.0;
              controller.changeTabIndex(index);
              _startAnimation(rotationAngle);
            },
            items: [
              _bottombarItem(AkarIcons.home, "Home", 0),
              _bottombarItem(AkarIcons.search, "Search", 1),
              _bottombarItem(AkarIcons.heart, "Joined", 2),
              _bottombarItem(Icons.add_circle_outline, "Add", 3),
            ],
          ),
        ),
      );
    });
  }

  void _startAnimation(double rotationAngle) {
    _animationController.reset();
    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
      }
    });
  }

  _getMainClr(int no) {
    switch (no) {
      case 0:
        _mainColor = lightBlueClr;
        return lightBlueClr;
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

  _bottombarItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
        child: Icon(
          icon,
          size: 24,
        ),
      ),
      label: label,
    );
  }
}

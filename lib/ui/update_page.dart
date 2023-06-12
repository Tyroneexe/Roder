import 'package:flutter/material.dart';
import 'package:flutter_fancy_container/flutter_fancy_container.dart';
import 'package:get/get.dart';
import 'package:roder/ui/theme.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  bool isExpanded2 = false;
  bool isExpanded1 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                'Latest Update',
                style: headingStyle,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _polishUpdate(),
            SizedBox(
              height: 20,
            ),
            _launchApp(),
          ],
        ),
      ),
    );
  }

  _polishUpdate() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: isExpanded2
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width - 40,
      height: isExpanded2 ? 620 : 160,
      child: FlutterFancyContainer(
        colorOne: lightBlueClr,
        colorTwo: themeRed,
        onTap: () {
          setState(() {
            isExpanded2 = !isExpanded2;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 45,
            ),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: isExpanded2 ? 24 : 30,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              child: Text('Polish Update'),
            ),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: isExpanded2 ? 14 : 20,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              child: Text('30 May 2023'),
            ),
            SizedBox(
              height: 25,
            ),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w400,
                  fontSize: isExpanded2 ? 20 : 0,
                  color: Get.isDarkMode ? Colors.white : Colors.black),
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Bug Fixes:\n"
                  "● Fix Google Maps search bar\n"
                  "● Fix Dark Mode color\n"
                  "● Fix About page popup\n\n"
                  "New Features and Enhancements:\n"
                  "● Allow selection of primary color\n"
                  "● Ability to delete account\n"
                  "● Added a customization dropdown\n"
                  "● Latest Update page\n"
                  "● Implement ride deletion functionality",
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchApp() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: isExpanded1
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width - 40,
      height: isExpanded1 ? 550 : 160,
      child: FlutterFancyContainer(
        colorOne: darkbl50,
        colorTwo: iceCold,
        onTap: () {
          setState(() {
            isExpanded1 = !isExpanded1;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 45,
            ),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: isExpanded1 ? 24 : 30,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              child: Text('Launch of the App'),
            ),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: isExpanded1 ? 14 : 20,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              child: Text('30 April 2023'),
            ),
            SizedBox(
              height: 25,
            ),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: isExpanded1 ? 24 : 0,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  'Roder is a mobile application that allows you to create and join bike runs, and also create meetups with other bike riders. With Roder, you can easily plan your own rides or join other rides that are happening in your area.',
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
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

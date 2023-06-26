import 'package:flutter/material.dart';
import 'package:flutter_fancy_container/flutter_fancy_container.dart';
import 'package:get/get.dart';
import 'package:roder/themes/theme.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  bool isExpanded = false;

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
                'Patch Notes',
                style: headingStyle,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _ver105(),
            SizedBox(
              height: 20,
            ),
            _ver104(),
            SizedBox(
              height: 20,
            ),
            _ver101(),
            SizedBox(
              height: 20,
            ),
            _launchApp(),
          ],
        ),
      ),
    );
  }

  _ver105() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: isExpanded
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width - 40,
      height: isExpanded ? 580 : 160,
      child: FlutterFancyContainer(
        colorOne: themeRed,
        colorTwo: vBlue,
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
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
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: isExpanded ? 24 : 30,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              child: Text('Version 1.0.5'),
            ),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: isExpanded ? 14 : 20,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              child: Text('June 2023'),
            ),
            SizedBox(
              height: 25,
            ),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: isExpanded ? 20 : 0,
                  color: Get.isDarkMode ? Colors.white : Colors.black),
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  //animations added for ui
                  //Feedback
                  "Bug Fixes:\n"
                  "● Fixed the Notification System\n"
                  "● Fixed the Time Picker in Add Page\n"
                  "● Fixed the Splash Screen\n\n"
                  "New Features:\n"
                  "● Expandable Rides\n"
                  "● Improved the design and flow of Roder\n"
                  "● Improved Home Page\n"
                  "● Enhanced Theme Changes",
                  style: TextStyle(
                      fontFamily: 'Roboto',
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

  _ver104() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: isExpanded
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width - 40,
      height: isExpanded ? 450 : 160,
      child: FlutterFancyContainer(
        colorOne: lightBlueClr,
        colorTwo: darkbl50,
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
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
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: isExpanded ? 24 : 30,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              child: Text('Version 1.0.4'),
            ),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: isExpanded ? 14 : 20,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              child: Text('June 2023'),
            ),
            SizedBox(
              height: 25,
            ),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: isExpanded ? 20 : 0,
                  color: Get.isDarkMode ? Colors.white : Colors.black),
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "New Features:\n"
                  "● Implemented a Notification System\n"
                  "● Improved UI and design\n"
                  "● Animated Navigation Bar\n"
                  "● Notify Message for New Updates\n"
                  "● Improved Home Page Layout\n",
                  style: TextStyle(
                      fontFamily: 'Roboto',
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

  _ver101() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: isExpanded
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width - 40,
      height: isExpanded ? 620 : 160,
      child: FlutterFancyContainer(
        colorOne: blueClr,
        colorTwo: themeRed,
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
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
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: isExpanded ? 24 : 30,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              child: Text('Version 1.0.1'),
            ),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: isExpanded ? 14 : 20,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              child: Text('May 2023'),
            ),
            SizedBox(
              height: 25,
            ),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: isExpanded ? 20 : 0,
                  color: Get.isDarkMode ? Colors.white : Colors.black),
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Bug Fixes:\n"
                  "● Fix Google Maps search bar\n"
                  "● Fix Dark Mode color\n"
                  "● Fix About page popup\n\n"
                  "New Features:\n"
                  "● Allow selection of primary color\n"
                  "● Ability to delete account\n"
                  "● Added a customization dropdown\n"
                  "● Latest Update page\n"
                  "● Implement ride deletion functionality",
                  style: TextStyle(
                      fontFamily: 'Roboto',
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
      width: isExpanded
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width - 40,
      height: isExpanded ? 550 : 160,
      child: FlutterFancyContainer(
        colorOne: darkbl50,
        colorTwo: iceCold,
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
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
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: isExpanded ? 24 : 30,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              child: Text('Launch of the App'),
            ),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: isExpanded ? 14 : 20,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              child: Text('April 2023'),
            ),
            SizedBox(
              height: 25,
            ),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: isExpanded ? 24 : 0,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  'Roder is a mobile application that allows you to create and join bike runs, and also create meetups with other bike riders. With Roder, you can easily plan your own rides or join other rides that are happening in your area.',
                  style: TextStyle(
                      fontFamily: 'Roboto',
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roder/widgets/filter_button.dart';
import 'package:roder/widgets/unfilter_button.dart';
import 'drawer/nav_drawer.dart';
import 'homepage/home_page.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  bool isFilter1 = true;
  bool isFilter2 = false;
  bool isFilter3 = false;
  bool isFilter4 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavitionDrawer(),
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.background,
        elevation: 0,
        foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Morning ${user.displayName},',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Let's Ride",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w100,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                ),
                child: isFilter1
                    ? FilterButton(
                        onPressed: () {
                          setState(() {
                            isFilter1 = !isFilter1;
                          });
                        },
                        child: Text(
                          'All Rides',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : UnFilterButton(
                        onPressed: () {
                          setState(() {
                            isFilter1 = !isFilter1;
                          });
                        },
                        child: Text(
                          'All Rides',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        )),
              ),
              FilterButton(
                onPressed: () {},
                child: Text(
                  'Near Me',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

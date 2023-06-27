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
      appBar: _appBar(),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
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
                              if (isFilter2 == false &&
                                  isFilter3 == false &&
                                  isFilter4 == false) {
                                isFilter1 = true;
                              } else {
                                isFilter1 = !isFilter1;
                                isFilter4 = false;
                                isFilter2 = false;
                                isFilter3 = false;
                              }
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
                              isFilter4 = false;
                              isFilter2 = false;
                              isFilter3 = false;
                            });
                          },
                          child: Text(
                            'All Rides',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                ),
                isFilter2
                    ? FilterButton(
                        onPressed: () {
                          setState(() {
                            if (isFilter1 == false &&
                                isFilter3 == false &&
                                isFilter4 == false) {
                              isFilter2 = true;
                            } else {
                              isFilter2 = !isFilter2;
                              isFilter4 = false;
                              isFilter1 = false;
                              isFilter3 = false;
                            }
                          });
                        },
                        child: Text(
                          'Near Me',
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
                            isFilter2 = !isFilter2;
                            isFilter1 = false;
                            isFilter4 = false;
                            isFilter3 = false;
                          });
                        },
                        child: Text(
                          'Near Me',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                isFilter3
                    ? FilterButton(
                        onPressed: () {
                          setState(() {
                            if (isFilter2 == false &&
                                isFilter1 == false &&
                                isFilter4 == false) {
                              isFilter3 = true;
                            } else {
                              isFilter3 = !isFilter3;
                              isFilter4 = false;
                              isFilter2 = false;
                              isFilter1 = false;
                            }
                          });
                        },
                        child: Text(
                          'Joined',
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
                            isFilter3 = !isFilter3;
                            isFilter1 = false;
                            isFilter2 = false;
                            isFilter4 = false;
                          });
                        },
                        child: Text(
                          'Joined',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                isFilter4
                    ? FilterButton(
                        onPressed: () {
                          setState(() {
                            if (isFilter2 == false &&
                                isFilter3 == false &&
                                isFilter1 == false) {
                              isFilter4 = true;
                            } else {
                              isFilter4 = !isFilter4;
                              isFilter1 = false;
                              isFilter2 = false;
                              isFilter3 = false;
                            }
                          });
                        },
                        child: Text(
                          'Events',
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
                            isFilter4 = !isFilter4;
                            isFilter1 = false;
                            isFilter2 = false;
                            isFilter3 = false;
                          });
                        },
                        child: Text(
                          'Events',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
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

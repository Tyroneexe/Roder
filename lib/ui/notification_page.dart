import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roder/drawer/nav_drawer.dart';
import 'package:roder/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

bool hasBeenUpdated = false;
bool eventOneHasOccurred = false;

class _NotificationPageState extends State<NotificationPage> {
  bool welcomeViewed = false;

  List<NotificationItem> notifications = [
    NotificationItem(
      title:
          "Roder: 2.0.0 patch update has been installed. With new additional features.",
      time: "",
      event: "patchnotes",
      viewed: false,
    ),
    NotificationItem(
      title: "Notification 2",
      time: "This is a test",
      icon: Icons.notifications,
      event: "eventOne",
      viewed: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<NotificationItem> filteredNotifications = notifications
        .where((n) {
          if (n.event == "patchnotes" && hasBeenUpdated) {
            return true;
          } else if (n.event == "eventOne" && eventOneHasOccurred) {
            return true;
          } else {
            return false;
          }
        })
        .toList()
        .reversed
        .toList();

    return Scaffold(
      endDrawer: NavitionDrawer(),
      appBar: _appBar(),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 20),
              Text(
                'Recently',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          _welcomeNotification(),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredNotifications.length,
              itemBuilder: (BuildContext context, int index) {
                return NotificationCard(
                  notification: filteredNotifications[index],
                  onTap: () {
                    setState(() {
                      filteredNotifications[index].viewed = true;
                    });
                  },
                );
              },
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

  _welcomeNotification() {
    return FutureBuilder<bool>(
      future: _getWelcomeViewedBool(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          welcomeViewed = snapshot.data!;
        }
        return GestureDetector(
          onTap: () {
            setState(() {
              welcomeViewed = true;
            });
            _saveWelcomeViewedBool();
          },
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  welcomeViewed
                      ? SizedBox()
                      : Container(
                          height: 90,
                          width: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                            ),
                            color: btnBlueClr,
                          ),
                        ),
                  Container(
                    height: 90,
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: newNotis,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.waving_hand_rounded,
                                color: btnBlueClr,
                                size: 32,
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Welcome to ',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: textNotis,
                              ),
                            ),
                            TextSpan(
                              text: 'Roder',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: btnBlueClr,
                              ),
                            ),
                            TextSpan(
                              text: '\nFind your Ride, your Way.',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: textNotis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  //Text date
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _saveWelcomeViewedBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('welcomeViewed', welcomeViewed);
  }

  Future<bool> _getWelcomeViewedBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('welcomeViewed') ?? false;
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final Function()? onTap;

  const NotificationCard({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            4,
          ),
          color: newNotis,
          // notification.viewed ? Colors.grey[300] : Colors.white,
        ),
        child: Row(
          children: [
            notification.viewed
                ? SizedBox()
                : Container(
                    width: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          4,
                        ),
                        bottomLeft: Radius.circular(
                          4,
                        ),
                      ),
                      color: btnBlueClr,
                    ),
                  ),
            SizedBox(
              width: 10,
            ),
            if (notification.icon != null)
              Icon(
                notification.icon,
                color: btnBlueClr,
                size: 36,
              ),
            if (notification.icon != null) SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: textNotis,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    notification.time,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: textNotis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String time;
  final IconData? icon;
  final String event;
  bool viewed;

  NotificationItem({
    required this.title,
    required this.time,
    this.icon,
    required this.event,
    required this.viewed,
  });
}

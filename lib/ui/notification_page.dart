import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roder/drawer/nav_drawer.dart';
import 'package:roder/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

// bool values for the notification items
bool hasBeenUpdated = false;
bool createdFirstRide = false;
bool eventTwo = false;
bool notificationBadgeVisible = false;

bool welcomeViewed = false;

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationItem> filteredNotifications = [];
  bool seeOlderNotifications = false;

  List<NotificationItem> notifications = [
    NotificationItem(
      title:
          "Roder: 2.0.0 patch update has been installed. With new additional features.",
      time: "",
      event: "patchnotes",
      viewed: false,
    ),
    NotificationItem(
      title: "You Created Your First Ride. Nice!",
      time: "This is a test",
      icon: Icons.add,
      event: "createdFirstRide",
      viewed: false,
    ),
    NotificationItem(
      title: "Notification Test 3",
      time: "This is the 3rd Test",
      icon: Icons.notifications,
      event: "eventTwo",
      viewed: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  void initializeNotifications() async {
    // Retrieve the welcome viewed status from shared preferences
    welcomeViewed = await _getWelcomeViewedBool();

    // Populate the filteredNotifications list based on conditions
    filteredNotifications = notifications
        .where((n) {
          if (n.event == "patchnotes" && hasBeenUpdated) {
            return true;
          } else if (n.event == "createdFirstRide" && createdFirstRide) {
            return true;
          } else if (n.event == "eventTwo" && eventTwo) {
            return true;
          } else {
            return false;
          }
        })
        .toList()
        .reversed
        .toList();

    for (var notification in filteredNotifications) {
      notification.viewed =
          await NotificationItem.getViewedStatus(notification.event);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasUnviewedNotifications =
        filteredNotifications.any((notification) => !notification.viewed);
    setState(() {
      notificationBadgeVisible =
          filteredNotifications.any((notification) => !notification.viewed);
    });
    return Scaffold(
      endDrawer: NavitionDrawer(),
      appBar: _appBar(),
      body: Column(
        children: [
          if (hasUnviewedNotifications || !welcomeViewed) ...[
            if (!seeOlderNotifications) ...[
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
              SizedBox(height: 10),
              if (!welcomeViewed) ...[
                _welcomeNotification(),
                SizedBox(height: 10),
              ],
              ListView.builder(
                shrinkWrap: true,
                itemCount: filteredNotifications.length,
                itemBuilder: (BuildContext context, int listIndex) {
                  if (filteredNotifications[listIndex].viewed == true) {
                    return Container();
                  } else {
                    return NotificationCard(
                      notification: filteredNotifications[listIndex],
                      onTap: () async {
                        setState(() {
                          filteredNotifications[listIndex].viewed = true;
                        });
                        await filteredNotifications[listIndex]
                            .saveViewedStatus();
                      },
                    );
                  }
                },
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    'Older',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                itemCount: filteredNotifications.length,
                itemBuilder: (BuildContext context, int listIndex) {
                  if (filteredNotifications[listIndex].viewed) {
                    return NotificationCard(
                      notification: filteredNotifications[listIndex],
                      onTap: () async {
                        setState(() {
                          filteredNotifications[listIndex].viewed = false;
                        });
                        await filteredNotifications[listIndex]
                            .saveViewedStatus();
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(height: 10),
              if (welcomeViewed == true) ...[
                _welcomeNotification(),
              ],
            ],
          ],
          if (!hasUnviewedNotifications &&
              welcomeViewed &&
              !seeOlderNotifications) ...[
            Container(
              height: MediaQuery.of(context).size.height - 250,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 220,
                      width: 220,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/NotiRoderImage.png'),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No New Notifications',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'There are no new notifications to show right now',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w100,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            seeOlderNotifications = true;
                          });
                        },
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            btnBlueClr,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all<Size>(
                            Size(
                              MediaQuery.of(context).size.width / 1.5,
                              38,
                            ),
                          ),
                        ),
                        child: Text('See Older Notifications'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (seeOlderNotifications) ...[
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 20),
                Text(
                  'Older',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: filteredNotifications.length,
              itemBuilder: (BuildContext context, int listIndex) {
                if (filteredNotifications[listIndex].viewed) {
                  return NotificationCard(
                    notification: filteredNotifications[listIndex],
                    onTap: () async {
                      setState(() {
                        filteredNotifications[listIndex].viewed = false;
                      });
                      await filteredNotifications[listIndex].saveViewedStatus();
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
            SizedBox(height: 10),
            if (welcomeViewed == true) ...[
              _welcomeNotification(),
            ],
          ]
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      elevation: 0,
      title: Text(
        'Notifications',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          fontSize: 25,
          color: Colors.black,
        ),
      ),
      backgroundColor: context.theme.colorScheme.background,
    );
  }

  _welcomeNotification() {
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
  }

  _saveWelcomeViewedBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('welcomeViewed', welcomeViewed);
  }

  Future<bool> _getWelcomeViewedBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('welcomeViewed') ?? true;
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
  bool viewed = false;

  NotificationItem({
    required this.title,
    required this.time,
    this.icon,
    required this.event,
    required this.viewed,
  });

  Future<void> saveViewedStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_$event', viewed);
  }

  static Future<bool> getViewedStatus(String event) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notification_$event') ?? false;
  }
}

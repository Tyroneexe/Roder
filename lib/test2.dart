import 'package:flutter/material.dart';
import 'package:roder/themes/theme.dart';

void main() => runApp(NotificationApp());

class NotificationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NotificationPage(),
    );
  }
}

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool eventOneHasOccurred =
      false; // Update this based on your event conditions
  bool eventTwoHasOccurred = true; // Update this based on your event conditions

  List<NotificationItem> notifications = [
    NotificationItem(
      title: "Notification 1",
      content: "This is the first notification",
      icon: Icons.notifications,
      event: "eventOne",
      viewed: false,
    ),
    NotificationItem(
      title: "Notification 2",
      content: "This is the second notification",
      icon: Icons.notifications,
      event: "eventTwo",
      viewed: false,
    ),
    NotificationItem(
      title: "Notification 3",
      content: "This is the third notification",
      icon: Icons.notifications,
      event: "eventOne",
      viewed: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<NotificationItem> filteredNotifications = notifications.where((n) {
      if (n.event == "eventOne" && eventOneHasOccurred) {
        return true;
      } else if (n.event == "eventTwo" && eventTwoHasOccurred) {
        return true;
      }
      return false;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: btnBlueClr,
      ),
      body: ListView.builder(
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
    );
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
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: 
          notification.viewed ? Colors.grey[300] : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
                color: btnBlueClr,
              ),
            ),
            SizedBox(width: 10),
            Icon(
              notification.icon,
              color: btnBlueClr,
              size: 36,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    notification.content,
                    style: TextStyle(fontSize: 14),
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
  final String content;
  final IconData icon;
  final String event;
  bool viewed;

  NotificationItem({
    required this.title,
    required this.content,
    required this.icon,
    required this.event,
    required this.viewed,
  });
}

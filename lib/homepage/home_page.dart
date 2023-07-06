// ignore_for_file: non_constant_identifier_names,, unnecessary_statements

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:roder/favourites/favourites.dart';
import '../account/account_page.dart';
import '../drawer/nav_drawer.dart';
import '../ui/notification_page.dart';
import '../widgets/filter_button.dart';
import '../widgets/unfilter_button.dart';

/*To Do's —>

Updates —>


/
| Customization dropdown in add page
| update message popup
| make dbrides load after button click
| Notifications
| fix splash screen
| Border of text fields
| Red color of delete account
| Fix image in home page
| modify notifictations
| Fixed time picker in add page
| Update Nav drawer
| .slide for nav drawer
| contact page in nav bar instead of feedback
=================================================
| make rides expandable
\

/
| Give each user a place in the database
===============================================
| Wrtie to Database 
| Make host join ride when press on 'create ride'
| Make Host Delete Ride
| Make a Ride change-able when clicked
| Give people user names
| Give people custom pfp
| show who has joined the ride
| Show who has made the ride when pressed on circle avatar of the rides
| make more notifications (if someone has joined your ride, left etc)
| be able to share links of rides
======Show app to BMW
| Rides Near Me
| Block users
| Friends only can join (Accounts to follow(friend) someone)
| recommend a ride route based on previous ride routes (show friends(follows) rides)
| Notification page for when people add you as fried, join, leave, create, etc.
\

/ Animation update
| Settings page change /Like Contanct page\ (change color then change image and change theme then chagne image maybe something like that )
| Use Rive to add animations to the app
| Cool animation for opening nav drawer
| MAYBE beter animations for rides appearing
| Floating /maybe transparent\ nav bar
| Splash screen and loading screen for bike animation 
| Change color of picture based on theme
\

/
| iOs compatible
| log in with facebook and instagram
| Let everyone see the polyline of the ride
| save polylines in database
| addvertisement to promote
\

/
| Roder Marketplace
\
*/

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final user = FirebaseAuth.instance.currentUser!;
bool isNotificationsEnabled = true;

class _HomePageState extends State<HomePage> {
  bool isFilter1 = true;
  bool isFilter2 = false;
  bool isFilter3 = false;
  bool isFilter4 = false;
  //
  int noImg = 0;
  //Loading animation

  //Filter for the rides
  bool rideFilter = true;
  bool rideFilter2 = true;
  bool rideFilter3 = true;

  //Expandable

  //Update popup for updates
  String release = "";

  //Database
  Query dbRef = FirebaseDatabase.instance.ref().child('Rides');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('Rides');
  final databaseReference = FirebaseDatabase.instance.ref();
  //
  @override
  void initState() {
    super.initState();

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    final newVersion = NewVersionPlus(
        iOSId: 'com.tb.roder',
        androidId: 'com.tb.roder',
        androidPlayStoreCountry: "es_ES");

    final ver = VersionStatus(
      appStoreLink: '',
      localVersion: '',
      storeVersion: '',
      releaseNotes: '',
      originalStoreVersion: '',
    );
    print(ver);
    // const bool simpleBehavior = true;

    // if (simpleBehavior) {
    basicStatusCheck(newVersion);
    // }
    // else {
    // advancedStatusCheck(newVersion);
    // }
  }

  basicStatusCheck(NewVersionPlus newVersion) async {
    final version = await newVersion.getVersionStatus();
    if (version != null) {
      if (version.canUpdate) {
        hasBeenUpdated = true;
      }
      release = version.releaseNotes ?? "";
      setState(() {});
    }
    newVersion.showAlertIfNecessary(
      context: context,
      launchModeVersion: LaunchModeVersion.external,
    );
  }

  // Custom dialog for update check
  advancedStatusCheck(NewVersionPlus newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Update App',
        dialogText: 'Update App To Latest Release',
        launchModeVersion: LaunchModeVersion.external,
        allowDismissal: true,
      );
    }
  }

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
                child: FutureBuilder<DataSnapshot>(
                  future: usersRef.child(user.uid).once().then((databaseEvent) {
                    return databaseEvent.snapshot;
                  }),
                  builder: (BuildContext context,
                      AsyncSnapshot<DataSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      final userData =
                          snapshot.data!.value as Map<dynamic, dynamic>;
                      final userName = userData['name'] as String;

                      return Text(
                        'Hey $userName,',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text('Loading...');
                    }
                  },
                ),
              )
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
          SizedBox(
            height: 20,
          ),
          _getDBRides(),
        ],
      ),
    );
  }

  chooseTitleText(int nu) {
    String titleText;

    switch (nu) {
      case 0:
        titleText = 'All Rides';
        break;
      case 1:
        titleText = 'Near Me';
        break;
      case 2:
        titleText = 'Joined Rides';
        break;
      default:
        titleText = 'All Rides';
        break;
    }
    return titleText;
  }

  _getDBRides() {
    return Expanded(
      child: FirebaseAnimatedList(
        physics: BouncingScrollPhysics(),
        query: dbRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map Rides = snapshot.value as Map;
          Rides['key'] = snapshot.key;
          if (rideFilter3 == false) {
            if (joinedRides.contains(Rides['key'])) {
              return listItem(Rides: Rides)
                  .animate()
                  .slideX(duration: 300.ms)
                  .fade(duration: 400.ms);
            } else {
              return Container();
            }
          } else {
            return listItem(Rides: Rides)
                .animate()
                .slideX(duration: 300.ms)
                .fade(duration: 400.ms);
          }
        },
      ),
    );
  }

   Widget listItem({
    required Map Rides,
  }) {
    return Padding(
      //padding for spacing between rides
      padding:
          const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
      //this container is for the image
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            image: AssetImage(
              'assets/image 14.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            //this container is for the black hue
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black.withOpacity(
                  0.6,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}

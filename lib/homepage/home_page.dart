// ignore_for_file: non_constant_identifier_names,, unnecessary_statements

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:new_version_plus/new_version_plus.dart';
import '../account/account_page.dart';
import '../drawer/nav_drawer.dart';
import '../themes/theme.dart';
import '../ui/notification_page.dart';
import '../widgets/filter_button.dart';
import '../widgets/unfilter_button.dart';

/*
To Do

loading indicator for notification page

Clean the Theme Page
fix the route page system not working
Time between the selected time and the end time
save the first ride created bool with shared preferences
log in with facebook and instagram
do the message part of the app
fix the custom profile pic
(link to ride) when i press on the users in the add ride page, it hsould invite them them to the ride, learn how to open the ride that the user has been invited to
if ride is solo then instead of joining, then ask to join
notifications if someone has joined the ride
create a notification saying that the user has been invited
Follow and block users after messaging part is done
make Host delete Ride
make host join ride when press on 'create ride'
post app to playstore
iOS compatible
show app to BMW
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
          _filterRidesButtons(),
          SizedBox(
            height: 20,
          ),
          _getDBRides(),
        ],
      ),
    );
  }

  _filterRidesButtons() {
    return SingleChildScrollView(
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
    );
  }

  _getDBRides() {
    return Expanded(
      child: FirebaseAnimatedList(
        physics: BouncingScrollPhysics(),
        query: dbRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map rideData = snapshot.value as Map;
          rideData['key'] = snapshot.key;
          return listItem(rideData: rideData)
              .animate()
              .slideX(duration: 300.ms)
              .fade(duration: 400.ms);
        },
      ),
    );
  }

  Widget listItem({
    required Map rideData,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            image: AssetImage('assets/image 14.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: Text(
                    rideData['Country'],
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w100,
                      fontSize: 14,
                      color: countryRideListClr,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    rideData['City'],
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w100,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    rideData['Name'],
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w100,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    '${rideData['Riders']} Ride',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w100,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    rideData['Date'],
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w100,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 10),
                child: TextButton(
                  onPressed: () {
                    // Button onPressed logic
                  },
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white,
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      btnBlueClr,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    // minimumSize: MaterialStateProperty.all<Size>(
                    //   Size(
                    //     30,
                    //     30,
                    //   ),
                    // ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Text('Join Ride'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

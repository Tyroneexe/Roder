// ignore_for_file: non_constant_identifier_names,, unnecessary_statements

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:new_version_plus/new_version_plus.dart';
import '../drawer/nav_drawer.dart';
import '../themes/theme.dart';
import '../ui/notification_page.dart';
import '../widgets/filter_button.dart';
import '../widgets/unfilter_button.dart';

/*
To Do

fix the custom profile pic
popup when ride is clicked
| show who has joined the ride
| Show who has made the ride

if ride is solo then instead of joining, then ask to join

/
| Wrtie to Database 
| Make host join ride when press on 'create ride'
| Give people user names
add the memebers list in add ride page with firestore
save the first ride created bool with shared preferences
| Make Host Delete Ride // write the onpress function
===============================================
======Show app to BMW
log in with facebook and instagram
iOS compatible
| Rides Near Me
| Block users // do after creating the messages part
| Friends only can join (Accounts to follow(friend) someone) //only send ride id to the invited user
| recommend a ride route based on previous ride routes (show friends(follows) rides)
| Notification page for when people add you as fried, join, leave, create, etc.
////////////////////////////////////////////////////////////////
do the message part of the app after the update
make notification system using firestore, it would be easier instead of using prefs
add edit rides after creating the notification system
(https link to ride) when i press on the users in the add ride page, it hsould invite them them to the ride, learn how to open the ride that the user has been invited to
notifications if someone has joined the ride
create a notification saying that the user has been invited
Follow and block users after messaging part is done
| Make a Ride change-able when clicked //only host can do this //maybe do this after messages
\
*/

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final currentUser = FirebaseAuth.instance.currentUser!;
bool isNotificationsEnabled = true;

class _HomePageState extends State<HomePage> {
  //ride filters for rides
  bool isFilter1 = true;
  bool isFilter2 = false;
  bool isFilter3 = false;
  bool isFilter4 = false;

  //Update popup for updates
  String release = "";

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
                child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser.uid)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      final userData =
                          snapshot.data!.data() as Map<String, dynamic>;
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
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('rides').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final rides = snapshot.data?.docs.reversed.toList();
                return FutureBuilder<List<Widget>>(
                  future: buildRideWidgets(rides),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      final riderWidgets = snapshot.data!;
                      return Expanded(
                        child: ListView(
                          children: riderWidgets,
                        ),
                      );
                    } else {
                      return Text('Error loading rides.');
                    }
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<List<Widget>> buildRideWidgets(
      List<QueryDocumentSnapshot>? rides) async {
    List<Widget> rideWidgets = [];
    int imageNumber = 0;

    if (rides != null) {
      for (var ride in rides) {
        imageNumber = (imageNumber % 4) + 1;
        final snapshot =
            await FirebaseFirestore.instance.collection('users').get();
        if (snapshot.docs.isNotEmpty) {
          final users = snapshot.docs.reversed.toList();
          final currentUserDB =
              users.firstWhere((user) => user.id == currentUser.uid);
          if (isFilter3 && currentUserDB['joinedRides'].contains(ride.id)) {
            final rideWidget = RideListItem(
              ride: ride,
              imageNumber: imageNumber,
            )
                .animate()
                .slideY(duration: 400.ms, begin: 1)
                .fade(duration: 400.ms);
            rideWidgets.add(rideWidget);
          } else if (isFilter4 && await isRideCreatedByCurrentUser(ride.id)) {
            final rideWidget = CreatedRideListItem(
              ride: ride,
              imageNumber: imageNumber,
            )
                .animate()
                .slideY(duration: 400.ms, begin: 1)
                .fade(duration: 400.ms);
            rideWidgets.add(rideWidget);
          } else if (isFilter1) {
            final rideWidget = RideListItem(
              ride: ride,
              imageNumber: imageNumber,
            )
                .animate()
                .slideY(duration: 400.ms, begin: 1)
                .fade(duration: 400.ms);
            rideWidgets.add(rideWidget);
          } else if (isFilter2 && ride['Country'] == currentUserDB['country']) {
            final rideWidget = RideListItem(
              ride: ride,
              imageNumber: imageNumber,
            )
                .animate()
                .slideY(duration: 400.ms, begin: 1)
                .fade(duration: 400.ms);
            rideWidgets.add(rideWidget);
          }
        }
      }
    }

    return rideWidgets;
  }

  Future<bool> isRideJoinedByCurrentUser(String rideId) async {
    // this function should also check if the user
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

    final snapshot = await userDoc.get();
    final ridesArray = snapshot.data()?['joined_rides'] as List<dynamic>?;

    if (ridesArray != null && ridesArray.contains(rideId)) {
      return true;
    }

    return false;
  }

  Future<bool> isRideCreatedByCurrentUser(String rideId) async {
    // this function should also check if the user
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

    final snapshot = await userDoc.get();
    final ridesArray = snapshot.data()?['rides'] as List<dynamic>?;

    if (ridesArray != null && ridesArray.contains(rideId)) {
      return true;
    }

    return false;
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
                    'My Rides',
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
                    'My Rides',
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
}

class RideListItem extends StatelessWidget {
  RideListItem({
    super.key,
    required this.ride,
    required this.imageNumber,
  });

  final QueryDocumentSnapshot<Object?> ride;
  final int imageNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            image: AssetImage('assets/image $imageNumber.png'),
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
                    ride['Country'],
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
                    ride['City'],
                    style: rideListItemTxt.copyWith(fontSize: 20),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    '${ride['Riders']} Ride',
                    style: rideListItemTxt,
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    ride['Date'],
                    style: rideListItemTxt,
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    ride['Start Time'] + '  to  ' + ride['End Time'],
                    style: rideListItemTxt,
                  ),
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final users = snapshot.data?.docs.reversed.toList();
                  final currentUserDB =
                      users?.firstWhere((user) => user.id == currentUser.uid);
                  return Positioned(
                    bottom: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 10),
                      child: TextButton(
                        onPressed: () {
                          if (currentUserDB['joinedRides'].contains(ride.id)) {
                            _addedRideBar();
                          } else {
                            _addJoinedRideToDB();
                          }
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
                            currentUserDB!['joinedRides'].contains(ride.id)
                                ? outlineBtnClr
                                : blueClr,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: currentUserDB['joinedRides'].contains(ride.id)
                              ? Text('Leave Ride')
                              : Text('Join Ride'),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Text('Loading...');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _addedRideBar() {
    Get.snackbar("Already Joined", "You have already joined this ride",
        snackPosition: SnackPosition.TOP,
        borderWidth: 2,
        borderColor: blueClr,
        backgroundColor: Colors.white,
        colorText: blueClr,
        icon: const Icon(Icons.add_location_outlined));
  }

  _addJoinedRideToDB() {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    // Reference the user document
    final userDoc = usersCollection.doc(currentUser.uid);

    // Get the ride document ID
    final rideDocId = ride.id; // Assuming 'ride' is the ride document

    // Add the ride ID to the "joinedRides" subcollection within the user document
    userDoc.update({
      'joinedRides': FieldValue.arrayUnion([rideDocId]),
    });
  }
}

class CreatedRideListItem extends StatelessWidget {
  CreatedRideListItem({
    super.key,
    required this.ride,
    required this.imageNumber,
  });

  final QueryDocumentSnapshot<Object?> ride;
  final int imageNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            image: AssetImage('assets/image $imageNumber.png'),
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
                  child: Text(ride['Country'],
                      style: rideListItemTxt.copyWith(
                        color: countryRideListClr,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    ride['City'],
                    style: rideListItemTxt.copyWith(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    '${ride['Riders']} Ride',
                    style: rideListItemTxt,
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    ride['Date'],
                    style: rideListItemTxt,
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    ride['Start Time'] + '  to  ' + ride['End Time'],
                    style: rideListItemTxt,
                  ),
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final users = snapshot.data?.docs.reversed.toList();
                  final currentUserDB =
                      users?.firstWhere((user) => user.id == currentUser.uid);
                  return Positioned(
                    bottom: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 10),
                      child: TextButton(
                        onPressed: () {
                          if (currentUserDB!['rides'].contains(ride.id)) {
                            _deleteRideAlert(context);
                          } else {
                            Text('Cannot Delete Ride');
                          }
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
                            rred,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Text('End Ride'),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Text('Loading...');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _deleteRideAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: navBarBkgClr,
          title: Text(
            'End Ride',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          content: Text(
            'Are you sure you want to end this ride',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w100,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: recentTxtClr,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Yes',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: blueClr,
                ),
              ),
              onPressed: () {
                deleteRideFromDB(ride.id);
                Navigator.of(context).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 20,
        );
      },
    );
  }

  deleteRideFromDB(String documentId) {
    FirebaseFirestore.instance
        .collection('rides')
        .doc(documentId)
        .delete()
        .then((value) {
      print('Document deleted successfully');
    }).catchError((error) {
      print('Failed to delete document: $error');
    });
  }
}

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

fix the custom profile pic (wih firebase storage)

add view on google maps
enhance the image 1, 2, 3, 4

random image each time in about us page

fix updates page

/
| Wrtie to Database 
| Make host join ride when press on 'create ride'
| Give people user names
add the memebers list in add ride page with firestore
save the first ride created bool with shared preferences
| Make Host Delete Ride // write the onpress function
popup when ride is clicked
| show who has joined the ride
| Show who has made the ride
Add participants row in singechildschrollview
about us page icon in the appbar
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
if ride is solo then instead of joining, then ask to join
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
        imageNumber = (imageNumber % 5) + 1;
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
            image: AssetImage('assets/image $imageNumber.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                _ridePopup(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black.withOpacity(0.6),
                ),
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
                            _leaveRide();
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

  _ridePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                6,
              ),
            ),
          ),
          elevation: 10,
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                      child: Image.asset(
                        'assets/image $imageNumber.jpg',
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    ride['Address'],
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: blueClr),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.access_time_filled_outlined,
                      size: 26,
                      color: blueClr,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "${ride['Date'].substring(0, ride['Date'].length - 5)}  |  ${ride['Start Time']} to ${ride['End Time']}",
                      style: roRegular14.copyWith(
                        fontWeight: FontWeight.w100,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.location_pin,
                      size: 28,
                      color: blueClr,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "${ride['City']}, ${ride['Country']}",
                      style: roRegular14.copyWith(
                        fontWeight: FontWeight.w100,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'View on Google Maps',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: blueClr,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: Text(
                    'Creator',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      ride['User'],
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: Text(
                    'Participants',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                JoinedUsersWidget(rideId: ride.id),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _leaveRide() {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    // Reference the user document
    final userDoc = usersCollection.doc(currentUser.uid);

    // Get the ride document ID
    final rideDocId = ride.id; // Assuming 'ride' is the ride document

    // Add the ride ID to the "joinedRides" subcollection within the user document
    userDoc.update({
      'joinedRides': FieldValue.arrayRemove([rideDocId]),
    });
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

class JoinedUsersWidget extends StatelessWidget {
  final String rideId;

  JoinedUsersWidget({required this.rideId});

  Future<List<Widget>> fetchJoinedUsers() async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    QuerySnapshot rideUsersSnapshot =
        await usersCollection.where('joinedRides', arrayContains: rideId).get();

    List<DocumentSnapshot> rideUsersDocuments = rideUsersSnapshot.docs;

    List<Widget> rideUsers =
        rideUsersDocuments.map((DocumentSnapshot document) {
      return Padding(
        padding: const EdgeInsets.only(left: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            document.get('foto'),
            height: 40,
            width: 40,
            fit: BoxFit.cover,
          ),
        ),
      );
    }).toList();

    return rideUsers;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: fetchJoinedUsers(),
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while fetching the data
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          // Handle any error that occurred during data fetching
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.hasData) {
          // Display the fetched user widgets
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: snapshot.data!,
            ),
          );
        }

        // Default fallback if no data is available
        return Text('No joined users found');
      },
    );
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
            image: AssetImage('assets/image $imageNumber.jpg'),
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

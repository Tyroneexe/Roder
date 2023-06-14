// ignore_for_file: non_constant_identifier_names,, unnecessary_statements

import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:provider/provider.dart';
import 'package:roder/favourites/favourites.dart';
import 'package:roder/ui/theme.dart';
import 'package:roder/ui/widgets/frosted_glass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../drawer/nav_drawer.dart';
import '../provider/clrProvider.dart';
import 'add_task_bar.dart';

/*To Do's —>

Updates —>

/ User update
| Wrtie to Database 
| Make host join ride when press on 'create ride'
| Delete ride
\

/ Noti update
| Customization dropdown in add page
| update message popup
| make dbrides load after button click
| Notifications
| fix splash screen
=================================================
| word counter on text fields in add ride page because people can add infinite text
| make search bar neon outburst
| Make a Ride change-able when clicked
| ai art for app
| log in with facebook and instagram
| Make Host Delete Ride
| change color and images for the theme (main color blue)
| be able to share links of rides
| show app to BMW
\

/ iOs Update
| iOs version
| Let everyone see the polyline of the ride
| add 'Detail' to the listItem of the ride widget
| PopUp when ride is clicked
| save polylines in database
| make the splash screen the same font as the app
| chage the font of the app
| addvertisement to promote
\

/ AI update
| In-app Purchases (Premium)
| recommend a ride route based on previous ride routes
\
*/

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final user = FirebaseAuth.instance.currentUser!;

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });

    Timer(Duration(milliseconds: 400), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  //
  bool rideFilter = true;
  bool rideFilter2 = true;
  bool rideFilter3 = true;
  //
  String release = "";
  //
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

    // Instantiate NewVersion manager object (Using GCP Console app as example)
    final newVersion = NewVersionPlus(
        iOSId: 'com.tb.roder',
        androidId: 'com.tb.roder',
        androidPlayStoreCountry: "es_ES" //support country code
        );

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
      drawer: NavitionDrawer(),
      backgroundColor: context.theme.colorScheme.background,
      body: CustomScrollView(
        slivers: [
          _appBar(context),
          SliverFillRemaining(
            child: Column(
              children: [
                _titleBar(),
                if (_isLoading)
                  CircularProgressIndicator(
                    color: _getMainClr(
                        Provider.of<ColorProvider>(context).selectedColor),
                  ),
                if (!_isLoading) _getDBRides(),
                // _getDBRides(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _appBar(BuildContext context) {
    return SliverAppBar(
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(24),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            color: context.theme.colorScheme.background,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _getMainClr(
                        Provider.of<ColorProvider>(context).selectedColor),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/RoderHome.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    child: FrostedGlassBox(
                      theGradientColor: [
                        rideFilter
                            ? Colors.white.withOpacity(0.15)
                            : _getMainClr(Provider.of<ColorProvider>(context)
                                    .selectedColor)
                                .withOpacity(0.4),
                        rideFilter
                            ? Colors.white.withOpacity(0.05)
                            : _getMainClr(Provider.of<ColorProvider>(context)
                                    .selectedColor)
                                .withOpacity(0.3),
                      ],
                      theBorderColor: rideFilter
                          ? Colors.white.withOpacity(0.13)
                          : _getMainClr(Provider.of<ColorProvider>(context)
                              .selectedColor),
                      theWidth: 150.0,
                      theHeight: 80.0,
                      theChild: Text(
                        'All Rides',
                        style: TextStyle(
                            fontFamily: 'AudioWide',
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (!_isLoading) _startLoading();
                        rideFilter = !rideFilter;
                        rideFilter2 = true;
                        rideFilter3 = true;
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    child: FrostedGlassBox(
                      theGradientColor: [
                        rideFilter2
                            ? Colors.white.withOpacity(0.15)
                            : _getMainClr(Provider.of<ColorProvider>(context)
                                    .selectedColor)
                                .withOpacity(0.4),
                        rideFilter2
                            ? Colors.white.withOpacity(0.05)
                            : _getMainClr(Provider.of<ColorProvider>(context)
                                    .selectedColor)
                                .withOpacity(0.3),
                      ],
                      theBorderColor: rideFilter2
                          ? Colors.white.withOpacity(0.13)
                          : _getMainClr(Provider.of<ColorProvider>(context)
                              .selectedColor),
                      theWidth: 150.0,
                      theHeight: 80.0,
                      theChild: Text(
                        'Near Me',
                        style: TextStyle(
                            fontFamily: 'AudioWide',
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (!_isLoading) _startLoading();
                        rideFilter2 = !rideFilter2;
                        rideFilter = true;
                        rideFilter3 = true;
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    child: FrostedGlassBox(
                      theGradientColor: [
                        rideFilter3
                            ? Colors.white.withOpacity(0.15)
                            : _getMainClr(Provider.of<ColorProvider>(context)
                                    .selectedColor)
                                .withOpacity(0.4),
                        rideFilter3
                            ? Colors.white.withOpacity(0.05)
                            : _getMainClr(Provider.of<ColorProvider>(context)
                                    .selectedColor)
                                .withOpacity(0.3),
                      ],
                      theBorderColor: rideFilter3
                          ? Colors.white.withOpacity(0.13)
                          : _getMainClr(Provider.of<ColorProvider>(context)
                              .selectedColor),
                      theWidth: 150.0,
                      theHeight: 80.0,
                      theChild: Text(
                        'Joined',
                        style: TextStyle(
                            fontFamily: 'AudioWide',
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (!_isLoading) _startLoading();
                        rideFilter3 = !rideFilter3;
                        rideFilter = true;
                        rideFilter2 = true;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 35,
            ),
          ],
        ),
      ),
      expandedHeight: 160.0,
      pinned: false,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add_circle),
          onPressed: () {
            Get.to(() => AddTaskPage());
          },
        ),
      ],
    );
  }

  _titleBar() {
    return Container(
      margin: const EdgeInsets.only(right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          Text(
            !rideFilter
                ? chooseTitleText(0)
                : !rideFilter2
                    ? chooseTitleText(1)
                    : !rideFilter3
                        ? chooseTitleText(2)
                        : chooseTitleText(0),
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
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
        titleText = 'Random';
        break;
      default:
        titleText = 'All Rides';
        break;
    }
    return titleText;
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return lightBlueClr;
      case 1:
        return iceCold;
      case 2:
        return vBlue;
      default:
        return lightBlueClr;
    }
  }

  _getMainClr(int no) {
    switch (no) {
      case 0:
        setState(() {});
        return lightBlueClr;
      case 1:
        setState(() {});
        return oRange;
      case 2:
        setState(() {});
        return themeRed;
      default:
        setState(() {});
        return lightBlueClr;
    }
  }

  _getDBRides() {
    return Expanded(
      child: FirebaseAnimatedList(
        physics: NeverScrollableScrollPhysics(),
        query: dbRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map Rides = snapshot.value as Map;
          Rides['key'] = snapshot.key;
          return listItem(Rides: Rides);
        },
      ),
    );
  }

  Widget listItem({
    required Map Rides,
  }) {
    saveprefs() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList("joined_rides", joinedRides);
    }

    return Slidable(
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 1 / 5,
        children: [
          SlidableAction(
            backgroundColor: _getBGClr(Rides['Color']),
            icon: Icons.add,
            label: 'JOIN',
            onPressed: (context) async {
              print(Rides['key']);
              if (!joinedRides.contains(Rides['key'])) {
                joinedRides.add(Rides['key']);
                saveprefs();
                databaseReference
                    .child('Rides/${Rides['key']}')
                    .update({'Joined': Rides['Joined'] + 1});
                _addedToFav();
                setState(() {});
              } else {
                _alreadyJoined();
              }
            },
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(20),
            height: 200,
            decoration: BoxDecoration(
              color: joinedRides.contains(Rides['key'])
                  ? darkGr
                  : _getBGClr(Rides['Color']),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Stack(
              children: [
                Container(
                  // color: Colors.red.withOpacity(0.2),
                  padding: EdgeInsets.only(left: 205, top: 100),
                  child: Text(
                    "Joined: ${Rides['Joined'].toString()}",
                    style: tyStyle,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: Center(
                        child: Text(
                          Rides['Name'],
                          style: const TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          Rides['Origin'] + '  to  ' + Rides['Destination'],
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(Rides['Date'], style: tyStyle),
                    Text(
                      Rides['Start Time'] + '  to  ' + Rides['End Time'],
                      style: tyStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(Rides['GPhoto']),
            ),
          ),
        ],
      ),
      closeOnScroll: true,
    );
  }

  _alreadyJoined() {
    Get.snackbar("RIDE ALREADY JOINED", "You have already joined this ride",
        snackPosition: SnackPosition.TOP,
        borderWidth: 5,
        borderColor: sandyClr,
        backgroundColor: Colors.white,
        colorText: sandyClr,
        icon: const Icon(Icons.access_time_filled_rounded));
  }

  _addedToFav() {
    Get.snackbar("RIDE ADDED", "Ride added to Favorites",
        snackPosition: SnackPosition.TOP,
        borderWidth: 5,
        borderColor: Colors.green[600],
        backgroundColor: Colors.white,
        colorText: Colors.green[600],
        icon: const Icon(Icons.add));
  }
}

// ignore_for_file: non_constant_identifier_names,, unnecessary_statements

import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:provider/provider.dart';
import 'package:roder/ui/theme.dart';
import 'package:roder/ui/widgets/frosted_glass.dart';
import 'package:roder/ui/widgets/ride_listitem.dart';
import '../drawer/nav_drawer.dart';
import '../provider/clrProvider.dart';
import 'add_task_bar.dart';

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
=================================================
| make rides expandable
| change the listItem to a page and use it like that (test it for one return listItem first, before changing everything to that page and it not working)
| contact page in nav bar instead of feedback
| See if you can change the _getBGColor and _bgcolor to also seperate page for beter and more readible code
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
| Use Rive to add animations to the app
| Cool animation for opening nav drawer
| MAYBE beter animations for rides appearing
| Floating /maybe transparent\ nav bar
| Splash screen and loading screen for bike animation 
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
  bool isRideExpanded = false;
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
                if (!_isLoading) RidesList(),
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
            image: AssetImage('assets/splash_screen.png'),
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
          icon: Icon(
            Icons.add_circle,
          ),
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
        titleText = 'Joined Rides';
        break;
      default:
        titleText = 'All Rides';
        break;
    }
    return titleText;
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
}

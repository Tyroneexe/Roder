// ignore_for_file: non_constant_identifier_names

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:roder/provider/clrProvider.dart';
import 'package:roder/ui/add_task_bar.dart';
import 'package:roder/ui/home_page.dart';
import 'package:roder/ui/theme.dart';
import 'package:roder/ui/widgets/frosted_glass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'favourites/favourites.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  bool rideFilter = false;
  bool rideFilter2 = false;
  bool rideFilter3 = false;
  //
  Query dbRef = FirebaseDatabase.instance.ref().child('Rides');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('Rides');
  final databaseReference = FirebaseDatabase.instance.ref();
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/splash_screen.png'),
                  fit: BoxFit.fill,
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
                            theColor: rideFilter
                                ? Colors.white.withOpacity(0.13)
                                : _getMainClr(
                                    Provider.of<ColorProvider>(context)
                                        .selectedColor),
                            theWidth: 150.0,
                            theHeight: 80.0,
                            theChild: Text(
                              'All Rides',
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.black),
                            ),
                          ),
                          onTap: () {
                            rideFilter = true;
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          child: FrostedGlassBox(
                            theColor: rideFilter2
                                ? Colors.white.withOpacity(0.13)
                                : _getMainClr(
                                    Provider.of<ColorProvider>(context)
                                        .selectedColor),
                            theWidth: 150.0,
                            theHeight: 80.0,
                            theChild: Text(
                              'Near Me',
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.black),
                            ),
                          ),
                          onTap: () {
                            rideFilter2 = false;
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          child: FrostedGlassBox(
                            theColor: rideFilter3
                                ? Colors.white.withOpacity(0.13)
                                : _getMainClr(
                                    Provider.of<ColorProvider>(context)
                                        .selectedColor),
                            theWidth: 150.0,
                            theHeight: 80.0,
                            theChild: Text(
                              'Random',
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.black),
                            ),
                          ),
                          onTap: () {
                            rideFilter3 = true;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            expandedHeight: 150.0,
            pinned: false,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add_circle),
                onPressed: () {
                  Get.to(() => AddTaskPage());
                },
              ),
            ],
          ),
          SliverFillRemaining(
            child: Column(
              children: [
                _titleBar(),
                _getDBRides(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _titleBar() {
    return Container(
      margin: const EdgeInsets.only(right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Near Me',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  chooseTitleText(int nu) {
    switch (nu) {
      case 0:
        setState(() {
          Text('All');
        });
        break;
      case 1:
        setState(() {
          Text('Near Me');
        });
        break;
      case 2:
        setState(() {
          Text('Random');
        });
        break;
      default:
        setState(() {
          Text('Near Me');
        });
        break;
    }
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
          //unique key/id of each item in db
          Rides['key'] = snapshot.key;
          Rides['ref'] = snapshot.child('Rides/${user.uid}');
          print(Rides['key']);
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

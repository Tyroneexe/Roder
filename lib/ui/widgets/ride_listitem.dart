// ignore_for_file: non_constant_identifier_names

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../favourites/favourites.dart';
import '../theme.dart';

class RidesList extends StatefulWidget {
  const RidesList({super.key});

  @override
  State<RidesList> createState() => _RidesListState();
}

class _RidesListState extends State<RidesList> {
  bool rideFilter = true;
  bool rideFilter2 = true;
  bool rideFilter3 = true;
  //
    Query dbRef = FirebaseDatabase.instance.ref().child('Rides');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('Rides');
  final databaseReference = FirebaseDatabase.instance.ref();
  //
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FirebaseAnimatedList(
        physics: NeverScrollableScrollPhysics(),
        query: dbRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map Rides = snapshot.value as Map;
          Rides['key'] = snapshot.key;
          if (rideFilter3 == false) {
            if (joinedRides.contains(Rides['key'])) {
              return listItemFav(Rides: Rides)
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

  Widget listItemFav({
    required Map Rides,
  }) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 1 / 5,
        children: [
          SlidableAction(
            backgroundColor: rred,
            label: 'LEAVE',
            icon: Icons.logout,
            onPressed: (context) async {
              databaseReference
                  .child('Rides/${Rides['key']}')
                  .update({'Joined': Rides['Joined'] - 1});
              _delFromFav();
              if (joinedRides.contains(Rides['key'])) {
                joinedRides.remove(Rides['key']);
                //update shared preferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.setStringList('joined_rides', joinedRides);
                setState(() {});
              }
            },
          )
          // SlidableAction(
          //   backgroundColor: _getBGClr(Rides['Color']),
          //   icon: Icons.more_horiz,
          //   label: 'DETAIL',
          //   onPressed: (BuildContext context) async {
          //     //
          //   },
          // ),
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
            child: Stack(children: [
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
            ]),
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


      _getBGClr(int no) {
    switch (no) {
      case 0:
        return blueClr;
      case 1:
        return lightBlueClr;
      case 2:
        return vBlue;
      default:
        return blueClr;
    }
  }

    _delFromFav() {
    Get.snackbar("RIDE REMOVED", "Ride removed from Favorites",
        snackPosition: SnackPosition.TOP,
        // duration: 2,
        borderWidth: 5,
        borderColor: rred,
        backgroundColor: Colors.white,
        colorText: rred,
        icon: const Icon(Icons.logout));
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
// ignore_for_file: non_constant_identifier_names

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:roder/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'favourites/favourites.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {

  Query dbRef = FirebaseDatabase.instance.ref().child('Rides');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('Rides');
  final databaseReference = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getDBRides(),
    );
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
                // _addedToFav();
                setState(() {});
              } else {
                // _alreadyJoined();
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

}
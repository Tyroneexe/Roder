// ignore_for_file: non_constant_identifier_names

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:roder/themes/theme.dart';
import 'favourites/favourites.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  bool isExpanded = false;
  //
  Query dbRef = FirebaseDatabase.instance.ref().child('Rides');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('Rides');
  final databaseReference = FirebaseDatabase.instance.ref();
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          _getDBRides(),
        ],
      ),
    );
  }

  _getDBRides() {
    return Expanded(
      child: FirebaseAnimatedList(
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
    return GestureDetector(
      child: Slidable(
        
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 1 / 5,
          children: [
            SlidableAction(
              backgroundColor: _getBGClr(Rides['Color']),
              icon: Icons.add,
              label: 'JOIN',
              onPressed: (context) async {
                //
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
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
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
                        Rides['Origin'],
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
      ),
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
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

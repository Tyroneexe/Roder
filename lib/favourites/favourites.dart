// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/clrProvider.dart';
import '../themes/theme.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

List<String> joinedRides = [];

class _FavouritesState extends State<Favourites> {
  final databaseReference = FirebaseDatabase.instance.ref();

  final user = FirebaseAuth.instance.currentUser!;

  Query dbRef = FirebaseDatabase.instance.ref().child('Rides');

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  Future<void> getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedRides = prefs.getStringList("joined_rides") ?? [];
    joinedRides = savedRides;
    //
    setState(() {});
  }

  Widget listItem({
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
              color: _getBGClr(Rides['Color']),
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
                            fontFamily: 'Roboto',
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
                            fontFamily: 'Roboto',
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
    if (Provider.of<ColorProvider>(context).selectedColor == 0) {
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
    } else if (Provider.of<ColorProvider>(context).selectedColor == 1) {
      switch (no) {
        case 0:
          return oRange;
        case 1:
          return lightOrange;
        case 2:
          return skinOrange;
        default:
          return oRange;
      }
    } else {
      switch (no) {
        case 0:
          return themeRed;
        case 1:
          return rred;
        case 2:
          return darkRed;
        default:
          return themeRed;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        appBar: _appbar(context),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'You Have Joined:',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Get.isDarkMode ? Colors.white : Colors.black),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  color: primaryClr,
                  strokeWidth: 3,
                  onRefresh: _refresh,
                  child: FirebaseAnimatedList(
                    physics: BouncingScrollPhysics(),
                    query: dbRef,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      Map Rides = snapshot.value as Map;
                      Rides['key'] = snapshot.key;
                      //
                      //
                      if (joinedRides.contains(Rides['key'])) {
                        return listItem(Rides: Rides)
                            .animate()
                            .slideX(duration: 300.ms)
                            .fade(duration: 400.ms);
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ]));
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

  _appbar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: context.theme.colorScheme.background,
        actions: [
          GestureDetector(
            child: CircleAvatar(
              radius: 22,
              foregroundImage: NetworkImage(user.photoURL!),
            ),
            onTap: () {
              // Get.to(() => AccountPage());
            },
          ),
          const SizedBox(
            width: 15,
          )
        ]);
  }

  Future _refresh() async {
    setState(() {});
  }
}

// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
                      Map rideData = snapshot.value as Map;
                      rideData['key'] = snapshot.key;
                      //
                      //
                      if (joinedRides.contains(rideData['key'])) {
                        return listItem(rideData: rideData)
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

  // _delFromFav() {
  //   Get.snackbar("RIDE REMOVED", "Ride removed from Favorites",
  //       snackPosition: SnackPosition.TOP,
  //       // duration: 2,
  //       borderWidth: 5,
  //       borderColor: rred,
  //       backgroundColor: Colors.white,
  //       colorText: rred,
  //       icon: const Icon(Icons.logout));
  // }

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

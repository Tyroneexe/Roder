// ignore_for_file: non_constant_identifier_names,

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:roder/favourites/favourites.dart';
import 'package:roder/ui/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../drawer/nav_drawer.dart';
import '../provider/clrProvider.dart';

/*To Do's —>

Updates —>

/ Tidy Up update
| else show snackbar (you have already joined this ride)
| Can select primary color
| Settigns page can delete account
| customization dropdown (just like the one in search page) can choose customization
| fix google maps (search controller)
| fix color of the dark mode 1 (this is first becuase if i use flutter's 
|  default dark mode, there is no need for the color chagne of the nav bar)
| fix color of the nav bar 2
| container expands in update page
| fix about page popup
| fancy containers for latest update page
| latest update page
| Create main color at the start of the app
| fix settings page containers
| Fix font
| Give each user a place in the database
==========================================
| Wrtie to Database 
| Make host join ride when press on 'create ride'
| Delete ride
| fix font changing on different devices
\


/ UI and UX Update
| Use AI images to improve UI
| navigation bar
| use animated icons for navbar
| change color and images for the theme (main color blue)
| glas kit pub dev package
| dragable home pub dev package
| remove food in about page popup
\


/ Noti update
| Customization dropdown in add page
| add to promote
| log in with facebook and instagram
| make search bar neon outburst
| Make Host Delete Ride
| Change  primary Color
| Notifications
| Make a Ride change-able when clicked
| invest in some art
| word counter on text fields in add ride page because people can add infinite text
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
  Query dbRef = FirebaseDatabase.instance.ref().child('Rides');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('Rides');
  final databaseReference = FirebaseDatabase.instance.ref();
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      drawer: NavitionDrawer(),
      appBar: _appbar(),
      body: Column(
        children: [
          _titleBar(),
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
            backgroundColor: _getBGClr(Rides['ref']['Color']),
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
              // else show snackbar (you have already joined this ride)
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
                  : _getBGClr(Rides['Color'] ?? 0),
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
                          Rides['Name'] ?? '',
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
                          Rides['Origin'] ??
                              '' + '  to  ' + (Rides['Destination'] ?? ''),
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
                    Text(Rides['Date'] ?? '', style: tyStyle),
                    Text(
                      Rides['Start Time'] ??
                          '' + '  to  ' + (Rides['End Time'] ?? ''),
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
              backgroundImage: NetworkImage(Rides['GPhoto'] ?? ''),
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
        return iceCold;
      case 2:
        return vBlue;
      default:
        return blueClr;
    }
  }

  _getMainClr(int no) {
    switch (no) {
      case 0:
        setState(() {});
        return blueClr;
      case 1:
        setState(() {});
        return oRange;
      case 2:
        setState(() {});
        return themeRed;
      default:
        setState(() {});
        return blueClr;
    }
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _appbar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        DateFormat.yMMMMd().format(DateTime.now()),
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: _getMainClr(Provider.of<ColorProvider>(context).selectedColor),
          // foreground: Paint()
          //   ..shader = LinearGradient(
          //     colors: [blueClr, oRange],
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //   ).createShader(Rect.fromLTWH(100, 100, 100, 100)),
        ),
      ),
      iconTheme:
          IconThemeData(color: Get.isDarkMode ? Colors.white : Colors.black),
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      actions: [
        // Icon(Icons.mail_outline,
        //     size: 30, color: Get.isDarkMode ? Colors.white : Colors.black),
        const SizedBox(
          width: 7,
        )
      ],
    );
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

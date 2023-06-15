// ignore_for_file: non_constant_identifier_names, unused_local_variable, unused_field
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:roder/ui/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../favourites/favourites.dart';
import '../provider/clrProvider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Color _mainColor = lightBlueClr;
  bool isDateBarVisible = false;
  bool isArrowUp = true;
  DateTime _selectedDate = DateTime.now();
  Query dbRef = FirebaseDatabase.instance.ref().child('Rides');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('Rides');
  final searchFilter = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.colorScheme.background,
      ),
      backgroundColor: context.theme.colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Search for a Ride',
              //Search for a Ride
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Get.isDarkMode ? Colors.white : Colors.black),
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
            child: TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(
                hintText: 'Sunday Breakfast Run',
                //eg: BMW Breakfast Run
                hintStyle: const TextStyle(
                    fontFamily: 'OpenSans', fontSize: 18, color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                      color: _getMainClr(
                          Provider.of<ColorProvider>(context).selectedColor)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          Center(
            child: SizedBox(
              width: 140,
              height: 50,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isDateBarVisible = !isDateBarVisible;
                  });
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Select a Date',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: _getMainClr(
                          Provider.of<ColorProvider>(context).selectedColor),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Icon(
                    isDateBarVisible
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _getMainClr(
                        Provider.of<ColorProvider>(context).selectedColor),
                  ),
                ]),
              ),
            ),
          ),
          if (isDateBarVisible) _addDateBar(),
          Expanded(
            child: FirebaseAnimatedList(
              query: dbRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                final title = snapshot.child('Name').value.toString();

                if (searchFilter.text.isEmpty && isDateBarVisible == false) {
                  Map Rides = snapshot.value as Map;
                  Rides['key'] = snapshot.key;
                  return listItem(Rides: Rides);
                }
                if (isDateBarVisible) {
                  Map Rides = snapshot.value as Map;
                  if (Rides['Date'] ==
                      DateFormat("d MMMM yyyy").format(_selectedDate)) {
                    return listItem(Rides: Rides);
                  } else {
                    return Container();
                  }
                } else if (title
                    .toLowerCase()
                    .contains(searchFilter.text.toLowerCase().toString())) {
                  Map Rides = snapshot.value as Map;
                  Rides['key'] = snapshot.key;
                  return listItem(Rides: Rides);
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
      ),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor:
            _getMainClr(Provider.of<ColorProvider>(context).selectedColor),
        selectedTextColor: Colors.white,
        dateTextStyle: const TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.grey),
        dayTextStyle: const TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey),
        monthTextStyle: const TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _getMainClr(int no) {
    switch (no) {
      case 0:
        _mainColor = lightBlueClr;
        return lightBlueClr;
      case 1:
        _mainColor = oRange;
        return oRange;
      case 2:
        _mainColor = themeRed;
        return themeRed;
      default:
        _mainColor = lightBlueClr;
        return lightBlueClr;
    }
  }
}

final databaseReference = FirebaseDatabase.instance.ref();

Widget listItem({
  required Map Rides,
  // required rideKey,
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
            if (!joinedRides.contains(Rides['key'])) {
              joinedRides.add(Rides['key']);
              saveprefs();
              databaseReference
                  .child('Rides/${Rides['key']}')
                  .update({'Joined': Rides['Joined'] + 1});
              _addedToFav();
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

_addedToFav() {
  Get.snackbar("RIDE ADDED", "Ride added to Favorites",
      snackPosition: SnackPosition.TOP,
      borderWidth: 5,
      borderColor: Colors.green[600],
      backgroundColor: Colors.white,
      colorText: Colors.green[600],
      icon: const Icon(Icons.add));
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

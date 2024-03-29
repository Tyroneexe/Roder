// ignore_for_file: unnecessary_null_comparison, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roder/homepage/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/colors.dart';
import '../themes/text_styles.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchFilter = TextEditingController();
  List<String> recentHistory = [];

  @override
  void initState() {
    super.initState();
    loadRecentHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              searchBar(context),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 23,
              ),
              Text(
                'Recent History',
                style: w700.copyWith(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          if (searchFilter.text == '') ...[
            if (recentHistory.length == 0) ...[
              Container(
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/NotiRoderImage.png'),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'No Searches Yet',
                style: w700.copyWith(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Go ahead and explore some rides!',
                style: w100.copyWith(
                  fontSize: 14,
                ),
              ),
            ] else ...[
              Expanded(
                child: ListView.builder(
                  itemCount: recentHistory.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: GestureDetector(
                        onTap: () {
                          searchFilter.text = recentHistory[index];
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.history,
                              color: recentTxtClr,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              recentHistory[index],
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: recentTxtClr,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  recentHistory.removeAt(index);
                                });
                                saveRecentHistory();
                              },
                              child: Icon(
                                Icons.close_rounded,
                                color: recentTxtClr,
                                size: 22,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ] else ...[
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('rides').snapshots(),
              builder: (context, snapshot) {
                List<Widget> rideWidgets = [];
                int imageNumber = 0;
                imageNumber = (imageNumber % 5) + 1;

                if (snapshot.hasData) {
                  final rides = snapshot.data?.docs.reversed.toList();

                  for (var ride in rides!) {
                    final rideData = ride.data() as Map<String, dynamic>;
                    final ridePlace = rideData['City'] + rideData['Address'];

                    if (ridePlace.contains(searchFilter.text)) {
                      final rideWidget =
                          RideListItem(ride: ride, imageNumber: imageNumber);
                      rideWidgets.add(rideWidget);
                    }
                  }

                  return Expanded(
                    child: ListView(
                      children: rideWidgets,
                    ),
                  );
                }

                return CircularProgressIndicator();
              },
            ),
          ],
        ],
      ),
    );
  }

  void saveRecentHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      prefs.setStringList('recentHistory', recentHistory);
    }
  }

  void loadRecentHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs != null) {
      recentHistory = prefs.getStringList('recentHistory') ?? [];
    }
  }

  searchBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 45,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? navBarBackgroundClr : searchBarClr,
        borderRadius: BorderRadius.circular(
          6,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.background,
                      width: 0,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.background,
                      width: 0,
                    ),
                  ),
                  hintText: "Search",
                  hintStyle: w700.copyWith(
                    fontSize: 18,
                    color: searchBarTxtClr,
                  ),
                  suffixIcon: IconButton(
                    icon: Text(
                      String.fromCharCode(Icons.close_rounded.codePoint),
                      style: TextStyle(
                        inherit: false,
                        color: blueClr,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        fontFamily: Icons.close_rounded.fontFamily,
                        package: Icons.close_rounded.fontPackage,
                      ),
                    ),
                    onPressed: () {
                      final searchText = searchFilter.text;
                      if (searchText.isNotEmpty) {
                        recentHistory.insert(0, searchText);
                        searchFilter.clear();
                        setState(() {});
                        saveRecentHistory();
                      }
                    },
                  ),
                ),
                controller: searchFilter,
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

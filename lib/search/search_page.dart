import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../themes/theme.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchFilter = TextEditingController();

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
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Container searchBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 45,
      decoration: BoxDecoration(
        color: searchBarClr,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
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
                  hintStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: searchBarTxtClr,
                  ),
                ),
                controller: searchFilter,
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),
            IconButton(
              icon: Text(
                String.fromCharCode(Icons.close_rounded.codePoint),
                style: TextStyle(
                  inherit: false,
                  color: btnBlueClr,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  fontFamily: Icons.close_rounded.fontFamily,
                  package: Icons.close_rounded.fontPackage,
                ),
              ),
              onPressed: () {
                searchFilter.clear(); // Clear the text
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}

        // Container(
        //     height: 45,
        //     width: MediaQuery.of(context).size.width - 40,
        //     decoration: BoxDecoration(
        //       color: searchBarClr,
        //       borderRadius: BorderRadius.circular(6),
        //     ),
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Text(
        //         'Search',
        //         style: TextStyle(
        //           fontFamily: 'Roboto',
        //           fontWeight: FontWeight.w700,
        //           fontSize: 18,
        //           color: searchBarTxtClr,
        //         ),
        //       ),
        //     ),
        //   ),    

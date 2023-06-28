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
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.background,
        elevation: 0,
      ),
      backgroundColor: context.theme.colorScheme.background,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 45,
            decoration: BoxDecoration(
              color: searchBarClr,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: TextFormField(
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: context.theme.colorScheme.background, width: 0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: context.theme.colorScheme.background, width: 0),
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
          ),
        ],
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../themes/theme.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              Container(
                height: 280,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/AboutUsImage.png',
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 240,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Container(
                      height: 320,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          6,
                        ),
                        color: newNotis,
                      ),
                      child: Column(
                        children: [],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      title: Text(
        'About Us',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          fontSize: 25,
          color: Colors.black,
        ),
      ),
      backgroundColor: context.theme.colorScheme.background,
      foregroundColor: btnBlueClr,
    );
  }
}

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
                      height: 450,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          6,
                        ),
                        color: newNotis,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              left: 20,
                            ),
                            child: Text(
                              'Your Ride. Your Way',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            child: Text(
                              'Our app was created with a single goal in mind: to provide for riders to discover new routes and enjoy delicious breakfasts at the same time!\n\nOur team of dedicated developers and motorcycle enthusiasts have created an app that is easy to use. With Roder, you can:',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w100,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                            ),
                            child: Text(
                              'How We Work',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          firstBullet(),
                          SizedBox(
                            height: 20,
                          ),
                          secondBullet(),
                        ],
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

  Row secondBullet() {
    return Row(
      children: [
        SizedBox(
          width: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 55,
          ),
          child: Text('●'),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Text(
            "Connect with other riders: Our app\nallows you to connect with other\nbikers who share your passion for\nbreakfast runs.",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w100,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Row firstBullet() {
    return Row(
      children: [
        SizedBox(
          width: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 35,
          ),
          child: Text('●'),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Text(
            "Plan your ride: Once you've found\na great breakfast spot. Use our app\nto plan Your ride.",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w100,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ],
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

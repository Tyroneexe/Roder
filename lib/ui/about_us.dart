import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roder/themes/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';
import '../themes/colors.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  int? randomImgNumber;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    generateRandomNumber();
  }

  void generateRandomNumber() {
    setState(() {
      // Generates a random number between 1 and 5 (inclusive)
      randomImgNumber = random.nextInt(5) + 1;
    });
  }

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
                      'assets/image$randomImgNumber.jpg',
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
                      // height: 450,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          6,
                        ),
                        color: Get.isDarkMode ? navBarBackgroundClr : newNotis,
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
                              style: w700.copyWith(
                                fontSize: 16,
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
                              style: w100.copyWith(
                                fontSize: 14,
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
                              style: w700.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          firstBullet(),
                          SizedBox(
                            height: 20,
                          ),
                          secondBullet(),
                          SizedBox(
                            height: 20,
                          ),
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

  secondBullet() {
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Text(
              "Connect with other riders: Our app allows you to connect with other bikers who share your passion for breakfast runs.",
              style: w100.copyWith(
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  firstBullet() {
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Text(
              "Plan your ride: Once you've found a great breakfast spot. Use our app to plan Your ride.",
              style: w100.copyWith(
                fontSize: 14,
              ),
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
        style: w700.copyWith(
          fontSize: 25,
        ),
      ),
      backgroundColor: context.theme.colorScheme.background,
      foregroundColor: blueClr,
      actions: [
        GestureDetector(
          onTap: () {
            _goToGitHub();
          },
          child: Icon(
            Icons.code,
            size: 28,
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  final Uri _githubUrl = Uri.parse('https://github.com/Tyroneexe/Roder');

  Future<void> _launchGitHub() async {
    if (!await launchUrl(_githubUrl)) {
      throw Exception('Could not launch $_githubUrl');
    }
  }

  _goToGitHub() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: navBarBkgClr,
          title: Text(
            "Roder's Code",
            style: bold.copyWith(
              fontSize: 20,
            ),
          ),
          content: Text(
            "Do you want to view Roder's Code. You can also conribute to the source code!",
            style: w100.copyWith(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: recentTxtClr,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Yes',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: blueClr,
                ),
              ),
              onPressed: () {
                _launchGitHub();
                Navigator.of(context).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 20,
        );
      },
    );
  }
}

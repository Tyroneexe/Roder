import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roder/themes/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import '../provider/clrProvider.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final Uri _urlInsta = Uri.parse(
      'https://www.instagram.com/roderbiker/?igshid=MzNlNGNkZWQ4Mg%3D%3D');

  int noImg = 0;
  int noClr = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlueClr,
      appBar: _appBar(),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: _themeImage(noImg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Text(
                'Contact',
                style: TextStyle(
                  fontFamily: 'Audiowide',
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                  color: _getTxtClr(noClr),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _showEmailPopup();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          color: Colors.white,
                          size: 40,
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(8.0),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          _getMainClr(Provider.of<ColorProvider>(context)
                              .selectedColor)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(
                          vertical: 16.0,
                        ),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      fixedSize: MaterialStateProperty.all<Size>(Size(130, 80)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                ),
                SizedBox(
                  width: 40,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _showInstaPopup();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.instagram,
                          color: Colors.white,
                          size: 40,
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(8.0),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          _getMainClr(Provider.of<ColorProvider>(context)
                              .selectedColor)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(
                          vertical: 16.0,
                        ),
                      ),
                      // Customize the button's shape (e.g., rounded corners)
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      fixedSize: MaterialStateProperty.all<Size>(Size(130, 80)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _launchInsta() async {
    if (!await launchUrl(_urlInsta)) {
      throw Exception('Could not launch $_urlInsta');
    }
  }

  _showEmailPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Contact Email',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Colors.white, // Default color for the text
              ),
              children: [
                TextSpan(
                  text: 'Message the Developer of Roder with this Email:\n\n',
                ),
                TextSpan(
                  text: 'roderteam@gmail.com',
                  style: TextStyle(
                    fontSize: 18,
                    color: _getMainClr(
                        Provider.of<ColorProvider>(context).selectedColor),
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      //copy the email to the clipboard of the user
                      final email = 'roderteam@gmail.com';
                      Clipboard.setData(ClipboardData(text: email));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Email copied to Clipboard')),
                      );
                    },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: _getMainClr(
                      Provider.of<ColorProvider>(context).selectedColor),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                //copy the email to the clipboard of the user
                final email = 'roderteam@gmail.com';
                Clipboard.setData(ClipboardData(text: email));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Email copied to Clipboard')),
                );
                Navigator.pop(context);
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

  _showInstaPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Contact Instagram',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Text(
            'Visit the Roder Instagram Page',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text(
                'Go to Instagram',
                style: TextStyle(
                  color: _getMainClr(
                      Provider.of<ColorProvider>(context).selectedColor),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                _launchInsta();
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

  _themeImage(int no) {
    if (Provider.of<ColorProvider>(context).selectedColor == 0) {
      no = 0;
    } else if (Provider.of<ColorProvider>(context).selectedColor == 1) {
      no = 1;
    } else if (Provider.of<ColorProvider>(context).selectedColor == 2) {
      no = 2;
    } else {
      no = 0;
    }

    switch (no) {
      case 0:
        return AssetImage('assets/RoderContactPage.jpg');
      case 1:
        return AssetImage('assets/RoderContactPage.jpg');
      case 2:
        return AssetImage('assets/RoderThemeRed.jpg');
      default:
        return AssetImage('assets/RoderContactPage.jpg');
    }
  }

  _getTxtClr(int no) {
    if (Provider.of<ColorProvider>(context).selectedColor == 0) {
      no = 0;
    } else if (Provider.of<ColorProvider>(context).selectedColor == 1) {
      no = 1;
    } else if (Provider.of<ColorProvider>(context).selectedColor == 2) {
      no = 2;
    } else {
      no = 0;
    }

    switch (no) {
      case 0:
        return Colors.black;
      case 1:
        return Colors.black;
      case 2:
        return Colors.white;
      default:
        return Colors.black;
    }
  }

  _getMainClr(int no) {
    switch (no) {
      case 0:
        return blueClr;
      case 1:
        return oRange;
      case 2:
        return themeRed;
      default:
        return blueClr;
    }
  }
}

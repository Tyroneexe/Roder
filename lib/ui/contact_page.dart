import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roder/themes/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final Uri _urlInsta = Uri.parse(
      'https://www.instagram.com/roderbiker/?igshid=MzNlNGNkZWQ4Mg%3D%3D');

  final Uri _urlEmail = Uri.parse('https://mail.google.com/mail/u/0/#inbox');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlueClr,
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Set the background color to transparent
        elevation: 0, // Remove the app bar shadow
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/RoderContactPage.jpg'),
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
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Spacer(),
            Row(
              children: [
                SizedBox(
                  width: 40,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showEmailPopup();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email_outlined,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Email',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      // Customize the button's background color
                      backgroundColor:
                          MaterialStateProperty.all<Color>(blueClr),
                      // Customize the button's foreground (text) color
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      // Customize the button's padding
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
                      fixedSize: MaterialStateProperty.all<Size>(Size(140, 90)),
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
                      _launchInsta();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.instagram),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Instagram',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      // Customize the button's background color
                      backgroundColor: MaterialStateProperty.all<Color>(purple),
                      // Customize the button's foreground (text) color
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      // Customize the button's padding
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
                      fixedSize: MaterialStateProperty.all<Size>(Size(140, 90)),
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

  Future<void> _launchInsta() async {
    if (!await launchUrl(_urlInsta)) {
      throw Exception('Could not launch $_urlInsta');
    }
  }

  Future<void> _launchEmail() async {
    if (!await launchUrl(_urlEmail)) {
      throw Exception('Could not launch $_urlEmail');
    }
  }

  showEmailPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Contact via Email',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Text(
            'Message the Developer of Roder with this Email\ntvzbothma@gmail.com',
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
                'Go to Email',
                style: TextStyle(
                  color: lightBlueClr,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                _launchEmail();
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

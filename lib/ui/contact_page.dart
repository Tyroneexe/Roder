import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roder/themes/theme.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
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
                      //popup for email
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
                      //go it insta
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
}

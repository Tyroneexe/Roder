import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roder/navbar/navbar.dart';
import 'package:roder/ui/theme.dart';

import 'google_sign_in.dart';

class LogIn extends StatelessWidget {
  LogIn({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return NavBar();
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Something has gone Wrong'),
              );
            } else {
              return logInPage(context);
            }
          },
        ),
      );

  final referenceDatabase = FirebaseDatabase.instance;

  Widget logInPage(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Roderr.jpg'),
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
                'Roder',
                style: TextStyle(
                  fontFamily: 'Audiowide',
                  fontWeight: FontWeight.bold,
                  fontSize: 70,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  await provider.googleLogIn();
                  assignUserID();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.google,
                      color: darkbl50,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Sign in with Google',
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
                      MaterialStateProperty.all<Color>(lightBlueClr),
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
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  fixedSize: MaterialStateProperty.all<Size>(Size(300, 60)),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  void assignUserID() async {
    final user = FirebaseAuth.instance.currentUser;
    final ref = referenceDatabase.ref();

    if (user != null) {
      ref.child('Rides').child(user.uid).set({
        'name': user.displayName!,
        'email': user.email!,
      }).then((_) {
        print('User added to the database with ID: ${user.uid}');
      }).catchError((error) {
        print('Failed to add user: $error');
      });
    } else {
      print('The user is null');
    }
  }
}

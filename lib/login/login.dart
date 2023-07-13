// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roder/navbar/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../homepage/home_page.dart';
import '../ui/notification_page.dart';
import 'google_sign_in.dart';

class LogIn extends StatefulWidget {
  LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
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

  Widget logInPage(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/LandingPageRoder.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Explore your\nfavorite journey',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 37,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Life is all about journey.\nFind yours.',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      // fontWeight: FontWeight.,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Center(
              child: logInBtn(context),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  logInBtn(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          notificationTime = DateTime.now();
          welcomeViewed = false;
        });

        final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
        await provider.googleLogIn();
        //
        saveUserInTheDatabase();

        _saveWelcomeViewedBool();
        _saveNotificationTime();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            child: Image.asset(
              'assets/GoogleLogo.png',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Login with Google',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF3F66C1),
            ),
          ),
        ],
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        fixedSize: MaterialStateProperty.all<Size>(Size(330, 50)),
      ),
    );
  }

  _saveWelcomeViewedBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('welcomeViewed', welcomeViewed);
  }

  _saveNotificationTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('notificationTime', notificationTime.toString());
  }

  //create a users in the firestore database
  Future saveUserInTheDatabase() async {
    if (currentUser != null) {
      // Assuming you have the necessary user information
      String username = currentUser.displayName!;
      String email = currentUser.email!;

      await createUser(username, email);
    } else {
      print('Error');
    }
  }

  Future<void> createUser(String username, String email) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Create a new user document with the provided user ID
      await users.doc(currentUser.uid).set({
        'name': username,
        'email': email,
        'foto': currentUser.photoURL,
        'bike': '',
        'contact': '',
        'country': '',
        'city': '',
        'rides': [],
        //groups (array)
      });

      print('User created successfully!');
    } catch (e) {
      print('Error creating user: $e');
    }
  }
}

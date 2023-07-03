import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roder/navbar/navbar.dart';

import '../ui/notification_page.dart';
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

  ElevatedButton logInBtn(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        welcomeViewed = false;
        final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
        await provider.googleLogIn();
        assignUserID();
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

  void assignUserID() async {
    final user = FirebaseAuth.instance.currentUser;
    final referenceDatabase = FirebaseDatabase.instance;
    final ref = referenceDatabase.ref();

    if (user != null) {
      ref.child('Users').child(user.uid).set({
        'name': user.displayName!,
        'email': user.email!,
        'contact': '',
        'location': '',
        'bike': ''
      }).asStream();
    } else {
      print('Error');
    }
  }
}

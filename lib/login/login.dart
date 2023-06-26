import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roder/navbar/navbar.dart';

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
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
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
                      fontFamily: 'OpenSans',
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
              child: ElevatedButton(
                onPressed: () async {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  await provider.googleLogIn();
                  // assignUserID();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
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
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF3F66C1),
                      ),
                    ),
                  ],
                ),
                style: ButtonStyle(
                  // Customize the button's background color
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
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
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                  fixedSize: MaterialStateProperty.all<Size>(Size(330, 50)),
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

  // void assignUserID() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   final ref = referenceDatabase.ref();

  //   if (user != null) {
  //     ref.child('Rides').child(user.uid).set({
  //       'name': user.displayName!,
  //       'email': user.email!,
  //     }).then((_) {
  //       print('User added to the database with ID: ${user.uid}');
  //     }).catchError((error) {
  //       print('Failed to add user: $error');
  //     });
  //   } else {
  //     print('The user is null');
  //   }
  // }
}

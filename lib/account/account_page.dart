// ignore_for_file: unrelated_type_equality_checks, non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:roder/themes/theme.dart';
import '../homepage/home_page.dart';
import '../themes/colors.dart';
import '../widgets/custom_snackbar.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

String name = '';
String nu = '';
String currentCountryDB = '';
String currentCityDB = '';
String bike = '';

class _AccountPageState extends State<AccountPage> {
  //
  String imageURL = "";
  String selectedCountryFlag = '';
  String selectedCountry = '';
  String userPhoneNumber = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController nuController = TextEditingController();
  TextEditingController bikeController = TextEditingController();
  //

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    String userPhoneNumber = selectedCountry + nuController.text;
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    imageURL == ''
                        ? FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(currentUser.uid)
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(currentUser.photoURL!),
                                  radius: 60,
                                );
                              }
                              if (snapshot.hasData) {
                                final user = snapshot.data!.data()
                                    as Map<String, dynamic>;
                                return CircleAvatar(
                                  backgroundImage: NetworkImage(user['foto']),
                                  radius: 60,
                                );
                              } else {
                                return CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    currentUser.photoURL!,
                                  ),
                                  radius: 60,
                                );
                              }
                            })
                        : Image.network(imageURL),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: searchBarClr,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: blueClr,
                        size: 24,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'User Name',
                      style: actPageTxt,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                userNameForm(),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Contact Number',
                      style: actPageTxt,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                numberForm(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Email',
                      style: actPageTxt,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                emailForm(context),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Location',
                      style: actPageTxt,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                locationForm(context),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Your Bike',
                      style: actPageTxt,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                bikeForm(context),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            blueClr,
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                6,
                              ),
                              side: BorderSide(
                                color: blueClr,
                                width: 2,
                              ),
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all<Size>(
                            Size(
                              (MediaQuery.of(context).size.width / 2) - 25,
                              38,
                            ),
                          ),
                        ),
                        child: Text('Cancel'),
                      ),
                    ),
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUser.uid)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          final userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          final userFoto = userData['foto'] as String;
                          final userName = userData['name'] as String;
                          final userNum = userData['contact'] as String;
                          final userBike = userData['bike'] as String;

                          return Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: CustomSnackbar(
                                      title: 'Updated User',
                                      subTitle: 'Updated $userName',
                                      color: blueClr,
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                  ),
                                );
                                String newName = nameController.text.isEmpty
                                    ? userName
                                    : nameController.text;
                                String contactNumber = nuController.text.isEmpty
                                    ? userNum
                                    : '+' + userPhoneNumber;
                                String email = currentUser.email!;
                                String country = currentCountryDB;
                                String city = currentCityDB;
                                String bike = bikeController.text.isEmpty
                                    ? (userBike.isEmpty
                                        ? 'Rather Not Say'
                                        : userBike)
                                    : bikeController.text;
                                String foto =
                                    imageURL == '' ? userFoto : imageURL;

                                updateUserInformation(
                                  newName,
                                  contactNumber,
                                  email,
                                  country,
                                  city,
                                  bike,
                                  foto,
                                );
                              },
                              style: ButtonStyle(
                                textStyle: MaterialStateProperty.all<TextStyle>(
                                  TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(blueClr),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all<Size>(
                                  Size(
                                    (MediaQuery.of(context).size.width / 2) -
                                        25,
                                    38,
                                  ),
                                ),
                              ),
                              child: Text('Save'),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                textStyle: MaterialStateProperty.all<TextStyle>(
                                  TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(blueClr),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all<Size>(
                                  Size(
                                    (MediaQuery.of(context).size.width / 2) -
                                        25,
                                    38,
                                  ),
                                ),
                              ),
                              child: Text('Save'),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bikeForm(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 40,
            child: TextFormField(
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w100,
                  fontSize: 14,
                  color: Colors.black),
              controller: bikeController,
              decoration: InputDecoration(
                hintText: "Rather Not Say",
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w100,
                  fontSize: 14,
                  color: Colors.black,
                ),
                contentPadding: EdgeInsets.only(
                  left: 20,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: blueClr,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(
                    6,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: blueClr,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(
                    6,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: blueClr,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(
                    6,
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final userBike = userData['bike'] as String;

          return Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 40,
            child: TextFormField(
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w100,
                  fontSize: 14,
                  color: Colors.black),
              controller: bikeController,
              decoration: InputDecoration(
                hintText: userBike == '' ? 'Rather Not Say' : userBike,
                hintStyle: userBike == ''
                    ? TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w100,
                        fontSize: 14,
                        color: Colors.grey,
                      )
                    : TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w100,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                contentPadding: EdgeInsets.only(
                  left: 20,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: blueClr,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(
                    6,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: blueClr,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(
                    6,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: blueClr,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(
                    6,
                  ),
                ),
              ),
            ),
          );
        } else {
          return Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 40,
            child: TextFormField(
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w100,
                  fontSize: 14,
                  color: Colors.black),
              controller: bikeController,
              decoration: InputDecoration(
                hintText: 'Rather Not Say',
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w100,
                  fontSize: 14,
                  color: Colors.black,
                ),
                contentPadding: EdgeInsets.only(
                  left: 20,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: blueClr,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(
                    6,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: blueClr,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(
                    6,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: blueClr,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(
                    6,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  locationForm(BuildContext context) {
    currentCountryDB = _currentCountry;
    currentCityDB = _currentCity;
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 40,
      child: TextFormField(
        readOnly: true,
        style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w100,
            fontSize: 14,
            color: Colors.black),
        decoration: InputDecoration(
          hintText: _currentCountry + ', ' + _currentCity,
          hintStyle: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w100,
            fontSize: 14,
            color: Colors.black,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: blueClr,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(
              6,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: blueClr,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(
              6,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: blueClr,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(
              6,
            ),
          ),
        ),
      ),
    );
  }

  String _currentCity = '';
  String _currentCountry = '';

  Future<void> _getCurrentLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final Placemark placemark = placemarks.first;
    final String city = placemark.locality ?? '';
    final String country = placemark.country ?? '';

    setState(() {
      _currentCity = city;
      _currentCountry = country;
    });
  }

  Container emailForm(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 40,
      child: TextFormField(
        readOnly: true,
        style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w100,
            fontSize: 14,
            color: Colors.black),
        decoration: InputDecoration(
          hintText: currentUser.email,
          hintStyle: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w100,
            fontSize: 14,
            color: Colors.black,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: blueClr,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(
              6,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: blueClr,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(
              6,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: blueClr,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(
              6,
            ),
          ),
        ),
      ),
    );
  }

  String sel = '';

  numberForm(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 60,
              child: IntlPhoneField(
                flagsButtonPadding: EdgeInsets.only(
                  left: 20,
                ),
                dropdownIcon: Icon(
                  Icons.arrow_drop_down,
                  color: blueClr,
                ),
                disableLengthCheck: false,
                dropdownIconPosition: IconPosition.trailing,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w100,
                  fontSize: 14,
                  color: Colors.black,
                ),
                controller: nuController,
                decoration: InputDecoration(
                  hintText: 'xxx - xxx - xxx',
                  hintStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w100,
                      fontSize: 14,
                      color: Colors.grey),
                  contentPadding: EdgeInsets.only(
                    left: 20,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: blueClr,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(
                      6,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: blueClr,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(
                      6,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: blueClr,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(
                      6,
                    ),
                  ),
                ),
                onChanged: (phone) {
                  setState(() {
                    userPhoneNumber = selectedCountry + nuController.text;
                  });
                },
                onCountryChanged: (phone) {
                  setState(() {
                    selectedCountry = phone.dialCode;
                    // selectedCountryFlag = phone.code;
                  });
                },
              ),
            );
          } else if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final userNum = userData['contact'] as String;

            return Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 60,
              child: IntlPhoneField(
                flagsButtonPadding: EdgeInsets.only(
                  left: 20,
                ),
                dropdownIcon: Icon(
                  Icons.arrow_drop_down,
                  color: blueClr,
                ),
                disableLengthCheck: false,
                dropdownIconPosition: IconPosition.trailing,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w100,
                  fontSize: 14,
                  color: Colors.black,
                ),
                controller: nuController,
                decoration: InputDecoration(
                  hintText: userNum == '' ? 'xxx-xxx-xxx' : userNum,
                  hintStyle: userNum == ''
                      ? TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w100,
                          fontSize: 14,
                          color: Colors.grey)
                      : TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w100,
                          fontSize: 14,
                          color: Colors.black),
                  contentPadding: EdgeInsets.only(
                    left: 20,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: blueClr,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(
                      6,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: blueClr,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(
                      6,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: blueClr,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(
                      6,
                    ),
                  ),
                ),
                onChanged: (phone) {
                  setState(() {
                    userPhoneNumber = selectedCountry + nuController.text;
                  });
                },
                onCountryChanged: (phone) {
                  setState(() {
                    selectedCountry = phone.dialCode;
                    // selectedCountryFlag = phone.code;
                  });
                },
              ),
            );
          } else {
            return Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 60,
              child: IntlPhoneField(
                flagsButtonPadding: EdgeInsets.only(
                  left: 20,
                ),
                dropdownIcon: Icon(
                  Icons.arrow_drop_down,
                  color: blueClr,
                ),
                disableLengthCheck: false,
                dropdownIconPosition: IconPosition.trailing,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w100,
                  fontSize: 14,
                  color: Colors.black,
                ),
                controller: nuController,
                decoration: InputDecoration(
                  hintText: 'xxx - xxx - xxx',
                  hintStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w100,
                      fontSize: 14,
                      color: Colors.grey),
                  contentPadding: EdgeInsets.only(
                    left: 20,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: blueClr,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(
                      6,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: blueClr,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(
                      6,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: blueClr,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(
                      6,
                    ),
                  ),
                ),
                // initialCountryCode: selectedCountryFlag,
                onChanged: (phone) {
                  setState(() {
                    userPhoneNumber = selectedCountry + nuController.text;
                  });
                },
                onCountryChanged: (phone) {
                  setState(() {
                    selectedCountry = phone.dialCode;
                    // selectedCountryFlag = phone.code;
                  });
                },
              ),
            );
          }
        });
  }

  Widget userNameForm() {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 40,
            child: TextFormField(
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w100,
                fontSize: 14,
                color: Colors.black,
              ),
              controller: nameController,
              decoration: InputDecoration(
                hintText: currentUser.displayName,
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w100,
                  fontSize: 14,
                  color: Colors.black,
                ),
                contentPadding: EdgeInsets.only(
                  left: 20,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: blueClr,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: blueClr,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: blueClr,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final userName = userData['name'] as String;

          return Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 40,
            child: TextFormField(
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w100,
                fontSize: 14,
                color: Colors.black,
              ),
              controller: nameController,
              decoration: InputDecoration(
                hintText: userName,
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w100,
                  fontSize: 14,
                  color: Colors.black,
                ),
                contentPadding: EdgeInsets.only(
                  left: 20,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: blueClr,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: blueClr,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: blueClr,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          );
        } else {
          return Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 40,
            child: TextFormField(
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w100,
                fontSize: 14,
                color: Colors.black,
              ),
              controller: nameController,
              decoration: InputDecoration(
                hintText: currentUser.displayName,
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w100,
                  fontSize: 14,
                  color: Colors.black,
                ),
                contentPadding: EdgeInsets.only(
                  left: 20,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: blueClr,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: blueClr,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: blueClr,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      foregroundColor: blueClr,
      actions: [
        IconButton(
          icon: Icon(
            Icons.delete_forever_rounded,
            color: rred,
          ),
          onPressed: () {
            _deleteAccountAlert();
          },
        ),
      ],
    );
  }

  _deleteAccountAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: navBarBkgClr,
          title: Text(
            'Delete Account',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          content: Text(
            'Are you sure you want to permanently delete the existing account?',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w100,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
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
                  color: rred,
                ),
              ),
              onPressed: () async {
                try {
                  User? user = FirebaseAuth.instance.currentUser;
                  // Prompt the user to reauthenticate with Google
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  GoogleSignInAccount? googleUser = await googleSignIn.signIn();
                  if (googleUser != null) {
                    GoogleSignInAuthentication googleAuth =
                        await googleUser.authentication;
                    AuthCredential credential = GoogleAuthProvider.credential(
                      accessToken: googleAuth.accessToken,
                      idToken: googleAuth.idToken,
                    );
                    // Reauthenticate the user
                    await user!.reauthenticateWithCredential(credential);
                    // User has been successfully reauthenticated
                    // Proceed with deleting the account
                    await user.delete();
                    // Account deleted successfully
                    Navigator.of(context).pop();
                  } else {
                    _errorMsg();
                  }
                  // Account deleted successfully
                  Navigator.of(context).pop();
                } catch (e) {
                  _errorMsg();
                }
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

  _errorMsg() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'An Error Has Occurred',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Text(
            "Could not delete account.",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Try Again',
                style: TextStyle(
                  color: rred,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
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

  void updateUserInformation(String userName, String contactNumber,
      String email, String country, String city, String bike, String foto) {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    usersCollection.doc(currentUser.uid).update({
      'name': userName,
      'contact': contactNumber,
      'email': email,
      'country': country,
      'city': city,
      'bike': bike,
      'foto': foto,
    }).then((_) {
      print('User information updated successfully!');
    }).catchError((error) {
      print('Failed to update user information: $error');
    });
  }

  pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    Reference storageRef =
        FirebaseStorage.instance.ref().child('profilepic.jpg');

    if (image != null) {
      await storageRef.putFile(File(image.path));
      storageRef.getDownloadURL().then((value) {
        print(value);
        setState(() {
          imageURL = value;
        });
      });
    } else {
      return;
    }
  }
}

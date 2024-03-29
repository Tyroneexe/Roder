// ignore_for_file: unused_field

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:roder/themes/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../homepage/home_page.dart';
import '../themes/colors.dart';
import '../ui/notification_page.dart';
import '../widgets/custom_snackbar.dart';
import 'location_provider.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  //Database
  //Texts
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  String selectedRide = 'Solo';

  //Date and Time
  String _selectedDate = DateFormat("d MMMM yyyy").format(DateTime.now());
  String _endTime = "9:00 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Ride Name',
                    style: w700.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 40,
                  child: TextFormField(
                    style: w100.copyWith(
                      fontSize: 14,
                    ),
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter Details',
                      hintStyle: w100.copyWith(
                        fontSize: 14,
                        color: Colors.grey,
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
                ),
              ),
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
                    'Meetup Location',
                    style: w700.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 40,
                  child: TextFormField(
                    onTap: () {
                      _locationPopup();
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: locationController.text == ''
                          ? 'Choose Meetup Location'
                          : locationController.text,
                      hintStyle: locationController.text == ''
                          ? w100.copyWith(
                              fontSize: 14,
                              color: Colors.grey,
                            )
                          : w100.copyWith(
                              fontSize: 14,
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
                ),
              ),
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
                    'Date',
                    style: w700.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 40,
                  child: TextFormField(
                    readOnly: true,
                    onTap: () {
                      _getDateFromUser();
                    },
                    decoration: InputDecoration(
                      hintText: _selectedDate,
                      hintStyle: w100.copyWith(
                        fontSize: 14,
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
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: Container(
                      width: (MediaQuery.of(context).size.width / 2) - 42,
                      height: 40,
                      child: TextFormField(
                        readOnly: true,
                        onTap: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        decoration: InputDecoration(
                          hintText: _startTime,
                          hintStyle: w100.copyWith(
                            fontSize: 14,
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 15,
                    ),
                    child: Text(
                      'to',
                      style: w700.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                    ),
                    child: Container(
                      width: (MediaQuery.of(context).size.width / 2) - 42,
                      height: 40,
                      child: TextFormField(
                        readOnly: true,
                        onTap: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        decoration: InputDecoration(
                          hintText: _endTime,
                          hintStyle: w100.copyWith(
                            fontSize: 14,
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
                    ),
                  ),
                ],
              ),
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
                    'Riders',
                    style: w700.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color:
                          blueClr, // Replace Colors.blue with your desired border color
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: DropdownButton<String>(
                      underline: Container(),
                      isExpanded: true,
                      style: w100.copyWith(
                        fontSize: 16,
                      ),
                      icon: Icon(
                        Icons.arrow_drop_down_rounded,
                        color: blueClr,
                      ),
                      hint: Text(
                        'Solo',
                        style: w100.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      value: selectedRide,
                      onChanged: (String? value) {
                        setState(() {
                          selectedRide = value!;
                        });
                      },
                      items: [
                        DropdownMenuItem<String>(
                          value: 'Solo',
                          child: Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(
                                  width:
                                      8), // Adjust the spacing between the icon and text as needed
                              Text('Solo'),
                            ],
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Invite',
                          child: Row(
                            children: [
                              Icon(Icons.mail),
                              SizedBox(width: 8),
                              Text('Invite'),
                            ],
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Anyone',
                          child: Row(
                            children: [
                              Icon(Icons.public),
                              SizedBox(width: 8),
                              Text('Anyone'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (selectedRide == 'Invite') ...[
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
                      'Memebers',
                      style: w700.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                //search bar for searching users
                // _getUsers(),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<Widget> userWidgets = [];
                    if (snapshot.hasData) {
                      final users = snapshot.data?.docs.reversed.toList();
                      for (var user in users!) {
                        final userWidget = userListItem(user);
                        userWidgets.add(userWidget);
                      }
                    } else {
                      return CircularProgressIndicator(
                        color: blueClr,
                      );
                    }
                    return Expanded(
                      child: ListView(children: userWidgets),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
              ] else ...[
                Spacer(),
              ],
              //if inviter show users
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      if (_validateDate() == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: CustomSnackbar(
                              title: 'Created Ride',
                              subTitle:
                                  'You have created ${titleController.text}',
                              color: rred,
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                        );
                        createRide();
                        titleController.clear();
                        _scheduleNotification();
                        setState(() {
                          createdFirstRide = true;
                        });
                        _saveCreatedFirstRide();
                        Navigator.of(context).pop();
                      }
                    },
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        w700.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        blueClr,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(
                          MediaQuery.of(context).size.width / 2,
                          38,
                        ),
                      ),
                    ),
                    child: Text('Create Ride'),
                  ),
                ],
              ),
              // SizedBox(
              //   height: 10,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // save the ride created bool
  _saveCreatedFirstRide() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('createdFirstRide', createdFirstRide);
  }

  userListItem(QueryDocumentSnapshot<Object?> user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
          child: CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
              user['foto'],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                user['name'],
                style: w700.copyWith(
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              user['bike'],
              style: w100.copyWith(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  final ridesCollection = FirebaseFirestore.instance.collection('rides');
  final usersCollection = FirebaseFirestore.instance.collection('users');

  void createRide() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    // Add a ride document to the "rides" collection with an auto-generated ID
    final rideDoc = await ridesCollection.add({
      'Name': titleController.text,
      'Date': _selectedDate,
      'Start Time': _startTime,
      'End Time': _endTime,
      // 'Person': currentUser.displayName!,
      // 'Joined': 1,
      'Riders': selectedRide,
      'Country': locationProvider.countryController.text,
      'City': locationProvider.cityController.text,
      'Address': locationProvider.addressController.text,
      'User': currentUser.photoURL,
    });

    // Reference the user document
    final userDoc = usersCollection.doc(currentUser.uid);

    // Add the ride ID to the "rides" subcollection within the user document
    userDoc.update({
      'rides': FieldValue.arrayUnion([rideDoc.id]),
    });

    print('Ride added with ID: ${rideDoc.id}');
  }

  // _selectedDate is for when the ride is happening (completly seperate from the notificaitons)
  // _selectedDateTime is the raw date for the notification
  // notificationDateTime is the day before the ride for the notification (the actual notifiaction)
  // scheduleDateTime is just there for null checking, it is pretty much unneccasssary

  DateTime _selectedDateTime = DateTime.now();

  _scheduleNotification() async {
    DateTime scheduleDateTime = _selectedDateTime;
    DateTime notificationDateTime =
        scheduleDateTime.subtract(Duration(days: 1));

    if (scheduleDateTime.day == DateTime.now().day) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: -1,
          channelKey: 'channelKey',
          title: 'There is a Ride Today!',
          body: "Fill up your bike and be ready",
        ),
        actionButtons: [
          NotificationActionButton(
              key: 'ACTION_BUTTON_OPEN', label: 'Open', autoDismissible: true)
        ],
      );
    } else if (scheduleDateTime.day == DateTime.now().day + 1) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: -1,
          channelKey: 'channelKey',
          title: 'There is a Ride Tomorrow!',
          body: "Fill up your bike and be ready",
        ),
        actionButtons: [
          NotificationActionButton(
              key: 'ACTION_BUTTON_OPEN', label: 'Open', autoDismissible: true)
        ],
      );
    } else {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: -1,
          channelKey: 'channelKey',
          title: 'There is a Ride Tomorrow!',
          body: "Fill up your bike and be ready",
        ),
        schedule: NotificationCalendar.fromDate(date: notificationDateTime),
        actionButtons: [
          NotificationActionButton(
              key: 'ACTION_BUTTON_OPEN', label: 'Open', autoDismissible: true)
        ],
      );
    }
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: _getPickerTheme(),
          child: child!,
        );
      },
    );

    if (pickerDate != null) {
      setState(() {
        _selectedDate = DateFormat("d MMMM yyyy").format(pickerDate);
      });
      setState(() {
        _selectedDateTime = DateTime(
          pickerDate.year,
          pickerDate.month,
          pickerDate.day,
        );
      });
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    if (pickedTime == null) {
      // User pressed cancel, do nothing
    } else {
      String formatedTime = pickedTime.format(context);
      String amPmIndicator = pickedTime.hour < 12 ? 'AM' : 'PM';
      formatedTime = formatedTime + ' ' + amPmIndicator;
      if (isStartTime == true) {
        setState(() {
          _startTime = formatedTime;
        });
      } else if (isStartTime == false) {
        setState(() {
          _endTime = formatedTime;
        });
      }
    }
  }

  Future<TimeOfDay?> _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
      useRootNavigator: false,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: _getPickerTheme(),
          child: child!,
        );
      },
    );
  }

  _validateDate() {
    if (titleController.text.isNotEmpty && locationController.text.isNotEmpty) {
      return true;
    } else if (titleController.text.isEmpty ||
        locationController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required!",
          snackPosition: SnackPosition.TOP,
          borderWidth: 2,
          borderColor: Colors.red[600],
          backgroundColor: Colors.white,
          colorText: Colors.red[600],
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.red[600],
          ));
      return false;
    }
    return false;
  }

  _appBar() {
    return AppBar(
      iconTheme: IconThemeData(
        color: blueClr,
      ),
      elevation: 0,
      title: Text(
        'Create A Ride',
        style: w700.copyWith(
          fontSize: 25,
        ),
      ),
      backgroundColor: context.theme.colorScheme.background,
    );
  }

  ThemeData _getPickerTheme() {
    // Retrieve the current theme

    // Create a copy of the current theme
    ThemeData pickerTheme = Theme.of(context).copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: blueClr, // Customize the primary color
          ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return blueClr;
              }
              return blueClr;
            },
          ),
        ),
      ),
    );

    return pickerTheme;
  }

  void _locationPopup() {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Meetup Location',
            style: w700.copyWith(
              fontSize: 25,
            ),
          ),
          content: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Country',
                  style: w700.copyWith(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 40,
                  child: TextFormField(
                    style: w100.copyWith(
                      fontSize: 14,
                    ),
                    controller: locationProvider.countryController,
                    decoration: InputDecoration(
                      hintText: 'Country',
                      hintStyle: w100.copyWith(
                        fontSize: 14,
                        color: Colors.grey,
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
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'City',
                  style: w700.copyWith(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 40,
                  child: TextFormField(
                    style: w100.copyWith(
                      fontSize: 14,
                    ),
                    controller: locationProvider.cityController,
                    decoration: InputDecoration(
                      hintText: 'City',
                      hintStyle: w100.copyWith(
                        fontSize: 14,
                        color: Colors.grey,
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
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Address',
                  style: w700.copyWith(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 40,
                  child: TextFormField(
                    style: w100.copyWith(
                      fontSize: 14,
                    ),
                    controller: locationProvider.addressController,
                    decoration: InputDecoration(
                      hintText: 'Street',
                      hintStyle: w100.copyWith(
                        fontSize: 14,
                        color: Colors.grey,
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
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: blueClr,
                ),
              ),
              onPressed: () {
                // setState(() {
                //   locationController.text =
                //       locationProvider.countryController.text +
                //           ', ' +
                //           locationProvider.cityController.text +
                //           ', ' +
                //           locationProvider.addressController.text;
                // });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

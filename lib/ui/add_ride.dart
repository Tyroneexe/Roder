// ignore_for_file: unused_field

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:roder/themes/theme.dart';

import 'notification_page.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  //Database
  final referenceDatabase = FirebaseDatabase.instance;
  final user = FirebaseAuth.instance.currentUser!;

  //Texts
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  String? selectedRide;

  //Date and Time
  String _selectedDate = DateFormat("d MMMM yyyy").format(DateTime.now());
  String _endTime = "9:00 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();

  //Color
  int _selectedColor = 0;
  Color _mainColor = lightBlueClr;
  bool isColorVisible = false;

  @override
  Widget build(BuildContext context) {
    final ref = referenceDatabase.ref();

    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    'Ride Name',
                    style: actPageTxt,
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
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w100,
                        fontSize: 14,
                        color: Colors.black),
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter Details',
                      hintStyle: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w100,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.only(
                        left: 20,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: btnBlueClr,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(
                          6,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: btnBlueClr,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(
                          6,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: btnBlueClr,
                          width: 1.5,
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
                    style: actPageTxt,
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
                    controller: locationController,
                    // readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Choose Meetup Location',
                      hintStyle: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w100,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.only(
                        left: 20,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: btnBlueClr,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(
                          6,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: btnBlueClr,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(
                          6,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: btnBlueClr,
                          width: 1.5,
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
                    style: actPageTxt,
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
                          color: btnBlueClr,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(
                          6,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: btnBlueClr,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(
                          6,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: btnBlueClr,
                          width: 1.5,
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
                              color: btnBlueClr,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(
                              6,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: btnBlueClr,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(
                              6,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: btnBlueClr,
                              width: 1.5,
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
                      style: roRegular14,
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
                              color: btnBlueClr,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(
                              6,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: btnBlueClr,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(
                              6,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: btnBlueClr,
                              width: 1.5,
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
                    style: actPageTxt,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
//////////////////////////////////////////////////////////
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
                          btnBlueClr, // Replace Colors.blue with your desired border color
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: DropdownButton<String>(
                      underline: Container(),
                      isExpanded: true,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      icon: Icon(
                        Icons.arrow_drop_down_rounded,
                        color: btnBlueClr,
                      ),
                      hint: Text(
                        'Solo',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w100,
                          fontSize: 16,
                          color: Colors.black,
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
              Spacer(),
              //if inviter show users
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      if (_validateDate() == true) {
                        ref.child('Rides').push().set({
                          'Name': titleController.text,
                          'Date': _selectedDate,
                          'Start Time': _startTime,
                          'End Time': _endTime,
                          'Color': _selectedColor,
                          'Person': user.displayName!,
                          'GPhoto': user.photoURL!,
                          'Joined': 0,
                          'Meetup': locationController.text,
                          'Riders': selectedRide,
                          // 'Country' : ,
                          // 'City' : ,
                        }).asStream();
                        titleController.clear();
                        selectedRide = '';
                        _addedRideBar();
                        _scheduleNotification();
                      }
                      setState(() {
                        createdFirstRide = true;
                      });
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
                        Colors.white,
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        btnBlueClr,
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
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
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
          channelKey: 'channelName',
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

  _addedRideBar() {
    Get.snackbar("CREATED RIDE", "Ride has been created",
        snackPosition: SnackPosition.TOP,
        borderWidth: 2,
        borderColor: btnBlueClr,
        backgroundColor: Colors.white,
        colorText: btnBlueClr,
        icon: const Icon(Icons.add_location_outlined));
  }

  _appBar() {
    return AppBar(
      iconTheme: IconThemeData(
        color: btnBlueClr,
      ),
      elevation: 0,
      title: Text(
        'Create A Ride',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          fontSize: 25,
          color: Colors.black,
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
            primary: btnBlueClr, // Customize the primary color
          ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return btnBlueClr; // Customize the button text color when pressed
              }
              return btnBlueClr; // Customize the default button text color
            },
          ),
        ),
      ),
    );

    return pickerTheme;
  }
}

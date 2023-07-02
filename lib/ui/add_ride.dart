// ignore_for_file: unused_field

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:roder/googlemaps/maps.dart';
import 'package:roder/themes/theme.dart';
import '../googlemaps/maps_provider.dart';

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
  final TextEditingController _titleController = TextEditingController();

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
    ControllerProvider controllerProvider =
        Provider.of<ControllerProvider>(context);
    final ref = referenceDatabase.ref();

    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appbar(),
      body: SingleChildScrollView(
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
                  controller: _titleController,
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
                  'Location',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Mapp(),
                      ),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'Choose Location',
                    hintStyle: (controllerProvider.fromController.text == '')
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
                  controller: _titleController,
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
          ],
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

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
      useRootNavigator: false,
    );
  }

  _validateDate() {
    ControllerProvider controllerProvider =
        Provider.of<ControllerProvider>(context, listen: false);
    if (_titleController.text.isNotEmpty &&
        controllerProvider.fromController.text.isNotEmpty &&
        controllerProvider.toController.text.isNotEmpty) {
      // Get.to(() => const HomePage());
      return true;
    } else if (_titleController.text.isEmpty ||
        controllerProvider.fromController.text.isEmpty ||
        controllerProvider.toController.text.isEmpty) {
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

  _appbar() {
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
}

// ignore_for_file: unused_field

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:roder/googlemaps/maps.dart';
import 'package:roder/ui/theme.dart';
import 'package:roder/ui/widgets/button.dart';
import 'package:roder/ui/widgets/input_field.dart';
import '../googlemaps/maps_provider.dart';
import '../provider/clrProvider.dart';
import '../routes/routes.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  //Database
  final referenceDatabase = FirebaseDatabase.instance;
  final user = FirebaseAuth.instance.currentUser!;
  DatabaseReference refDb =
      FirebaseDatabase.instance.ref().child('Rides').push();

  //Texts
  final TextEditingController _titleController = TextEditingController();

  //Date and Time
  String _selectedDate = DateFormat("d MMMM yyyy").format(DateTime.now());
  String _endTime = "9:00 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();

  //Color
  int _selectedColor = 0;
  Color _mainColor = blueClr;
  bool isColorVisible = false;

  @override
  Widget build(BuildContext context) {
    ControllerProvider controllerProvider =
        Provider.of<ControllerProvider>(context);
    final ref = referenceDatabase.ref();

    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appbar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Ride, Your Way',
                style: headingStyle,
              ),
              MyInputField(
                title: "Ride Name",
                hint: "Give Your Ride A Name",
                controller: _titleController,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Begin to End',
                style: titleStyle,
              ),
              Container(
                width: double.infinity,
                height: 52,
                margin: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getMainClr(
                        Provider.of<ColorProvider>(context).selectedColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Mapp()));
                  },
                  child: Text(
                    'Google Maps',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              MyInputField(
                title: "Date",
                hint: _selectedDate,
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined,
                      color: _getMainClr(
                          Provider.of<ColorProvider>(context).selectedColor)),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                    title: "Start Time",
                    hint: _startTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: true);
                      },
                      icon: Icon(
                        Icons.access_time_rounded,
                        color: _getMainClr(
                            Provider.of<ColorProvider>(context).selectedColor),
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: MyInputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: _getMainClr(Provider.of<ColorProvider>(context)
                              .selectedColor),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // const SizedBox(
              //   height: 18,
              // ),
              Container(
                width: 140,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      isColorVisible = !isColorVisible;
                    });
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Customize',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: _getMainClr(
                                  Provider.of<ColorProvider>(context)
                                      .selectedColor)),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Icon(
                          isColorVisible
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: _getMainClr(Provider.of<ColorProvider>(context)
                              .selectedColor),
                        ),
                      ]),
                ),
              ),
              if (isColorVisible) _colorPicker(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MyButton(
                    onTap: () {
                      if (_validateDate() == true) {
                        //ref.child('Rides/${user.uid}').push().set({
                        ref.child('Rides').push().set({
                          'Name': _titleController.text,
                          'Date': _selectedDate,
                          'Start Time': _startTime,
                          'End Time': _endTime,
                          'Color': _selectedColor,
                          'Person': user.displayName!,
                          'GPhoto': user.photoURL!,
                          'Joined': 0,
                          'Origin': controllerProvider.fromController.text,
                          'Destination': controllerProvider.toController.text,
                        }).asStream();
                        _titleController.clear();
                        _addedRideBar();
                        //join ride when click on button
                      }
                      _scheduleNotification();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime? _selectedDateTime;

  _scheduleNotification() async {
    DateTime scheduleDateTime = _selectedDateTime ?? DateTime.now();
    if (_selectedDateTime != null) {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: -1,
            channelKey: 'basic_channel',
            title: 'There is a Ride Tomorrow!',
            body: "Full up your bike and be ready",
          ),
          schedule: NotificationCalendar.fromDate(date: scheduleDateTime),
          actionButtons: [
            NotificationActionButton(
                key: 'ACTION_BUTTON_OPEN', label: 'Open', autoDismissible: true)
          ]);
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
          data: _getPickerTheme(context), // Apply the customized theme
          child: child!,
        );
      },
    );

    if (pickerDate != null) {
      setState(() {
        _selectedDateTime = DateTime(
          pickerDate.year,
          pickerDate.month,
          pickerDate.day,
        );
      });
    } else {
      // Cancel action
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    if (pickedTime != null) {
      return pickedTime;
    } else {
      // User pressed cancel, return null
      return null;
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: _getPickerTheme(context), // Apply the customized theme
          child: child!,
        );
      },
    );
  }

  _validateDate() {
    ControllerProvider controllerProvider =
        Provider.of<ControllerProvider>(context, listen: false);
    if (_titleController.text.isNotEmpty &&
        controllerProvider.fromController.text.isNotEmpty &&
        controllerProvider.toController.text.isNotEmpty) {
      // Get.to(() => const NavBar());
      AppPage.gethome();
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

  _getMainClr(int no) {
    switch (no) {
      case 0:
        _mainColor = blueClr;
        return blueClr;
      case 1:
        _mainColor = oRange;
        return oRange;
      case 2:
        _mainColor = themeRed;
        return themeRed;
      default:
        _mainColor = blueClr;
        return blueClr;
    }
  }

  _colorPicker() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Color",
        style: titleStyle,
      ),
      const SizedBox(
        height: 8.0,
      ),
      Wrap(
          children: List<Widget>.generate(3, (int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedColor = index;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: index == 0
                  ? primaryClr
                  : index == 1
                      ? iceCold
                      : vBlue,
              child: _selectedColor == index
                  ? const Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 16,
                    )
                  : Container(),
            ),
          ),
        );
      })),
    ]);
  }

  _addedRideBar() {
    Get.snackbar("CREATED RIDE", "Ride has been created",
        snackPosition: SnackPosition.TOP,
        borderWidth: 2,
        borderColor: _getMainClr(
            Provider.of<ColorProvider>(context, listen: false).selectedColor),
        backgroundColor: Colors.white,
        colorText: _getMainClr(
            Provider.of<ColorProvider>(context, listen: false).selectedColor),
        icon: const Icon(Icons.add_location_outlined));
  }

  _appbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
    );
  }

  ThemeData _getPickerTheme(BuildContext context) {
    // Retrieve the current theme
    ThemeData currentTheme = Theme.of(context);

    // Create a copy of the current theme
    ThemeData pickerTheme = currentTheme.copyWith(
      colorScheme: currentTheme.colorScheme.copyWith(
        primary: blueClr, // Customize the primary color
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return _getMainClr(Provider.of<ColorProvider>(context)
                    .selectedColor); // Customize the button text color when pressed
              }
              return _getMainClr(Provider.of<ColorProvider>(context)
                  .selectedColor); // Customize the default button text color
            },
          ),
        ),
      ),
    );

    return pickerTheme;
  }
}

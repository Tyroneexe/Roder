import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:roder/themes/theme.dart';
import '../homepage/home_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController nuController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(user.photoURL!),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: searchBarClr,
                  ),
                  child: Icon(
                    Icons.edit,
                    color: btnBlueClr,
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
              userNameForm(context),
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
              // SizedBox(
              //   height: 5,
              // ),
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
              emailForm(context)
            ],
          ),
        ],
      ),
    );
  }

  Container emailForm(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 40,
      child: TextFormField(
        style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w100,
            fontSize: 14,
            color: Colors.black),
        controller: emailController,
        decoration: InputDecoration(
          hintText: user.email,
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
    );
  }

  Container numberForm(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 60,
      child: IntlPhoneField(
        flagsButtonPadding: EdgeInsets.only(
          left: 20,
        ),
        dropdownIcon: Icon(
          Icons.arrow_drop_down,
          color: btnBlueClr,
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
        initialCountryCode: 'US',
        // onChanged: (phone) {},
      ),
    );
  }

  Container userNameForm(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 40,
      child: TextFormField(
        style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w100,
            fontSize: 14,
            color: Colors.black),
        controller: titleCtrl,
        decoration: InputDecoration(
          hintText: user.displayName,
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
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      foregroundColor: btnBlueClr,
    );
  }
}

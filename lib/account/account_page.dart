import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roder/themes/theme.dart';
import '../homepage/home_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  TextEditingController titleCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                user.photoURL!,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ],
          ),
        ],
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

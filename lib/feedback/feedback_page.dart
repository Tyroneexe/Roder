import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roder/ui/theme.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: lightBlueClr,
            padding: EdgeInsets.all(
              20,
            ),
            textStyle: TextStyle(
              fontSize: 24,
            ),
          ),
          child: Text('Send Email'),
          onPressed: () {},
        ),
      ),
    );
  }

 
  _appBar() {
    return AppBar(
      iconTheme:
          IconThemeData(color: Get.isDarkMode ? Colors.white : Colors.black),
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
    );
  }

}

// ignore_for_file: unused_field, must_be_immutable

import 'package:flutter/material.dart';
import 'package:roder/themes/theme.dart';


class MyButton extends StatelessWidget {
  final Function()? onTap;
  MyButton({Key? key, required this.onTap}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color:
                btnBlueClr,),
        child: Center(
          child: Icon(
            Icons.add,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

}

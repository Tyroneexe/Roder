// ignore_for_file: unused_field, must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roder/ui/theme.dart';

import '../../provider/clrProvider.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  MyButton({Key? key, required this.onTap}) : super(key: key);
  Color _mainColor = blueClr;

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
                _getMainClr(Provider.of<ColorProvider>(context).selectedColor)),
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
}

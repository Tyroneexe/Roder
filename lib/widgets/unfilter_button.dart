import 'package:flutter/material.dart';

import '../themes/theme.dart';

class UnFilterButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  const UnFilterButton(
      {super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Container(
        width: 100,
        height: 32,
        child: TextButton(
          onPressed: onPressed,
          child: child,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(unselectedBtnClr),
            foregroundColor: MaterialStateProperty.all<Color>(btnBlueClr),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

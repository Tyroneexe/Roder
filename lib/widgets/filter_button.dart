import 'package:flutter/material.dart';

import '../themes/theme.dart';

class FilterButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  const FilterButton({Key? key, required this.onPressed, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: outlineBtnClr, // Set the border color to blue
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: 100,
            height: 32,
            child: TextButton(
              onPressed: onPressed,
              child: child,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(btnBlueClr),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

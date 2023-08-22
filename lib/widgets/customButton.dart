import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../utility/screen_utility.dart';

class CustomButton extends StatelessWidget {
  CustomButton({super.key, this.label, this.onPressed});

  final VoidCallback? onPressed;
  String? label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtility.getWidth(context) * 0.9,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(tdBlue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFE3E8F3),
            fontSize: 18,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            letterSpacing: 1.08,
          ),
        ),
      ),
    );
  }
}

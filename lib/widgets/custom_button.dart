import 'package:flutter/material.dart';

import '../constants/extensions/screen_size_ext.dart';

@immutable
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.label,
    this.onPressed,
  });

  final VoidCallback? onPressed;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth * 0.9,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label!,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      ),
    );
  }
}

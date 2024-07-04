import 'package:flutter/material.dart';

import '../../constants/extensions/screen_size_ext.dart';

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
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).buttonTheme.colorScheme?.onInverseSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        onPressed: onPressed,
        child: Text(
          label!,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 18,
              ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../constants/extensions/screen_size_ext.dart';

@immutable
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.label,
    this.onPressed,
    this.isEnabled = true,
  });

  final VoidCallback? onPressed;
  final String? label;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth * 0.9,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          enableFeedback: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).buttonTheme.colorScheme?.onInverseSurface,
          disabledBackgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        onPressed: isEnabled ? onPressed : null,
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

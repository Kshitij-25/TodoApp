import 'package:flutter/material.dart';

@immutable
class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Function()? onEditingComplete;
  final void Function()? onTap;
  final bool autofocus;
  final bool readOnly;
  final Widget? suffixIcon;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.focusNode,
    this.onEditingComplete,
    this.onTap,
    this.autofocus = false,
    this.readOnly = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
      autofocus: autofocus,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        alignLabelWithHint: true,
        border: const UnderlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

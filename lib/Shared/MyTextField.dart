// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

typedef OptionSelect<T> = Map<String, T?> Function();

class MyTextField extends StatelessWidget {
  final String hintValue;
  final TextInputType textInputType;
  final bool isObscureText;
  final bool autofocusflag;
  final Icon icon;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final String? Function(String?)? validate;

  const MyTextField({
    super.key,
    this.onTap,
    this.validate,
    this.controller,
    required this.autofocusflag,
    required this.hintValue,
    required this.textInputType,
    required this.isObscureText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validate,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      keyboardType: textInputType,
      obscureText: isObscureText,
      autofocus: autofocusflag,
      autocorrect: false,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: hintValue,
          hintStyle: TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            onPressed: () {
              onTap!();
            },
            icon: icon,
          ),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          filled: true,
          contentPadding: EdgeInsets.all(8)),
    );
  }
}

// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

ShowSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(days: 1),
      content: Text(text),
      action: SnackBarAction(label: 'close', onPressed: () {}),
    ),
  );
}

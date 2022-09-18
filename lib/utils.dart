import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showSimpleDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

void showToastMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      backgroundColor: Colors.blueGrey[500]);
}

void showErrorToast(String message) {
  Fluttertoast.showToast(
      msg: message, textColor: Colors.white, backgroundColor: Colors.red[500]);
}

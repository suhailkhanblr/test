import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showMessage(BuildContext context, String message,
    {bool isError = false, bool isWarning = false, bool isSuccess = false}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: (isError)
          ? Colors.red
          : (isWarning)
              ? Colors.orangeAccent
              : (isSuccess)
                  ? Colors.green
                  : Colors.black,
      textColor: Colors.white,
      fontSize: 14.0);
}

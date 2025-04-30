import 'package:flutter/material.dart';

class AlertService {
  static Future<void> showAlert({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText = 'OK',
    VoidCallback? onButtonPressed,
    bool barrierDismissible = true,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible, // Allows dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                if (onButtonPressed != null) {
                  onButtonPressed(); // Call the callback if provided
                }
              },
              child: Text(buttonText!),
            ),
          ],
        );
      },
    );
  }
}

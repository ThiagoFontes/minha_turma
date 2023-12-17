import 'package:flutter/material.dart';

Future<T?> dialogError<T>({
  required BuildContext context,
  required String error,
}) async {
  return showDialog<T>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Erro'),
        content: Text(error),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<T?> dialogInfo<T>(
  BuildContext context, {
  required String message,
  String? title,
}) async {
  return await showDialog<T>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title ?? 'Info'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

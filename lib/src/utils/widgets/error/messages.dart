import 'package:flutter/material.dart';
import 'package:myclasses/src/app_routes.dart';

abstract class Messages {
  static Future<T?> error<T>({
    required String error,
  }) async {
    final context = AppRoutes.navigatorKey.currentContext;

    if (context != null) {
      return await showDialog<T>(
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
    return null;
  }

  static Future<T?> info<T>({
    required String message,
    String? title,
  }) async {
    final context = AppRoutes.navigatorKey.currentContext;
    if (context != null) {
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
    return null;
  }
}

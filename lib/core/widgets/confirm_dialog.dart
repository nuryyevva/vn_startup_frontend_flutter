import 'package:flutter/material.dart';

/// Generic Yes/No confirmation dialog. Returns true only if the user
/// tapped the confirm action.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  required String cancelLabel,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(cancelLabel)),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            confirmLabel,
            style: destructive ? TextStyle(color: Theme.of(context).colorScheme.error) : null,
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}

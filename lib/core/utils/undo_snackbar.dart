import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wallet_app/l10n/app_localizations.dart';

void showUndoSnackBar(
  ScaffoldMessengerState messenger, {
  required String message,
  required VoidCallback onUndo,
  Duration duration = const Duration(seconds: 4),
}) {
  messenger.clearSnackBars();
  final undoLabel = AppLocalizations.of(messenger.context)!.undo;

  final controller = messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
      persist: false,
      action: SnackBarAction(label: undoLabel, onPressed: onUndo),
    ),
  );

  var closed = false;
  controller.closed.then((_) => closed = true);
  Timer(duration + const Duration(milliseconds: 400), () {
    if (!closed) messenger.hideCurrentSnackBar();
  });
}
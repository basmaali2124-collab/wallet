import 'package:flutter/material.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';

class ErrorRetry extends StatelessWidget {
  const ErrorRetry({super.key, this.message, required this.onRetry});

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message ?? l10n.somethingWentWrong, textAlign: TextAlign.center),
          TextButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}

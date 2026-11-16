import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';

class NumericKeypad extends StatelessWidget {
  final ValueChanged<String> onKeyPressed;
  final VoidCallback onBackspace;
  final VoidCallback onClear;

  const NumericKeypad({
    super.key,
    required this.onKeyPressed,
    required this.onBackspace,
    required this.onClear,
  });

  static const _backspace = '<';
  static const _labels = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '.',
    '0',
    _backspace,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row = 0; row < 4; row++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: row < 3 ? AppSpacing.sm : 0),
              child: Row(
                children: [
                  for (var col = 0; col < 3; col++) ...[
                    if (col > 0) SizedBox(width: AppSpacing.sm),
                    Expanded(child: _build(context, _labels[row * 3 + col])),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _build(BuildContext context, String label) {
    final isBackspace = label == _backspace;
    return _KeypadKey(
      keyName: isBackspace ? 'backspace' : label,
      onTap: () {
        HapticFeedback.lightImpact();
        isBackspace ? onBackspace() : onKeyPressed(label);
      },
      onLongPress: isBackspace
          ? () {
              HapticFeedback.lightImpact();
              onClear();
            }
          : null,
      child: isBackspace
         ? Icon(Icons.backspace_outlined, color: context.palette.textPrimary) : Text(
              label,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: context.palette.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
    );
  }
}

class _KeypadKey extends StatelessWidget {
  final String keyName;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Widget child;

  const _KeypadKey({
    required this.keyName,
    required this.onTap,
    required this.onLongPress,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.palette.surface,
      borderRadius: AppRadius.tileBorder,
      child: InkWell(
        key: Key('key_$keyName'),
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: AppRadius.tileBorder,
        child: Center(child: child),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';

class FieldRow extends StatelessWidget {
  const FieldRow({
    super.key,
    required this.children,
    this.flex = const [],
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final List<Widget> children;
  final List<int> flex;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(width: AppSpacing.md),
          Expanded(flex: i < flex.length ? flex[i] : 1, child: children[i]),
        ],
      ],
    );
  }
}

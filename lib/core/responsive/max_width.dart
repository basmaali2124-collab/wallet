import 'dart:math' as math;

import 'package:flutter/material.dart';

class MaxWidth extends StatelessWidget {
  const MaxWidth({super.key, required this.maxWidth, required this.child});

  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) => Align(
        alignment: AlignmentDirectional.centerStart,
        heightFactor: 1,
        child: SizedBox(width: math.min(c.maxWidth, maxWidth), child: child),
      ),
    );
  }
}
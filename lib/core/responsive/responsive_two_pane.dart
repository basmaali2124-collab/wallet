import 'package:flutter/material.dart';
import 'package:wallet_app/core/responsive/breakpoints.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';

class ResponsiveTwoPane extends StatelessWidget {
  const ResponsiveTwoPane({
    super.key,
    required this.primary,
    this.secondary,
    this.primaryFlex = 5,
    this.secondaryFlex = 6,
    this.gap,
    this.stackedGap,
  });

  final Widget primary;
  final Widget? secondary;
  final int primaryFlex;
  final int secondaryFlex;
  final double? gap;
  final double? stackedGap;

  @override
  Widget build(BuildContext context) {
    final second = secondary;
    if (second == null) return primary;

    return LayoutBuilder(
      builder: (context, c) {
        if (Breakpoints.columnsFor(c.maxWidth) == 2) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: primaryFlex, child: primary),
              SizedBox(width: gap ?? AppSpacing.xl),
              Expanded(flex: secondaryFlex, child: second),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            primary,
            SizedBox(height: stackedGap ?? AppSpacing.lg),
            second,
          ],
        );
      },
    );
  }
}
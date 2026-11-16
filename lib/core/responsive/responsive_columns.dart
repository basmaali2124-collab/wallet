import 'package:flutter/material.dart';
import 'package:wallet_app/core/responsive/breakpoints.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';

class ResponsiveColumns extends StatelessWidget {
  const ResponsiveColumns({
    super.key,
    required this.children,
    this.weights,
    this.gap,
    this.maxColumns = 2,
  }) : assert(weights == null || weights.length == children.length);

  final List<Widget> children;
  final List<int>? weights;
  final double? gap;
  final int maxColumns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final cols = Breakpoints.columnsFor(c.maxWidth, maxColumns: maxColumns);
        if (cols == 1 || children.length < 2) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          );
        }

        final buckets = List.generate(cols, (_) => <Widget>[]);
        final loads = List.filled(cols, 0);
        for (var i = 0; i < children.length; i++) {
          var target = 0;
          for (var k = 1; k < cols; k++) {
            if (loads[k] < loads[target]) target = k;
          }
          buckets[target].add(children[i]);
          loads[target] += weights?[i] ?? 1;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var k = 0; k < cols; k++) ...[
              if (k > 0) SizedBox(width: gap ?? AppSpacing.xl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buckets[k],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
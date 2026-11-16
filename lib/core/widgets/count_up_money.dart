import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/text_style_ext.dart';
import 'package:wallet_app/core/utils/money.dart';

class CountUpMoney extends StatelessWidget {
  const CountUpMoney({
    super.key,
    required this.cents,
    required this.style,
    this.symbol = r'$',
    this.hidden = false,
    this.dimCents = false,
    this.alignment = AlignmentDirectional.centerStart,
    this.duration = const Duration(milliseconds: 800),
  });

  final int cents;
  final TextStyle style;
  final String symbol;
  final bool hidden;
  final bool dimCents;
  final AlignmentGeometry alignment;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final base = style.tabular;
    final dimmed = TextStyle(color: style.color?.withValues(alpha: 0.6));
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: alignment,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: cents.toDouble()),
        duration: duration,
        curve: Curves.easeOutCubic,
        builder: (_, v, _) {
          if (hidden) {
            return Text('••••••', maxLines: 1, style: base);
          }
          final p = Money.parts(v.round(), symbol: symbol);
          return Text.rich(
            TextSpan(
              children: [
                TextSpan(text: p.main),
                TextSpan(text: p.cents, style: dimCents ? dimmed : null),
              ],
            ),
            maxLines: 1,
            style: base,
          );
        },
      ),
    );
  }
}
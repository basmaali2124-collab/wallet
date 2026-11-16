import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';

class PeriodSelector extends StatelessWidget {
  const PeriodSelector({
    super.key,
    required this.label,
    required this.onPrevious,
    required this.onNext,
    this.isSmall = false,
  });

  final String label;
  final VoidCallback onPrevious;
  final VoidCallback? onNext;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    final iconSize = isSmall ? 18.0 : 24.0;
    final textStyle = isSmall
        ? AppTextStyles.body.copyWith(fontSize: 14)
        : AppTextStyles.title;

    return Row(
      mainAxisSize: isSmall ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: isSmall
          ? MainAxisAlignment.start
          : MainAxisAlignment.spaceBetween,
      children: [
        _ArrowButton(
          icon: Icons.chevron_left_rounded,
          size: iconSize,
          onTap: onPrevious,
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmall ? 4 : 0),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
          ),
        ),
        _ArrowButton(
          icon: Icons.chevron_right_rounded,
          size: iconSize,
          onTap: onNext,
        ),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.icon,
    required this.size,
    required this.onTap,
  });

  final IconData icon;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: size,
          color: onTap == null
              ? Theme.of(context).disabledColor
              : Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
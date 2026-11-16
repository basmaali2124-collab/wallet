import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_app/core/responsive/breakpoints.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';

Future<T?> showFormSheet<T>(BuildContext context, {required Widget child}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, _, _) => Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: Breakpoints.narrowContentWidth,
        ),
        child: child,
      ),
    ),
    transitionBuilder: (context, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).maybePop(),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 8 * animation.value + 0.001,
                sigmaY: 8 * animation.value + 0.001,
              ),
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.25 * animation.value),
              ),
            ),
          ),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        ],
      );
    },
  );
}

class FormSheetShell extends StatefulWidget {
  const FormSheetShell({super.key, required this.builder});

  final List<Widget> Function(BuildContext context, double availableHeight)
  builder;

  static const double fraction = 0.92;

  @override
  State<FormSheetShell> createState() => _FormSheetShellState();
}

class _FormSheetShellState extends State<FormSheetShell> {
  bool _closing = false;

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (n) {
        if (n.extent <= 0.05 && !_closing && mounted) {
          _closing = true;
          Navigator.of(context).maybePop();
        }
        return false;
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: keyboard),
        child: DraggableScrollableSheet(
          initialChildSize: FormSheetShell.fraction,
          minChildSize: 0,
          maxChildSize: FormSheetShell.fraction,
          snap: true,
          builder: (context, controller) => Material(
            color: context.palette.background,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                controller: controller,
                physics: const AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      0,
                      AppSpacing.xl,
                      bottomInset + AppSpacing.lg,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                          width: 40.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: context.palette.border,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        ...widget.builder(context, constraints.maxHeight),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
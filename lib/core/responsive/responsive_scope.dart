import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:wallet_app/core/responsive/breakpoints.dart';

class ResponsiveScope extends StatefulWidget {
  const ResponsiveScope({super.key, required this.builder});

  final Widget Function(BuildContext context, Size designSize) builder;

  @override
  State<ResponsiveScope> createState() => _ResponsiveScopeState();
}

class _ResponsiveScopeState extends State<ResponsiveScope>
    with WidgetsBindingObserver {
  Size _screen = Size.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screen = _read();
  }

  @override
  void didChangeMetrics() {
    final s = _read();
    if (s != _screen) setState(() => _screen = s);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Size _read() {
    final view = View.of(context);
    return view.physicalSize / view.devicePixelRatio;
  }

  Size get _designSize {
    if (_screen.width <= 0 || _screen.height <= 0) {
      return const Size(Breakpoints.designWidth, 844);
    }
    final scale =
        math.min(_screen.width, Breakpoints.maxScaleWidth) /
        Breakpoints.designWidth;
    return Size(_screen.width / scale, _screen.height / scale);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _designSize);
}
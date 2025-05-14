import 'package:flutter/widgets.dart';

class CustomMenuWidget {
  const CustomMenuWidget({
    required this.child,
    required this.onPressed,
    this.foregroundColor,
    this.backgroundColor,
    this.label,
    this.closeSpeedDialOnPressed = true,
  });
  final Widget child;
  final Function onPressed;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final String? label;
  final bool closeSpeedDialOnPressed;
}
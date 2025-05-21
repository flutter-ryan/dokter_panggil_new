import 'package:flutter/material.dart';

class ButtonCircleWidget extends StatelessWidget {
  const ButtonCircleWidget({
    super.key,
    this.onPressed,
    this.icon,
    this.bgColor,
    this.fgColor,
    this.radius,
  });

  final VoidCallback? onPressed;
  final Widget? icon;
  final Color? bgColor;
  final Color? fgColor;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 22,
      backgroundColor: bgColor ?? Colors.green,
      foregroundColor: fgColor ?? Colors.white,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: icon ?? Icon(Icons.add_rounded),
      ),
    );
  }
}

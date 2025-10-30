import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class ButtonRoundedIconWidget extends StatelessWidget {
  const ButtonRoundedIconWidget({
    super.key,
    this.label,
    this.color,
    this.foregroundColor,
    this.size,
    this.onPressed,
    this.icon,
  });

  final String? label;
  final Color? color;
  final Color? foregroundColor;
  final Size? size;
  final VoidCallback? onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? kPrimaryColor,
        foregroundColor: foregroundColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        minimumSize: size,
      ),
      icon: icon,
      label: Text('$label'),
    );
  }
}

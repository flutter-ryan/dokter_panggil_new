import 'package:flutter/material.dart';

class ButtonRoundedWidget extends StatelessWidget {
  const ButtonRoundedWidget({
    super.key,
    this.onPressed,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
  });

  final VoidCallback? onPressed;
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 42),
        backgroundColor: backgroundColor ?? Colors.grey[200],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        foregroundColor: foregroundColor ?? Colors.black,
      ),
      child: Text('$label'),
    );
  }
}

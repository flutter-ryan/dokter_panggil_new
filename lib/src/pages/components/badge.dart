import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key? key,
    this.color,
    this.label,
    this.labelColor = Colors.white,
  }) : super(key: key);

  final Color? color;
  final String? label;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        '$label',
        style: TextStyle(color: labelColor, fontSize: 10.0),
      ),
    );
  }
}

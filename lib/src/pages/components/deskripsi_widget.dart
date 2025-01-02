import 'package:flutter/material.dart';

class DeskripsiWidget extends StatelessWidget {
  const DeskripsiWidget({
    super.key,
    this.title,
    this.body,
  });

  final String? title;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title',
          style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
        ),
        const SizedBox(
          height: 4,
        ),
        body ?? const SizedBox()
      ],
    );
  }
}

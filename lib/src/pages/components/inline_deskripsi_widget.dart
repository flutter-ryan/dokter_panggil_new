import 'package:flutter/material.dart';

class InlineDeskripsiWidget extends StatelessWidget {
  const InlineDeskripsiWidget({
    super.key,
    this.title,
    this.body,
  });

  final String? title;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$title',
            style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(child: body ?? const SizedBox())
      ],
    );
  }
}

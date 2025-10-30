import 'package:flutter/material.dart';

class TileDataCard extends StatelessWidget {
  const TileDataCard({
    super.key,
    this.icon,
    this.title,
    this.body,
  });

  final Widget? icon;
  final String? title;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon ?? const SizedBox(),
        const SizedBox(
          width: 4,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              body ?? const SizedBox(),
            ],
          ),
        )
      ],
    );
  }
}

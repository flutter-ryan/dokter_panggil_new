import 'package:flutter/material.dart';

class BulletWidget extends StatelessWidget {
  const BulletWidget({
    super.key,
    this.title,
    this.subtitle,
    this.badge,
  });

  final String? title;
  final Widget? subtitle;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '\u2022',
          style: TextStyle(fontSize: 14, height: 1.3, color: Colors.grey),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: ListTile(
            dense: true,
            minTileHeight: 0,
            minLeadingWidth: 0,
            minVerticalPadding: 0,
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                Flexible(child: Text('$title')),
                SizedBox(
                  width: 12,
                ),
                badge ?? SizedBox()
              ],
            ),
            subtitle: subtitle,
          ),
        ),
      ],
    );
  }
}

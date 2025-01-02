import 'package:flutter/material.dart';

class TileObatWidget extends StatelessWidget {
  const TileObatWidget({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
  });

  final String? title;
  final String? subtitle;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      style: ListTileStyle.list,
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      minLeadingWidth: 0,
      horizontalTitleGap: 2,
      title: Text(
        '$title',
        style: TextStyle(
          fontSize: 12,
        ),
      ),
      subtitle: Text(
        '$subtitle',
        style: TextStyle(
          fontSize: 12,
        ),
      ),
      trailing: Text(
        '$trailing',
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}

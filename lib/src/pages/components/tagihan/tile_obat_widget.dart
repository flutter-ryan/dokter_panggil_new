import 'package:flutter/material.dart';

class TileObatWidget extends StatelessWidget {
  const TileObatWidget({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isEdit = false,
    this.iconData,
  });

  final String? title;
  final String? subtitle;
  final String? trailing;
  final VoidCallback? onTap;
  final bool isEdit;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      style: ListTileStyle.list,
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      minLeadingWidth: 0,
      horizontalTitleGap: 2,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$title',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          if (isEdit)
            SizedBox(
              width: 12,
            ),
          if (isEdit)
            Icon(
              iconData ?? Icons.edit_note_rounded,
              size: 18,
              color: iconData != null ? Colors.red : Colors.blueAccent,
            )
        ],
      ),
      subtitle: subtitle == null
          ? null
          : Text(
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

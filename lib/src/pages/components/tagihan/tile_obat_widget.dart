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
    this.leading,
  });

  final String? title;
  final String? subtitle;
  final String? trailing;
  final VoidCallback? onTap;
  final bool isEdit;
  final IconData? iconData;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      minLeadingWidth: 0,
      horizontalTitleGap: 18,
      leading: leading,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              '$title',
              style: TextStyle(
                fontSize: 12,
              ),
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

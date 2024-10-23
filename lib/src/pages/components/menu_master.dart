import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuMaster extends StatelessWidget {
  const MenuMaster(
      {Key? key,
      required this.title,
      this.onTap,
      this.iconData = FontAwesomeIcons.database})
      : super(key: key);

  final String title;
  final VoidCallback? onTap;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 4.0, horizontal: 32.0),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        child: FaIcon(
          iconData,
          size: 20.0,
        ),
      ),
      title: Text('Master $title'),
      trailing: const Icon(Icons.keyboard_arrow_right),
    );
  }
}

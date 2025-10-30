import 'package:flutter/material.dart';

class ListTileDataWidget extends StatelessWidget {
  const ListTileDataWidget({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    this.dense = false,
  });

  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      dense: dense,
      leading: const Icon(
        Icons.arrow_right_rounded,
      ),
      horizontalTitleGap: 8,
      minLeadingWidth: 28,
      title: title,
      subtitle: subtitle,
    );
  }
}

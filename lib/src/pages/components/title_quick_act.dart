import 'package:flutter/material.dart';

class TitleQuickAct extends StatelessWidget {
  const TitleQuickAct({
    Key? key,
    this.title,
  }) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 0),
      child: Text(
        '$title',
        style: const TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

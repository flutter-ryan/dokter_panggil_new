import 'package:flutter/material.dart';

class TitleBarModal extends StatelessWidget {
  const TitleBarModal({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 22.0, right: 18.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
      ),
    );
  }
}

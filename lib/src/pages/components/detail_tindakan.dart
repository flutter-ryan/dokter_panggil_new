import 'package:flutter/material.dart';

class DetailTindakan extends StatelessWidget {
  const DetailTindakan({
    super.key,
    this.title,
    this.subtitle,
  });

  final String? title;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title',
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(
          height: 4.0,
        ),
        subtitle ?? const SizedBox(),
      ],
    );
  }
}

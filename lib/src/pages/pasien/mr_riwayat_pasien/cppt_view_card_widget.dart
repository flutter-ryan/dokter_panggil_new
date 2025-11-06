import 'package:flutter/material.dart';

class CpptViewCardWidget extends StatelessWidget {
  const CpptViewCardWidget({
    super.key,
    this.title,
    this.data,
  });

  final String? title;
  final Widget? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              '$title',
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  fontSize: 12),
            ),
          ),
          data ?? const SizedBox()
        ],
      ),
    );
  }
}

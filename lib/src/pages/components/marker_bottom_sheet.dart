import 'package:flutter/material.dart';

class MarkerBottomSheet extends StatelessWidget {
  const MarkerBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

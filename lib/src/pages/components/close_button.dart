import 'package:flutter/material.dart';

class ClosedButton extends StatelessWidget {
  const ClosedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      width: 32,
      child: Material(
        borderRadius: BorderRadius.circular(32.0),
        color: Colors.transparent,
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.close_rounded),
          iconSize: 28.0,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}

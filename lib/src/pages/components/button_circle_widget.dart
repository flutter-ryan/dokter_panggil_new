import 'package:flutter/material.dart';

class ButtonCircleWidget extends StatelessWidget {
  const ButtonCircleWidget({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(Icons.add_rounded),
      ),
    );
  }
}

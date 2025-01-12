import 'package:flutter/material.dart';

class CloseButtonWidget extends StatelessWidget {
  const CloseButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[100],
      foregroundColor: Colors.grey,
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        padding: EdgeInsets.zero,
        iconSize: 20,
        icon: Icon(Icons.close_rounded),
      ),
    );
  }
}

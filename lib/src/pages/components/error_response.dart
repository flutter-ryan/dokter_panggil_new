import 'package:flutter/material.dart';

class ErrorResponse extends StatelessWidget {
  const ErrorResponse({
    Key? key,
    this.message,
    this.onTap,
    this.button = true,
  }) : super(key: key);

  final String? message;
  final VoidCallback? onTap;
  final bool button;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning_rounded,
            size: 72.0,
            color: Colors.red,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              '$message',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ),
          const SizedBox(
            height: 18.0,
          ),
          if (button)
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(150, 45),
              ),
              child: const Text('Coba lagi'),
            )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SearchWidgetPage extends StatelessWidget {
  const SearchWidgetPage({
    Key? key,
    required this.filter,
    required this.hint,
  }) : super(key: key);

  final TextEditingController filter;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(width: 0.5, color: Colors.grey[400]!),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: filter,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ),
            const Icon(
              Icons.search,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}

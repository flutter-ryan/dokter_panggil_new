import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchInputForm extends StatelessWidget {
  const SearchInputForm({
    super.key,
    this.controller,
    this.focusNode,
    required this.hint,
    this.isReadOnly = false,
    this.onTap,
    this.autofocus = false,
    this.suffixIcon,
  });

  final TextEditingController? controller;
  final String hint;
  final FocusNode? focusNode;
  final bool isReadOnly;
  final VoidCallback? onTap;
  final bool autofocus;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        border: Border.all(width: 0.3, color: Colors.grey),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        children: [
          const FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            size: 18.0,
            color: Colors.grey,
          ),
          const SizedBox(
            width: 15.0,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              readOnly: isReadOnly,
              autofocus: autofocus,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: suffixIcon,
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 2,
                  minHeight: 2,
                ),
              ),
              onTap: onTap,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatelessWidget {
  const Input({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.suffixIcon,
    this.minLines = 1,
    this.maxLines,
    this.obscure = false,
    this.onSave,
    this.validator,
    this.readOnly = false,
    this.textCap = TextCapitalization.none,
    this.keyType = TextInputType.text,
    this.onTap,
    this.textInputAction = TextInputAction.done,
    this.inputFormatters,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String label;
  final String hint;
  final Widget? suffixIcon;
  final int minLines;
  final int? maxLines;
  final bool obscure;
  final Function(String?)? onSave;
  final String? Function(String?)? validator;
  final TextCapitalization textCap;
  final TextInputType keyType;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            border: Border.all(width: 0.3, color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            focusNode: focusNode,
            controller: controller,
            minLines: minLines,
            maxLines: maxLines,
            obscureText: obscure,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              suffixIcon: suffixIcon,
            ),
            readOnly: readOnly,
            validator: validator,
            onSaved: onSave,
            textCapitalization: textCap,
            onTap: onTap,
            keyboardType: keyType,
            textInputAction: textInputAction,
          ),
        ),
      ],
    );
  }
}

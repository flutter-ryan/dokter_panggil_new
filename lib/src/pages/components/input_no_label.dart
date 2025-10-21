import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';

class InputNoLabel extends StatelessWidget {
  const InputNoLabel({
    super.key,
    required this.hint,
    required this.controller,
    this.onSaved,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.minLines,
    this.validate = true,
    this.textCapitalization = TextCapitalization.sentences,
  });

  final String hint;
  final TextEditingController controller;
  final Function(String? val)? onSaved;
  final Function(String? val)? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final int? minLines;
  final bool validate;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: minLines,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.all(18.0),
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey[400]!, width: 0.7),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey[400]!, width: 0.7),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: kPrimaryColor, width: 0.7),
        ),
      ),
      validator: validate
          ? (val) {
              if (val!.isEmpty) {
                return 'Input required';
              }
              return null;
            }
          : null,
      onSaved: onSaved,
      onChanged: onChanged,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
    );
  }
}

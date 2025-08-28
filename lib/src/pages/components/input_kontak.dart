import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class InputKontak extends StatelessWidget {
  const InputKontak({
    super.key,
    this.controller,
    this.label,
    this.onSaved,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String? label;
  final Function(PhoneNumber? val)? onSaved;
  final Function(PhoneNumber? val)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            border: Border.all(width: 0.3, color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: IntlPhoneField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              hintText: 'Ex: 081334334334',
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
            initialCountryCode: 'ID',
            disableLengthCheck: true,
            showDropdownIcon: false,
            showCountryFlag: false,
            validator: (value) {
              if (value!.number.isNotEmpty) {
                return null;
              }
              return 'Invalid phone Number';
            },
            onChanged: onChanged,
            onSaved: onSaved,
          ),
        ),
      ],
    );
  }
}

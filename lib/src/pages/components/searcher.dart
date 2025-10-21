import 'dart:io';

import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:flutter/material.dart';

class Searcher extends StatelessWidget {
  const Searcher({
    super.key,
    required this.controller,
    required this.focus,
    required this.suffixIcon,
    required this.result,
    required this.hint,
  });

  final TextEditingController? controller;
  final FocusNode? focus;
  final Widget? suffixIcon;
  final Widget? result;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 2.0,
              right: 32.0,
              top: MediaQuery.of(context).padding.top + 18,
            ),
            child: Row(
              children: [
                if (Platform.isAndroid)
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.grey[600],
                    ),
                  )
                else
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey[600],
                    ),
                  ),
                const SizedBox(
                  width: 4.0,
                ),
                Expanded(
                  child: SearchInputForm(
                    controller: controller,
                    focusNode: focus,
                    hint: '$hint',
                    autofocus: true,
                    suffixIcon: suffixIcon,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 22.0,
          ),
          result ?? const SizedBox(),
        ],
      ),
    );
  }
}

import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.title,
    this.subtitle,
    this.closeButton,
  });

  final String title;
  final Widget? subtitle;
  final Widget? closeButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      decoration: const BoxDecoration(color: kPrimaryColor, boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6.0,
          offset: Offset(2.0, 1.0),
        )
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 18,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              closeButton ?? const SizedBox(),
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
          subtitle ?? const SizedBox(),
          const SizedBox(
            height: 22.0,
          ),
        ],
      ),
    );
  }
}

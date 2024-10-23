import 'package:flutter/material.dart';

class CardLaporanJasa extends StatelessWidget {
  const CardLaporanJasa({
    super.key,
    this.title,
    this.periode,
    this.onTap,
    this.icon,
  });

  final String? title;
  final String? periode;
  final Widget? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12.0,
            offset: Offset(2.0, 2.0),
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 22.0,
          ),
          icon ?? const SizedBox(),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: ListTile(
              onTap: onTap,
              title: Text('$title'),
              subtitle: Text('$periode'),
              trailing: const Icon(Icons.download_for_offline_outlined),
            ),
          )
        ],
      ),
    );
  }
}

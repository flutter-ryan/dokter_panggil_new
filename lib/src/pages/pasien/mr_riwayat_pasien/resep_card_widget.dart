import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class ResepCardWidget extends StatelessWidget {
  const ResepCardWidget({
    super.key,
    this.title,
    this.onView,
    this.dataResep,
  });

  final String? title;
  final VoidCallback? onView;
  final Widget? dataResep;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: kBgRedLightColor,
        border: Border.all(color: kPrimaryColor, width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$title',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              if (onView != null)
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: 14,
                  child: IconButton(
                      onPressed: onView,
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.document_scanner_outlined,
                        color: Colors.blueAccent,
                        size: 16,
                      )),
                ),
            ],
          ),
          dataResep ?? const SizedBox(),
        ],
      ),
    );
  }
}

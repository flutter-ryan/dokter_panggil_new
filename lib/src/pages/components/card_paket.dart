import 'package:flutter/material.dart';

class CardPaket extends StatelessWidget {
  const CardPaket({
    super.key,
    this.title,
    this.buttonDetail,
    this.tiles,
  });

  final String? title;
  final Iterable<Widget>? tiles;
  final Widget? buttonDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    '$title',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              buttonDetail ?? const SizedBox()
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          const Divider(
            height: 0.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: ListTile.divideTiles(
                context: context,
                tiles: tiles!,
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

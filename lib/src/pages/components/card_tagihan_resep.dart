import 'package:flutter/material.dart';

class CardTagihanResep extends StatefulWidget {
  const CardTagihanResep({
    super.key,
    this.title,
    this.tiles,
    this.subTotal,
    this.buttonDetail,
    this.transportWidget,
  });

  final String? title;
  final Widget? tiles;
  final Widget? subTotal;
  final Widget? buttonDetail;
  final Widget? transportWidget;

  @override
  State<CardTagihanResep> createState() => _CardTagihanResepState();
}

class _CardTagihanResepState extends State<CardTagihanResep> {
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
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${widget.title}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                widget.buttonDetail ?? const SizedBox()
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Divider(
            height: 0.0,
            color: Colors.grey[400],
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: widget.tiles ?? const SizedBox(),
          ),
          Divider(
            color: Colors.grey[400],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: const Text(
                'Sub Total',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: widget.subTotal,
            ),
          ),
        ],
      ),
    );
  }
}

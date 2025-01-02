import 'package:flutter/material.dart';

class CardTagihanBhp extends StatefulWidget {
  const CardTagihanBhp({
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
  State<CardTagihanBhp> createState() => _CardTagihanBhpState();
}

class _CardTagihanBhpState extends State<CardTagihanBhp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          const SizedBox(
            height: 12,
          ),
          const Divider(
            height: 0.0,
          ),
          const SizedBox(
            height: 12,
          ),
          widget.tiles ?? const SizedBox(),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: const Text(
              'Sub Total',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: widget.subTotal,
          ),
        ],
      ),
    );
  }
}

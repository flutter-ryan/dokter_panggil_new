import 'package:flutter/material.dart';

class Cardtagihan extends StatefulWidget {
  const Cardtagihan({
    super.key,
    this.title,
    this.tiles,
    this.subTotal,
    this.buttonDetail,
    this.transportWidget,
  });

  final String? title;
  final Iterable<Widget>? tiles;
  final Widget? subTotal;
  final Widget? buttonDetail;
  final Widget? transportWidget;

  @override
  State<Cardtagihan> createState() => _CardtagihanState();
}

class _CardtagihanState extends State<Cardtagihan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
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
                    '${widget.title}',
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              widget.buttonDetail ?? const SizedBox()
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Divider(
            height: 0.0,
            color: Colors.grey[400],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: ListTile.divideTiles(
                context: context,
                tiles: widget.tiles!,
              ).toList(),
            ),
          ),
          widget.transportWidget ?? const SizedBox(),
          Divider(
            color: Colors.grey[400],
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 0),
            dense: true,
            visualDensity: VisualDensity.compact,
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

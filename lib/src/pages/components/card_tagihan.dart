import 'package:flutter/material.dart';

class Cardtagihan extends StatefulWidget {
  const Cardtagihan({
    Key? key,
    this.title,
    this.tiles,
    this.subTotal,
    this.buttonDetail,
    this.transportWidget,
  }) : super(key: key);

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
                    '${widget.title}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
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
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 18.0),
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

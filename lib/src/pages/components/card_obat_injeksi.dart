import 'package:flutter/material.dart';

class CardObatInjeksi extends StatefulWidget {
  const CardObatInjeksi({
    super.key,
    required this.title,
    this.tiles,
    this.subTotal,
    this.buttonDetail,
  });

  final String title;
  final Widget? tiles;
  final Widget? subTotal;
  final Widget? buttonDetail;

  @override
  State<CardObatInjeksi> createState() => _CardObatInjeksiState();
}

class _CardObatInjeksiState extends State<CardObatInjeksi> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Column(
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
                        widget.title,
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
              const Divider(
                height: 0.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                child: widget.tiles ?? const SizedBox(),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
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
        ],
      ),
    );
  }
}

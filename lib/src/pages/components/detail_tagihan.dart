import 'package:flutter/material.dart';

class Detailtagihan extends StatelessWidget {
  const Detailtagihan({
    super.key,
    this.namaTagihan,
    this.tarifTagihan,
    this.tanggalTagihan,
    this.subTagihan,
    this.onTap,
    this.contentPadding = EdgeInsets.zero,
  });

  final Widget? namaTagihan;
  final Widget? tarifTagihan;
  final Widget? tanggalTagihan;
  final Widget? subTagihan;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: contentPadding,
      dense: true,
      visualDensity: VisualDensity.compact,
      title: namaTagihan,
      subtitle: subTagihan,
      trailing: tarifTagihan,
      leading: tanggalTagihan,
    );
  }
}

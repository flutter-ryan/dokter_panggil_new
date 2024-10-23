import 'package:flutter/material.dart';

class Detailtagihan extends StatelessWidget {
  const Detailtagihan({
    Key? key,
    this.namaTagihan,
    this.tarifTagihan,
    this.subTagihan,
    this.onTap,
    this.contentPadding = EdgeInsets.zero,
  }) : super(key: key);

  final Widget? namaTagihan;
  final Widget? tarifTagihan;
  final Widget? subTagihan;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: contentPadding,
      dense: true,
      title: namaTagihan,
      subtitle: subTagihan,
      trailing: tarifTagihan,
    );
  }
}

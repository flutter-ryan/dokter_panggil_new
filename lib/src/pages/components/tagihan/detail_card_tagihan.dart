import 'package:flutter/material.dart';

class DetailCardTagihan extends StatelessWidget {
  const DetailCardTagihan({
    super.key,
    this.tanggal,
    this.petugas,
    this.tarif,
    this.deskripsi,
  });

  final String? tanggal;
  final String? petugas;
  final String? tarif;
  final Widget? deskripsi;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
          child: Text(
            '$tanggal',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(padding: const EdgeInsets.all(8.0), child: deskripsi),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$petugas',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
          child: Text(
            '$tarif',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

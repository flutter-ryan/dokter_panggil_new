import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/pages/pasien/resume_pemeriksaan_pasien_page.dart';
import 'package:flutter/material.dart';

class ResumeResep extends StatelessWidget {
  const ResumeResep({
    super.key,
    required this.data,
  });

  final List<Resep> data;

  @override
  Widget build(BuildContext context) {
    return CardResumeWidget(
      title: 'Resep',
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: data
              .map(
                (resep) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text('${resep.barang}'),
                  subtitle: Text('${resep.jumlah} buah - ${resep.aturanPakai}'),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

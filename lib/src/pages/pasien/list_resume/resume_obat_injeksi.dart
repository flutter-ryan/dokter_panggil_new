import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/resume_pemeriksaan_pasien_page.dart';
import 'package:flutter/material.dart';

class ResumeObatInjeksi extends StatelessWidget {
  const ResumeObatInjeksi({
    super.key,
    required this.data,
  });

  final List<KunjunganObatInjeksi> data;

  @override
  Widget build(BuildContext context) {
    return CardResumeWidget(
      title: 'Obat Injeksi',
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: data
              .map(
                (injeksi) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text('${injeksi.barang!.namaBarang}'),
                  subtitle: Text('${injeksi.jumlah} buah'),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

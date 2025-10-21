import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/resume_pemeriksaan_pasien_page.dart';
import 'package:flutter/material.dart';

class ResumeBhp extends StatelessWidget {
  const ResumeBhp({
    super.key,
    required this.data,
  });

  final List<Bhp> data;

  @override
  Widget build(BuildContext context) {
    return CardResumeWidget(
      title: 'Bhp',
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: data
              .map(
                (bhp) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text('${bhp.barang}'),
                  subtitle: Text('${bhp.jumlah} buah'),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

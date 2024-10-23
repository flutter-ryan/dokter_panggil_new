import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/pages/pasien/resume_pemeriksaan_pasien_page.dart';
import 'package:flutter/material.dart';

class ResumeTindakan extends StatelessWidget {
  const ResumeTindakan({
    super.key,
    required this.data,
  });

  final List<Tindakan> data;

  @override
  Widget build(BuildContext context) {
    return CardResumeWidget(
      title: 'Tindakan',
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: data
              .map(
                (tindakan) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text('${tindakan.namaTindakan}'),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

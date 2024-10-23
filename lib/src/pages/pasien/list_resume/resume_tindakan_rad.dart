import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/pages/pasien/resume_pemeriksaan_pasien_page.dart';
import 'package:flutter/material.dart';

class ResumeTindakanRad extends StatelessWidget {
  const ResumeTindakanRad({
    super.key,
    required this.data,
  });

  final List<TindakanRad> data;

  @override
  Widget build(BuildContext context) {
    return CardResumeWidget(
      title: 'Tindakan Radiologi',
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: data
              .map(
                (tindakanRad) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text('${tindakanRad.tindakanRad}'),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

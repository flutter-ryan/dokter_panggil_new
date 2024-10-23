import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/pages/pasien/resume_pemeriksaan_pasien_page.dart';
import 'package:flutter/material.dart';

class ResumeTindakanLab extends StatelessWidget {
  const ResumeTindakanLab({
    super.key,
    required this.data,
  });

  final List<TindakanLab> data;

  @override
  Widget build(BuildContext context) {
    return CardResumeWidget(
      title: 'Tindakan Laboratorium',
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: data
              .map(
                (tindakanLab) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text('${tindakanLab.tindakanLab}'),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

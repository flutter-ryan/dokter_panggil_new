import 'package:admin_dokter_panggil/src/models/resume_pemeriksaan_pasien_model.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/resume_pemeriksaan_pasien_page.dart';
import 'package:flutter/material.dart';

class ResumeDiagnosaPerawat extends StatelessWidget {
  const ResumeDiagnosaPerawat({
    super.key,
    required this.data,
  });

  final List<DiagnosaPerawat> data;

  @override
  Widget build(BuildContext context) {
    return CardResumeWidget(
      title: 'Diagnosa',
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data
              .map((diagnosa) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Diagnosa',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.0,
                        ),
                      ),
                      const SizedBox(
                        height: 18.0,
                      ),
                      const Text(
                        'Catatan diagnosa',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.0,
                        ),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text('${diagnosa.catatanDiagnosa}'),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
}

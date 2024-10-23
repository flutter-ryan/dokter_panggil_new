import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/pages/pasien/resume_pemeriksaan_pasien_page.dart';
import 'package:flutter/material.dart';

class ResumeResepRacikan extends StatelessWidget {
  const ResumeResepRacikan({
    super.key,
    required this.data,
  });

  final List<ResepRacikan> data;

  @override
  Widget build(BuildContext context) {
    return CardResumeWidget(
      title: 'Resep Racikan',
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: ListTile.divideTiles(
                context: context,
                tiles: data
                    .map(
                      (resep) => Column(
                        children: [
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text('${resep.petunjuk}'),
                            subtitle: Text('${resep.aturanPakai}'),
                          ),
                          Column(
                            children: resep.barang!
                                .map(
                                  (barang) => Row(
                                    children: [
                                      const Icon(Icons.arrow_right),
                                      const SizedBox(
                                        width: 12.0,
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          dense: true,
                                          title: Text('${barang.barang}'),
                                          subtitle: Text(
                                              '${barang.jumlah!.jumlah} buah'),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          )
                        ],
                      ),
                    )
                    .toList(),
              ).toList(),
            ),
            const SizedBox(
              height: 12.0,
            ),
          ],
        ),
      ),
    );
  }
}

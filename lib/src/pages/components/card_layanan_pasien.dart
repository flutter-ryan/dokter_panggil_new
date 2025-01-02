import 'package:dokter_panggil/src/models/pasien_kunjungan_model.dart';
import 'package:dokter_panggil/src/pages/pasien/detail_layanan_page.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';

class CardLayananPasien extends StatelessWidget {
  const CardLayananPasien({
    super.key,
    required this.kunjungan,
    this.type = 'create',
  });

  final KunjunganPasien kunjungan;
  final String type;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          SlideLeftRoute(
            page: DetailLayananPage(
              id: kunjungan.id!,
              type: type,
            ),
          )),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.5, color: kPrimaryColor),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 18,
              dense: true,
              title: Text(
                '#${kunjungan.nomorRegistrasi}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('${kunjungan.tanggal}'),
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color:
                      kunjungan.status == 5 ? Colors.green : Colors.orange[200],
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: kunjungan.status == 5
                    ? const Text(
                        'Final',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      )
                    : const Text(
                        'Sedang dilayani',
                        style: TextStyle(fontSize: 10),
                      ),
              ),
            ),
            Divider(
              height: 0.0,
              color: Colors.grey[400],
            ),
            const SizedBox(
              height: 12.0,
            ),
            const Text(
              'Layanan',
              style: TextStyle(color: Colors.grey, fontSize: 11.0),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: kunjungan.layanan!
                  .map(
                    (layanan) => Text(
                      '${layanan.namaLayanan}',
                      style: const TextStyle(fontSize: 13.0),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(
              height: 12.0,
            ),
            const Text(
              'Tanggal',
              style: TextStyle(color: Colors.grey, fontSize: 11.0),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text(
              '${kunjungan.tanggal}',
              style: const TextStyle(fontSize: 13.0),
            ),
            const SizedBox(
              height: 12.0,
            ),
            const Text(
              'Keluhan',
              style: TextStyle(color: Colors.grey, fontSize: 11.0),
            ),
            const SizedBox(
              height: 4.0,
            ),
            if (kunjungan.keluhan != null)
              Text(
                '${kunjungan.keluhan}',
                style: const TextStyle(fontSize: 13.0),
              )
            else
              const Text(
                'Tidak ada',
                style: TextStyle(fontSize: 13.0),
              ),
            const SizedBox(
              height: 18.0,
            )
          ],
        ),
      ),
    );
  }
}

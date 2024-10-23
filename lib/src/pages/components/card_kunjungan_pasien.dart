import 'package:dokter_panggil/src/models/pendaftaran_kunjungan_save_model.dart';
import 'package:dokter_panggil/src/pages/pasien/detail_layanan_page.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';

class CardKunjunganPasien extends StatefulWidget {
  const CardKunjunganPasien({
    Key? key,
    required this.kunjungan,
    this.type = 'create',
    this.reload,
  }) : super(key: key);

  final Kunjungan kunjungan;
  final String type;
  final Function(Kunjungan data)? reload;

  @override
  State<CardKunjunganPasien> createState() => _CardKunjunganPasienState();
}

class _CardKunjunganPasienState extends State<CardKunjunganPasien> {
  void _pilihKunjungan() {
    Navigator.push(
      context,
      SlideLeftRoute(
        page: DetailLayananPage(
          id: widget.kunjungan.id!,
          type: widget.type,
        ),
      ),
    ).then((value) {
      if (value != null) {
        var data = value as Kunjungan;
        widget.reload!(data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pilihKunjungan,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        decoration: BoxDecoration(
          color: kPrimaryColor.withAlpha(8),
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
                '#${widget.kunjungan.nomorRegistrasi}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                  '${widget.kunjungan.namaPasien} / ${widget.kunjungan.normSprint}'),
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: widget.kunjungan.status == 5
                      ? Colors.green
                      : Colors.orange[200],
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: widget.kunjungan.status == 5
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
              'Tanggal',
              style: TextStyle(color: Colors.grey, fontSize: 11.0),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text(
              '${widget.kunjungan.tanggal}',
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
            if (widget.kunjungan.keluhan != null)
              Text(
                '${widget.kunjungan.keluhan}',
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

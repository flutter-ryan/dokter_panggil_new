import 'package:admin_dokter_panggil/src/models/mr_kunjungan_pengkajian_perawat_model.dart';
import 'package:admin_dokter_panggil/src/models/pasien_show_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_card_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/deskripsi_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/inline_deskripsi_widget.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/barang_habis_pakai_lab.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/resep_card_widget.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PengkajianPerawatForm extends StatefulWidget {
  const PengkajianPerawatForm({
    super.key,
    this.idKunjungan,
    this.data,
    required this.pasien,
    this.isPerawat = false,
  });

  final int? idKunjungan;
  final MrKunjunganPengkajianPerawat? data;
  final Pasien pasien;
  final bool isPerawat;

  @override
  State<PengkajianPerawatForm> createState() => _PengkajianPerawatFormState();
}

class _PengkajianPerawatFormState extends State<PengkajianPerawatForm> {
  MrKunjunganPengkajianPerawat? _kunjunganPengkajianPerawat;
  SkorResikoJatuh? skorResikoJatuh;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _kunjunganPengkajianPerawat = widget.data!;
    if (_kunjunganPengkajianPerawat?.pengkajianPerawat != null) {
      _skoringResikoJatuh(null);
    }
  }

  void _skoringResikoJatuh(List<ResikoJatuh>? dataResikoJatuh) {
    List<ResikoJatuh> resikoJatuh = [];
    if (dataResikoJatuh != null) {
      resikoJatuh = dataResikoJatuh;
    } else {
      resikoJatuh =
          _kunjunganPengkajianPerawat!.pengkajianPerawat!.resikoJatuh!;
    }
    int skor = 0;
    String? tingkatResiko;
    int? colorResiko;
    for (var resiko in resikoJatuh) {
      skor += resiko.skala!;
    }
    if (skor >= 51) {
      tingkatResiko = 'Resiko tinggi';
      colorResiko = 0xFFEC5858;
    } else if (skor >= 25 && skor <= 50) {
      tingkatResiko = 'Resiko rendah';
      colorResiko = 0xFFFD8C04;
    } else {
      tingkatResiko = 'Tidak beresiko';
      colorResiko = 0xFF93ABD3;
    }
    skorResikoJatuh = SkorResikoJatuh(
      total: skor,
      tingkatResiko: tingkatResiko,
      colorResiko: colorResiko,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final selesaiPengkajian = _kunjunganPengkajianPerawat!
        .pengkajianPerawat!.selesaiPengkajianPerawat;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              DashboardCardWidget(
                title: 'Tanggal Pengkajian',
                errorMessage: 'Data keluhan utama tidak tersedia',
                dataCard: _kunjunganPengkajianPerawat!.pengkajianPerawat == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22.0, vertical: 8),
                        child: ListTile(
                          visualDensity: VisualDensity.compact,
                          contentPadding: EdgeInsets.zero,
                          minLeadingWidth: 12,
                          leading: SvgPicture.asset('images/calendar.svg'),
                          title: Text(
                            '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tanggalPengkajian}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
              ),
              Divider(
                color: Colors.grey[200],
                thickness: 5,
                height: 5,
              ),
              DashboardCardWidget(
                title: 'Keluhan utama',
                errorMessage: 'Data keluhan utama tidak tersedia',
                dataCard: _kunjunganPengkajianPerawat!
                            .pengkajianPerawat!.keluhanUtama ==
                        null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Text(
                            '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.keluhanUtama!.keluhanUtama}'),
                      ),
              ),
              Divider(
                color: Colors.grey[200],
                thickness: 5,
                height: 5,
              ),
              DashboardCardWidget(
                title: 'Tanda-tanda vital',
                errorMessage: 'Data tanda vital tidak tersedia',
                dataCard: _kunjunganPengkajianPerawat!
                            .pengkajianPerawat!.tandaVital ==
                        null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pemeriksaan GCS',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: DeskripsiWidget(
                                  title: 'Eye',
                                  body: Text(
                                      '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.gcs!.firstWhere((gcs) => gcs.jenisGcs == 'eye').gcs}'),
                                )),
                                Expanded(
                                    child: DeskripsiWidget(
                                  title: 'Verbal',
                                  body: Text(
                                      '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.gcs!.firstWhere((gcs) => gcs.jenisGcs == 'verbal').gcs}'),
                                ))
                              ],
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            DeskripsiWidget(
                              title: 'Motorik',
                              body: Text(
                                  '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.gcs!.firstWhere((gcs) => gcs.jenisGcs == 'motorik').gcs}'),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(int.parse(
                                    _kunjunganPengkajianPerawat!
                                        .pengkajianPerawat!
                                        .tandaVital!
                                        .colorGcs!
                                        .body!)),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'GCS Score',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.scoreGcs}',
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Divider(
                              color: Colors.grey[400],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'Pemeriksaan Fisik',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: DeskripsiWidget(
                                  title: 'Td Sistolik',
                                  body: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    color: Color(int.parse(
                                        _kunjunganPengkajianPerawat!
                                            .pengkajianPerawat!
                                            .tandaVital!
                                            .colorSistolik!
                                            .body!)),
                                    child: Text(
                                      _kunjunganPengkajianPerawat!
                                                  .pengkajianPerawat!
                                                  .tandaVital!
                                                  .tdSistolik ==
                                              null
                                          ? '-'
                                          : '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.tdSistolik} mmHg',
                                      style: TextStyle(
                                          color: Color(int.parse(
                                              _kunjunganPengkajianPerawat!
                                                  .pengkajianPerawat!
                                                  .tandaVital!
                                                  .colorSistolik!
                                                  .text!))),
                                    ),
                                  ),
                                )),
                                Expanded(
                                    child: DeskripsiWidget(
                                  title: 'Td Diastolik',
                                  body: Text(_kunjunganPengkajianPerawat!
                                              .pengkajianPerawat!
                                              .tandaVital!
                                              .tdDiastolik ==
                                          null
                                      ? '-'
                                      : '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.tdDiastolik} mmHg'),
                                )),
                                Expanded(
                                    child: DeskripsiWidget(
                                  title: 'Nadi',
                                  body: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    color: Color(int.parse(
                                        _kunjunganPengkajianPerawat!
                                            .pengkajianPerawat!
                                            .tandaVital!
                                            .colorNadi!
                                            .body!)),
                                    child: Text(
                                      '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.nadi} x/menit',
                                      style: TextStyle(
                                          color: Color(int.parse(
                                              _kunjunganPengkajianPerawat!
                                                  .pengkajianPerawat!
                                                  .tandaVital!
                                                  .colorNadi!
                                                  .text!))),
                                    ),
                                  ),
                                ))
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: DeskripsiWidget(
                                  title: 'Pernapasan',
                                  body: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    color: Color(int.parse(
                                        _kunjunganPengkajianPerawat!
                                            .pengkajianPerawat!
                                            .tandaVital!
                                            .colorPernapasan!
                                            .body!)),
                                    child: Text(
                                      '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.pernapasan} x/menit',
                                      style: TextStyle(
                                          color: Color(int.parse(
                                              _kunjunganPengkajianPerawat!
                                                  .pengkajianPerawat!
                                                  .tandaVital!
                                                  .colorPernapasan!
                                                  .text!))),
                                    ),
                                  ),
                                )),
                                Expanded(
                                    child: DeskripsiWidget(
                                  title: 'Suhu',
                                  body: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    color: Color(int.parse(
                                        _kunjunganPengkajianPerawat!
                                            .pengkajianPerawat!
                                            .tandaVital!
                                            .colorSuhu!
                                            .body!)),
                                    child: Text(
                                      '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.suhu} C',
                                      style: TextStyle(
                                          color: Color(int.parse(
                                              _kunjunganPengkajianPerawat!
                                                  .pengkajianPerawat!
                                                  .tandaVital!
                                                  .colorSuhu!
                                                  .text!))),
                                    ),
                                  ),
                                )),
                                Expanded(
                                  child: DeskripsiWidget(
                                    title: 'Saturasi Oksigen',
                                    body: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      color: Color(int.parse(
                                          _kunjunganPengkajianPerawat!
                                              .pengkajianPerawat!
                                              .tandaVital!
                                              .colorOksigen!
                                              .body!)),
                                      child: Text(
                                        '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.saturasiOksigen} %',
                                        style: TextStyle(
                                            color: Color(int.parse(
                                                _kunjunganPengkajianPerawat!
                                                    .pengkajianPerawat!
                                                    .tandaVital!
                                                    .colorOksigen!
                                                    .text!))),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: DeskripsiWidget(
                                    title: 'Kesadaran',
                                    body: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      color: Color(int.parse(
                                          _kunjunganPengkajianPerawat!
                                              .pengkajianPerawat!
                                              .tandaVital!
                                              .colorKesadaran!
                                              .body!)),
                                      child: Text(
                                        '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.kesadaran}',
                                        style: TextStyle(
                                            color: Color(int.parse(
                                                _kunjunganPengkajianPerawat!
                                                    .pengkajianPerawat!
                                                    .tandaVital!
                                                    .colorKesadaran!
                                                    .text!))),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: DeskripsiWidget(
                                    title: 'Nyeri',
                                    body: Text(
                                        '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.nyeri}'),
                                  ),
                                ),
                                if (_kunjunganPengkajianPerawat!
                                        .pengkajianPerawat!.tandaVital!.nyeri ==
                                    'Ya')
                                  Expanded(
                                      child: DeskripsiWidget(
                                    title: 'Skala Nyeri',
                                    body: Text(
                                        '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.skalaNyeri}'),
                                  ))
                                else
                                  const Expanded(
                                    child: SizedBox(),
                                  ),
                              ],
                            ),
                            if (_kunjunganPengkajianPerawat!
                                    .pengkajianPerawat!.tandaVital!.nyeri ==
                                'Ya')
                              const SizedBox(
                                height: 12.0,
                              ),
                            if (_kunjunganPengkajianPerawat!
                                    .pengkajianPerawat!.tandaVital!.nyeri ==
                                'Ya')
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: DeskripsiWidget(
                                      title: 'Pencetus Nyeri',
                                      body: Text(
                                          '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.pencetusNyeri}'),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  Expanded(
                                    child: DeskripsiWidget(
                                      title: 'Gambaran Nyeri',
                                      body: Text(
                                          '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.gambaranNyeri}'),
                                    ),
                                  ),
                                ],
                              ),
                            if (_kunjunganPengkajianPerawat!
                                    .pengkajianPerawat!.tandaVital!.nyeri ==
                                'Ya')
                              const SizedBox(
                                height: 12.0,
                              ),
                            if (_kunjunganPengkajianPerawat!
                                    .pengkajianPerawat!.tandaVital!.nyeri ==
                                'Ya')
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: DeskripsiWidget(
                                      title: 'Lokasi Nyeri',
                                      body: Text(
                                          '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.lokasiNyeri}'),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  Expanded(
                                    child: DeskripsiWidget(
                                      title: 'Durasi Nyeri',
                                      body: Text(
                                          '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.durasiNyeri}'),
                                    ),
                                  )
                                ],
                              ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: DeskripsiWidget(
                                    title: 'BAB',
                                    body: Text(
                                        '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.bab}'),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12.0,
                                ),
                                Expanded(
                                  child: DeskripsiWidget(
                                    title: 'BAK',
                                    body: Text(
                                        '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.bak}'),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Color(int.parse(
                                    _kunjunganPengkajianPerawat!
                                        .pengkajianPerawat!
                                        .tandaVital!
                                        .colorSkor!
                                        .body!)),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'MEWS Score',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15.0,
                                          color: Color(
                                            int.parse(
                                              _kunjunganPengkajianPerawat!
                                                  .pengkajianPerawat!
                                                  .tandaVital!
                                                  .colorSkor!
                                                  .text!,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 18,
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'Skor: ${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.score}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Color(
                                                int.parse(
                                                  _kunjunganPengkajianPerawat!
                                                      .pengkajianPerawat!
                                                      .tandaVital!
                                                      .colorSkor!
                                                      .text!,
                                                ),
                                              ),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.penilaian!.frekuensi}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(
                                          int.parse(
                                            _kunjunganPengkajianPerawat!
                                                .pengkajianPerawat!
                                                .tandaVital!
                                                .colorSkor!
                                                .text!,
                                          ),
                                        ),
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Divider(
                              color: Colors.grey[400],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'Balance Cairan',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: DeskripsiWidget(
                                    title: 'Input Oral',
                                    body: Text(
                                        '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.cairanInputOral}'),
                                  ),
                                ),
                                Expanded(
                                  child: DeskripsiWidget(
                                    title: 'Input Parenteral',
                                    body: Text(
                                        '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.cairanInputParenteral}'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: DeskripsiWidget(
                                    title: 'Output Kemih',
                                    body: Text(
                                        '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.cairanOutputKemih}'),
                                  ),
                                ),
                                Expanded(
                                  child: DeskripsiWidget(
                                    title: 'Output Muntah',
                                    body: Text(
                                        '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.cairanOutputMuntah}'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 12),
                              decoration: BoxDecoration(
                                color: kSecondaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    children: [
                                      Text(
                                        'Total Input',
                                        style:
                                            TextStyle(color: Colors.grey[100]),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${int.parse(_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.cairanInputOral!) + int.parse(_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.cairanInputParenteral!)} cc',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  )),
                                  Expanded(
                                      child: Column(
                                    children: [
                                      Text(
                                        'Total Output',
                                        style:
                                            TextStyle(color: Colors.grey[100]),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${int.parse(_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.cairanOutputMuntah!) + int.parse(_kunjunganPengkajianPerawat!.pengkajianPerawat!.tandaVital!.cairanOutputKemih!)} cc',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              Divider(
                color: Colors.grey[200],
                thickness: 5,
                height: 5,
              ),
              DashboardCardWidget(
                title: 'Nutrisi',
                errorMessage: 'Data nutrisi tidak tersedia',
                dataCard: _kunjunganPengkajianPerawat!
                            .pengkajianPerawat!.nutrisi ==
                        null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: DeskripsiWidget(
                                    title: 'Tingg Badan',
                                    body: Text(
                                        '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.nutrisi!.tinggiBadan}'),
                                  ),
                                ),
                                Expanded(
                                    child: DeskripsiWidget(
                                  title: 'Berat Badan ',
                                  body: Text(
                                      '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.nutrisi!.beratBadan}'),
                                ))
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 18),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Color(int.parse(
                                        '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.nutrisi!.colorStatus}')),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Status gizi',
                                      style: TextStyle(color: Colors.grey[100]),
                                    ),
                                    Text(
                                      '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.nutrisi!.statusGizi} - Imt: ${_kunjunganPengkajianPerawat!.pengkajianPerawat!.nutrisi!.imt}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
              ),
              Divider(
                color: Colors.grey[200],
                thickness: 5,
                height: 5,
              ),
              DashboardCardWidget(
                title: 'Skrining Gizi',
                errorMessage: 'Data skrining gizi tidak tersedia',
                dataCard: _kunjunganPengkajianPerawat!
                        .pengkajianPerawat!.skriningGizi!.isEmpty
                    ? null
                    : Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _kunjunganPengkajianPerawat!
                                  .pengkajianPerawat!.skriningGizi!
                                  .map((gizi) {
                                var jawabanSplit = gizi.jawaban!.split('-');
                                if (jawabanSplit.length > 1) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: DeskripsiWidget(
                                      title: '${gizi.pertanyaan}',
                                      body: Text(
                                          '${jawabanSplit.first}, ${jawabanSplit.last}'),
                                    ),
                                  );
                                }
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: DeskripsiWidget(
                                    title: '${gizi.pertanyaan}',
                                    body: Text(jawabanSplit.first),
                                  ),
                                );
                              }).toList(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _kunjunganPengkajianPerawat!
                                              .pengkajianPerawat!.mstSkor! >
                                          1
                                      ? Colors.red
                                      : kGreenColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Malnutrition screening tool',
                                      style: TextStyle(color: Colors.grey[100]),
                                    ),
                                    Text(
                                      '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.mst} - skor: ${_kunjunganPengkajianPerawat!.pengkajianPerawat!.mstSkor}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
              ),
              Divider(
                color: Colors.grey[200],
                thickness: 5,
                height: 5,
              ),
              DashboardCardWidget(
                title: 'Skrining Psikososial/Spiritual',
                errorMessage: 'Data pengkajian tidak tersedia',
                dataCard: _kunjunganPengkajianPerawat!
                            .pengkajianPerawat!.skriningPsikososial ==
                        null
                    ? null
                    : _skriningPsikososialWidget(
                        context,
                        _kunjunganPengkajianPerawat!
                            .pengkajianPerawat!.skriningPsikososial!),
              ),
              Divider(
                color: Colors.grey[200],
                thickness: 5,
                height: 5,
              ),
              DashboardCardWidget(
                title: 'Resiko Jatuh',
                errorMessage: 'Data resiko jatuh tidak tersedia',
                dataCard: _kunjunganPengkajianPerawat!
                        .pengkajianPerawat!.resikoJatuh!.isEmpty
                    ? null
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _kunjunganPengkajianPerawat!
                                  .pengkajianPerawat!.resikoJatuh!
                                  .map(
                                    (resikoJatuh) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: DeskripsiWidget(
                                        title: resikoJatuh.pertanyaan,
                                        body: Text('${resikoJatuh.jawaban}'),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                18.0, 0.0, 18.0, 18.0),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(skorResikoJatuh!.colorResiko!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Skala Morse',
                                    style: TextStyle(color: Colors.grey[100]),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${skorResikoJatuh!.tingkatResiko}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      const Text(
                                        '-',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Text(
                                        'Skor: ${skorResikoJatuh!.total}',
                                        style: TextStyle(
                                            color: Colors.grey[100],
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
              ),
              Divider(
                color: Colors.grey[200],
                thickness: 5,
                height: 5,
              ),
              DashboardCardWidget(
                title: 'Tindakan Perawat',
                errorMessage: 'Data tindakan perawat tidak tersedia',
                dataCard: _kunjunganPengkajianPerawat!
                        .pengkajianPerawat!.tindakanPerawat!.isEmpty
                    ? null
                    : Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 18,
                        ),
                        child: Column(
                          children: _kunjunganPengkajianPerawat!
                              .pengkajianPerawat!.tindakanPerawat!
                              .map(
                                (tindakanPerawat) => ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  leading: const Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                  ),
                                  title: Text(
                                    '${tindakanPerawat.namaTindakan}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  horizontalTitleGap: 12,
                                  minLeadingWidth: 12,
                                ),
                              )
                              .toList(),
                        ),
                      ),
              ),
              Divider(
                color: Colors.grey[200],
                thickness: 5,
                height: 5,
              ),
              DashboardCardWidget(
                title: 'Barang Habis Pakai (BHP)',
                isBhp: true,
                errorMessage: 'Data barang habis pakai tidak tersedia',
                dataCard: _kunjunganPengkajianPerawat!
                        .pengkajianPerawat!.bhp!.isEmpty
                    ? null
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 18),
                        child: Column(
                          children: _kunjunganPengkajianPerawat!
                              .pengkajianPerawat!.bhp!
                              .map((bhp) => ResepCardWidget(
                                    title: '${bhp.tanggalBhp}',
                                    dataResep: Column(
                                      children: bhp.kunjunganBhp!
                                          .map(
                                            (kunjunganBhp) => ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              dense: true,
                                              title: Text(
                                                  '${kunjunganBhp.barang!.namaBarang}'),
                                              subtitle: Text(
                                                  '${kunjunganBhp.jumlah} Pcs'),
                                              leading: const Icon(
                                                  Icons.arrow_right_rounded),
                                              minLeadingWidth: 8,
                                              horizontalTitleGap: 8,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
              ),
              BarangHabisPakaiLab(
                idKunjungan: widget.idKunjungan,
                isEdit: _isEdit,
                selesaiPengkajian: selesaiPengkajian,
              ),
              Divider(
                color: Colors.grey[200],
                thickness: 5,
                height: 5,
              ),
              DashboardCardWidget(
                title: 'Diagnosa Perawat',
                errorMessage: 'Data diagnosa tidak tersedia',
                dataCard: _kunjunganPengkajianPerawat!
                        .pengkajianPerawat!.diagnosaPerawat!.isEmpty
                    ? null
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: _kunjunganPengkajianPerawat!
                              .pengkajianPerawat!.diagnosaPerawat!
                              .map(
                                (diagnosaPerawat) => ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  leading: const Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                  ),
                                  title:
                                      Text('${diagnosaPerawat.namaDiagnosa}'),
                                  horizontalTitleGap: 12,
                                  minLeadingWidth: 12,
                                ),
                              )
                              .toList(),
                        ),
                      ),
              ),
              Divider(
                color: Colors.grey[200],
                thickness: 5,
                height: 5,
              ),
              DashboardCardWidget(
                title: 'Rencana keperawatan',
                errorMessage: 'Data rencana keperawatan tidak tersedia',
                dataCard: _kunjunganPengkajianPerawat!
                        .pengkajianPerawat!.diagnosaTindakanPerawat!.isEmpty
                    ? null
                    : Column(
                        children: _kunjunganPengkajianPerawat!
                            .pengkajianPerawat!.diagnosaTindakanPerawat!
                            .map(
                              (diagnosaTindakan) => ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                leading: const Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                ),
                                title: Text(
                                    '${diagnosaTindakan.diagnosaTindakan}'),
                                subtitle: Text(
                                  '${diagnosaTindakan.diagnosa}',
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                                horizontalTitleGap: 12,
                                minLeadingWidth: 12,
                              ),
                            )
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
        if (!_isEdit &&
            _kunjunganPengkajianPerawat!
                    .pengkajianPerawat!.selesaiPengkajianPerawat !=
                null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 6, offset: Offset(0, -4))
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      '${_kunjunganPengkajianPerawat!.pengkajianPerawat!.selesaiPengkajianPerawat!.namaPegawai}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    isThreeLine: _kunjunganPengkajianPerawat!
                        .pengkajianPerawat!.selesaiPengkajianPerawat!.isUpdate!,
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Simpan: ${_kunjunganPengkajianPerawat!.pengkajianPerawat!.selesaiPengkajianPerawat!.createdAt}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 13),
                          ),
                          if (_kunjunganPengkajianPerawat!.pengkajianPerawat!
                              .selesaiPengkajianPerawat!.isUpdate!)
                            Text(
                              'Update: ${_kunjunganPengkajianPerawat!.pengkajianPerawat!.selesaiPengkajianPerawat!.updatedAt}',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.isPerawat)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEdit = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreenColor,
                      elevation: 0,
                    ),
                    child: const Text('Edit'),
                  )
              ],
            ),
          ),
      ],
    );
  }

  Widget _skriningPsikososialWidget(
      BuildContext context, SkriningPsikososial data) {
    if (data.sebutkanKondisiLain != null) {
      if (!data.kondisiPsikologis!.contains(data.sebutkanKondisiLain)) {
        data.kondisiPsikologis!.add(data.sebutkanKondisiLain!);
      }
    }
    List<String> kondisiPsikologis =
        data.kondisiPsikologis!.where((e) => e != 'Lain-lain').toList();
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          InlineDeskripsiWidget(
            title: 'Kondisi Posikologis',
            body: Text(kondisiPsikologis.join(', ')),
          ),
          const SizedBox(
            height: 12,
          ),
          if (data.sebutkanMasalahperilaku != null)
            InlineDeskripsiWidget(
              title: 'Status mental',
              body:
                  Text('${data.statusMental}, ${data.sebutkanMasalahperilaku}'),
            )
          else if (data.sebutkanPerilakuKekerasan != null)
            InlineDeskripsiWidget(
              title: 'Status mental',
              body: Text(
                  '${data.statusMental}, ${data.sebutkanPerilakuKekerasan}'),
            )
          else
            InlineDeskripsiWidget(
              title: 'Status mental',
              body: Text('${data.statusMental}'),
            ),
          const SizedBox(
            height: 12,
          ),
          InlineDeskripsiWidget(
            title: 'Hubungan pasien dengan anggota keluarga',
            body: Text('${data.sosialHubunganPasien}'),
          ),
          const SizedBox(
            height: 12,
          ),
          if (data.sosialTempatTinggal != 'Lain-lain')
            InlineDeskripsiWidget(
              title: 'Tempat tinggal',
              body: Text('${data.sosialTempatTinggal}'),
            )
          else
            InlineDeskripsiWidget(
              title: 'Tempat tinggal',
              body: Text('${data.sebutkanTempatTinggalLain}'),
            ),
          const SizedBox(
            height: 12,
          ),
          InlineDeskripsiWidget(
            title: 'Kebiasaan beribadah',
            body: Text('${data.kebiasaanBeribadahTeratur}'),
          ),
          const SizedBox(
            height: 12,
          ),
          InlineDeskripsiWidget(
            title: 'Pengambil keputusan dalam keluarga',
            body: Text('${data.pengambilKeputusanKeluarga}'),
          )
        ],
      ),
    );
  }
}

class SkorResikoJatuh {
  int? total;
  String? tingkatResiko;
  int? colorResiko;

  SkorResikoJatuh({
    this.total,
    this.tingkatResiko,
    this.colorResiko,
  });
}

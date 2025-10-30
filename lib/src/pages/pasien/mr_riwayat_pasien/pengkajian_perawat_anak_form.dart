import 'package:admin_dokter_panggil/src/models/mr_kunjungan_pengkajian_perawat_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_pengkajian_perawat_anak_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_detail_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_card_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/deskripsi_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/inline_deskripsi_widget.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/barang_habis_pakai_lab.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/resep_card_widget.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PengkajianPerawatAnakForm extends StatefulWidget {
  const PengkajianPerawatAnakForm({
    super.key,
    this.idKunjungan,
    this.data,
    required this.pasien,
    this.isPerawat = false,
  });

  final int? idKunjungan;
  final MrPengkajianPerawatAnak? data;
  final PasienRiwayatAdmin pasien;
  final bool isPerawat;

  @override
  State<PengkajianPerawatAnakForm> createState() =>
      _PengkajianPerawatAnakFormState();
}

class _PengkajianPerawatAnakFormState extends State<PengkajianPerawatAnakForm> {
  MrPengkajianPerawatAnak? _kunjunganPengkajianPerawat;
  SkorResikoJatuh? skorResikoJatuh;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _kunjunganPengkajianPerawat = widget.data!;
    if (_kunjunganPengkajianPerawat?.pengkajianPerawatAnak != null) {
      _skoringResikoJatuh(null);
    }
  }

  void _skoringResikoJatuh(List<ResikoJatuh>? dataResikoJatuh) {
    List<ResikoJatuh> resikoJatuh = [];
    if (dataResikoJatuh != null) {
      resikoJatuh = dataResikoJatuh;
    } else {
      resikoJatuh =
          _kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.resikoJatuh!;
    }
    int skor = 0;
    String? tingkatResiko;
    int? colorResiko;
    for (var resiko in resikoJatuh) {
      skor += resiko.skala!;
    }
    if (widget.data!.isDewasa!) {
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
    } else {
      if (skor >= 7 && skor <= 11) {
        tingkatResiko = 'Resiko rendah';
        colorResiko = 0xFFFD8C04;
      } else if (skor >= 12) {
        tingkatResiko = 'Resiko tinggi';
        colorResiko = 0xFFEC5858;
      } else {
        tingkatResiko = 'Tidak beresiko';
        colorResiko = 0xFF93ABD3;
      }
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
    final selesaiPengkajian =
        _kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.selesaiPengkajian;
    return Column(
      children: [
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              return true;
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                DashboardCardWidget(
                  title: 'Tanggal Pengkajian',
                  errorMessage: 'Data keluhan utama tidak tersedia',
                  dataCard:
                      _kunjunganPengkajianPerawat!.pengkajianPerawatAnak == null
                          ? null
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22.0, vertical: 8),
                              child: ListTile(
                                visualDensity: VisualDensity.compact,
                                contentPadding: EdgeInsets.zero,
                                minLeadingWidth: 12,
                                leading:
                                    SvgPicture.asset('images/calendar.svg'),
                                title: Text(
                                  '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tanggalPengkajian}',
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
                              .pengkajianPerawatAnak!.keluhanUtama ==
                          null
                      ? null
                      : Padding(
                          padding: const EdgeInsets.all(22.0),
                          child: Text(
                              '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.keluhanUtama!.keluhanUtama}'),
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
                              .pengkajianPerawatAnak!.tandaVital ==
                          null
                      ? null
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                    body: Text(
                                        _kunjunganPengkajianPerawat!
                                                    .pengkajianPerawatAnak!
                                                    .tandaVital!
                                                    .tdSistolik ==
                                                null
                                            ? '-'
                                            : '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.tdSistolik} mmHg',
                                        style: TextStyle(color: Colors.black)),
                                  )),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                      child: DeskripsiWidget(
                                    title: 'Td Diastolik',
                                    body: Text(_kunjunganPengkajianPerawat!
                                                .pengkajianPerawatAnak!
                                                .tandaVital!
                                                .tdDiastolik ==
                                            null
                                        ? '-'
                                        : '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.tdDiastolik} mmHg'),
                                  )),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                      child: DeskripsiWidget(
                                    title: 'Nadi',
                                    body: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      color: Color(int.parse(
                                          _kunjunganPengkajianPerawat!
                                              .pengkajianPerawatAnak!
                                              .tandaVital!
                                              .colorNadi!
                                              .body!)),
                                      child: Text(
                                        '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.nadi} x/menit',
                                        style: TextStyle(
                                            color: Color(int.parse(
                                                _kunjunganPengkajianPerawat!
                                                    .pengkajianPerawatAnak!
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
                                              .pengkajianPerawatAnak!
                                              .tandaVital!
                                              .colorPernapasan!
                                              .body!)),
                                      child: Text(
                                        '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.pernapasan} x/menit',
                                        style: TextStyle(
                                            color: Color(int.parse(
                                                _kunjunganPengkajianPerawat!
                                                    .pengkajianPerawatAnak!
                                                    .tandaVital!
                                                    .colorPernapasan!
                                                    .text!))),
                                      ),
                                    ),
                                  )),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                      child: DeskripsiWidget(
                                    title: 'Suhu',
                                    body: Text(
                                        '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.suhu} C'),
                                  )),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: DeskripsiWidget(
                                      title: 'Waktu Isi Kapiler',
                                      body: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        color: Color(
                                          int.parse(_kunjunganPengkajianPerawat!
                                              .pengkajianPerawatAnak!
                                              .tandaVital!
                                              .colorWaktuIsiKapiler!
                                              .body!),
                                        ),
                                        child: Text(
                                          '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.waktuIsiKapiler} detik',
                                          style: TextStyle(
                                            color: Color(
                                              int.parse(
                                                  _kunjunganPengkajianPerawat!
                                                      .pengkajianPerawatAnak!
                                                      .tandaVital!
                                                      .colorWaktuIsiKapiler!
                                                      .text!),
                                            ),
                                          ),
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
                                        color: Color(
                                          int.parse(_kunjunganPengkajianPerawat!
                                              .pengkajianPerawatAnak!
                                              .tandaVital!
                                              .colorKesadaran!
                                              .body!),
                                        ),
                                        child: Text(
                                          '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.kesadaran}',
                                          style: TextStyle(
                                              color: Color(int.parse(
                                                  _kunjunganPengkajianPerawat!
                                                      .pengkajianPerawatAnak!
                                                      .tandaVital!
                                                      .colorKesadaran!
                                                      .text!))),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: DeskripsiWidget(
                                      title: 'Nyeri',
                                      body: Text(
                                          '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.nyeri}'),
                                    ),
                                  ),
                                  if (_kunjunganPengkajianPerawat!
                                          .pengkajianPerawatAnak!
                                          .tandaVital!
                                          .nyeri ==
                                      'Ya')
                                    Expanded(
                                        child: Padding(
                                      padding: EdgeInsets.only(left: 12),
                                      child: DeskripsiWidget(
                                        title: 'Skala Nyeri',
                                        body: Text(
                                          '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.skalaNyeri}',
                                        ),
                                      ),
                                    ))
                                  else
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                ],
                              ),
                              if (_kunjunganPengkajianPerawat!
                                      .pengkajianPerawatAnak!
                                      .tandaVital!
                                      .nyeri ==
                                  'Ya')
                                const SizedBox(
                                  height: 12.0,
                                ),
                              if (_kunjunganPengkajianPerawat!
                                      .pengkajianPerawatAnak!
                                      .tandaVital!
                                      .nyeri ==
                                  'Ya')
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: DeskripsiWidget(
                                        title: 'Pencetus Nyeri',
                                        body: Text(
                                            '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.pencetusNyeri}'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                      child: DeskripsiWidget(
                                        title: 'Gambaran Nyeri',
                                        body: Text(
                                            '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.gambaranNyeri}'),
                                      ),
                                    ),
                                  ],
                                ),
                              if (_kunjunganPengkajianPerawat!
                                      .pengkajianPerawatAnak!
                                      .tandaVital!
                                      .nyeri ==
                                  'Ya')
                                SizedBox(
                                  height: 12,
                                ),
                              if (_kunjunganPengkajianPerawat!
                                      .pengkajianPerawatAnak!
                                      .tandaVital!
                                      .nyeri ==
                                  'Ya')
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: DeskripsiWidget(
                                        title: 'Lokasi Nyeri',
                                        body: Text(
                                            '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.lokasiNyeri}'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                      child: DeskripsiWidget(
                                        title: 'Durasi Nyeri',
                                        body: Text(
                                            '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.durasiNyeri}'),
                                      ),
                                    )
                                  ],
                                ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: DeskripsiWidget(
                                      title: 'Saturasi',
                                      body: Text(
                                        '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.saturasiOksigen} %',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: DeskripsiWidget(
                                      title: 'Alat Bantu',
                                      body: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        color: Color(
                                          int.parse(_kunjunganPengkajianPerawat!
                                              .pengkajianPerawatAnak!
                                              .tandaVital!
                                              .colorAlatBantu!
                                              .body!),
                                        ),
                                        child: Text(
                                          '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.alatBantuOksigen}',
                                          style: TextStyle(
                                              color: Color(int.parse(
                                                  _kunjunganPengkajianPerawat!
                                                      .pengkajianPerawatAnak!
                                                      .tandaVital!
                                                      .colorAlatBantu!
                                                      .text!))),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_kunjunganPengkajianPerawat!
                                          .pengkajianPerawatAnak!
                                          .tandaVital!
                                          .nilaiAlatBantu !=
                                      null)
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: DeskripsiWidget(
                                          title: 'Nilai',
                                          body: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: Text(
                                                '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.nilaiAlatBantu} L/menit'),
                                          ),
                                        ),
                                      ),
                                    ),
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
                                          '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.bab}'),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  Expanded(
                                    child: DeskripsiWidget(
                                      title: 'BAK',
                                      body: Text(
                                          '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.bak}'),
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
                                          .pengkajianPerawatAnak!
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
                                          'PEWS Score',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.0,
                                            color: Color(int.parse(
                                                _kunjunganPengkajianPerawat!
                                                    .pengkajianPerawatAnak!
                                                    .tandaVital!
                                                    .colorSkor!
                                                    .text!)),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 18,
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              'Skor: ${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.score}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Color(int.parse(
                                                    _kunjunganPengkajianPerawat!
                                                        .pengkajianPerawatAnak!
                                                        .tandaVital!
                                                        .colorSkor!
                                                        .text!)),
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
                                      '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.penilaian}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(int.parse(
                                              _kunjunganPengkajianPerawat!
                                                  .pengkajianPerawatAnak!
                                                  .tandaVital!
                                                  .colorSkor!
                                                  .text!)),
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
                                          '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.cairanInputOral}'),
                                    ),
                                  ),
                                  Expanded(
                                    child: DeskripsiWidget(
                                      title: 'Input Parenteral',
                                      body: Text(
                                          '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.cairanInputParenteral}'),
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
                                          '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.cairanOutputKemih}'),
                                    ),
                                  ),
                                  Expanded(
                                    child: DeskripsiWidget(
                                      title: 'Output Muntah',
                                      body: Text(
                                          '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.cairanOutputMuntah}'),
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
                                          style: TextStyle(
                                              color: Colors.grey[100]),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${int.parse(_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.cairanInputOral!) + int.parse(_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.cairanInputParenteral!)} cc',
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
                                          style: TextStyle(
                                              color: Colors.grey[100]),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${int.parse(_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.cairanOutputMuntah!) + int.parse(_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.tandaVital!.cairanOutputKemih!)} cc',
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
                  title: 'Skrining Gizi',
                  errorMessage: 'Data skrining gizi tidak tersedia',
                  dataCard: _kunjunganPengkajianPerawat!
                          .pengkajianPerawatAnak!.skriningGizi!.isEmpty
                      ? null
                      : Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.5)),
                                      child: const Text(
                                        'Pertanyaan',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(width: 0.5),
                                          right: BorderSide(width: 0.5),
                                          bottom: BorderSide(width: 0.5),
                                        ),
                                      ),
                                      child: const Text(
                                        'Jawaban',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              ..._kunjunganPengkajianPerawat!
                                  .pengkajianPerawatAnak!.skriningGizi!
                                  .map(
                                (skriningGizi) => IntrinsicHeight(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(width: 0.5),
                                        right: BorderSide(width: 0.5),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(width: 0.5),
                                                right: BorderSide(width: 0.5),
                                              ),
                                            ),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                '${skriningGizi.pertanyaan}',
                                                style: const TextStyle(
                                                    height: 1.5),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom:
                                                      BorderSide(width: 0.5),
                                                ),
                                              ),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    '${skriningGizi.jawaban}'),
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(
                                        _kunjunganPengkajianPerawat!
                                            .pengkajianPerawatAnak!
                                            .colorGizi!
                                            .body!)),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Modificatikon Strong-Kid',
                                        style: TextStyle(
                                            color: Color(int.parse(
                                                _kunjunganPengkajianPerawat!
                                                    .pengkajianPerawatAnak!
                                                    .colorGizi!
                                                    .text!))),
                                      ),
                                      Text(
                                        '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.mst} - skor: ${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.mstSkor}',
                                        style: TextStyle(
                                          color: Color(int.parse(
                                              _kunjunganPengkajianPerawat!
                                                  .pengkajianPerawatAnak!
                                                  .colorGizi!
                                                  .text!)),
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
                if (_kunjunganPengkajianPerawat!
                    .pengkajianPerawatAnak!.isRemaja!)
                  Divider(
                    color: Colors.grey[200],
                    thickness: 5,
                    height: 5,
                  ),
                if (_kunjunganPengkajianPerawat!
                    .pengkajianPerawatAnak!.isRemaja!)
                  DashboardCardWidget(
                    title: 'Skrining Psikososial/Spiritual (Pasien Remaja)',
                    errorMessage: 'Data pengkajian tidak tersedia',
                    dataCard: _kunjunganPengkajianPerawat!
                                .pengkajianPerawatAnak!.skriningPsikososial ==
                            null
                        ? null
                        : _skriningPsikososialWidget(
                            context,
                            _kunjunganPengkajianPerawat!
                                .pengkajianPerawatAnak!.skriningPsikososial!),
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
                          .pengkajianPerawatAnak!.resikoJatuh!.isEmpty
                      ? null
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _kunjunganPengkajianPerawat!
                                    .pengkajianPerawatAnak!.resikoJatuh!
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
                  errorMessage: 'Data barang habis pakai tidak tersedia',
                  dataCard: _kunjunganPengkajianPerawat!
                          .pengkajianPerawatAnak!.tindakanPerawat!.isEmpty
                      ? null
                      : Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 18,
                          ),
                          child: Column(
                            children: _kunjunganPengkajianPerawat!
                                .pengkajianPerawatAnak!.tindakanPerawat!
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
                          .pengkajianPerawatAnak!.bhp!.isEmpty
                      ? null
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 18),
                          child: Column(
                            children: _kunjunganPengkajianPerawat!
                                .pengkajianPerawatAnak!.bhp!
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
                          .pengkajianPerawatAnak!.diagnosaPerawat!.isEmpty
                      ? null
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            children: _kunjunganPengkajianPerawat!
                                .pengkajianPerawatAnak!.diagnosaPerawat!
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
                if (_kunjunganPengkajianPerawat!
                    .pengkajianPerawatAnak!.diagnosaPerawat!.isNotEmpty)
                  Divider(
                    color: Colors.grey[200],
                    thickness: 5,
                    height: 5,
                  ),
                Divider(
                  color: Colors.grey[200],
                  thickness: 5,
                  height: 5,
                ),
                DashboardCardWidget(
                  title: 'Rencana keperawatan',
                  errorMessage: 'Data rencana keperawatan tidak tersedia',
                  dataCard: _kunjunganPengkajianPerawat!.pengkajianPerawatAnak!
                          .diagnosaTindakanPerawat!.isEmpty
                      ? null
                      : Column(
                          children: _kunjunganPengkajianPerawat!
                              .pengkajianPerawatAnak!.diagnosaTindakanPerawat!
                              .map(
                                (diagnosaTindakan) => ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12),
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
        ),
        if (!_isEdit &&
            _kunjunganPengkajianPerawat!
                    .pengkajianPerawatAnak!.selesaiPengkajian !=
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
                      '${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.selesaiPengkajian!.namaPegawai}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    isThreeLine: _kunjunganPengkajianPerawat!
                        .pengkajianPerawatAnak!.selesaiPengkajian!.isUpdate!,
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Simpan: ${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.selesaiPengkajian!.createdAt}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 13),
                          ),
                          if (_kunjunganPengkajianPerawat!
                              .pengkajianPerawatAnak!
                              .selesaiPengkajian!
                              .isUpdate!)
                            Text(
                              'Update: ${_kunjunganPengkajianPerawat!.pengkajianPerawatAnak!.selesaiPengkajian!.updatedAt}',
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
      BuildContext context, SkriningPsikososialAnak data) {
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
          if (data.sebutkanMasalahPerilaku != null)
            InlineDeskripsiWidget(
              title: 'Status mental',
              body:
                  Text('${data.statusMental}, ${data.sebutkanMasalahPerilaku}'),
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
            title: 'NAPZA',
            body: data.napza!.isNotEmpty
                ? Text(data.napza!.join(', '))
                : Text('Tidak ada'),
          ),
          const SizedBox(
            height: 12,
          ),
          InlineDeskripsiWidget(
            title: 'Infeksi Menular Seksual',
            body: Text('${data.infeksiMenularSeksual}'),
          ),
          const SizedBox(
            height: 12,
          ),
          InlineDeskripsiWidget(
            title: 'HIV/AIDS',
            body: Text('${data.hivAids}'),
          ),
          const SizedBox(
            height: 12,
          ),
          InlineDeskripsiWidget(
            title: 'Perilaku Seksual',
            body: Text('${data.prilakuSeksual}'),
          ),
          const SizedBox(
            height: 12,
          ),
          InlineDeskripsiWidget(
            title: 'Pola tidur',
            body: Text('${data.polaTidur}'),
          ),
          const SizedBox(
            height: 12,
          ),
          InlineDeskripsiWidget(
            title: 'Pendidikan',
            body: Text('${data.pendidikan}'),
          ),
          const SizedBox(
            height: 12,
          ),
          InlineDeskripsiWidget(
            title: 'Status pubertas',
            body: Text('${data.pubertas}: ${data.statusPubertas}'),
          ),
          const SizedBox(
            height: 12,
          ),
          InlineDeskripsiWidget(
            title: 'Usia',
            body: Text(data.umur ?? '-'),
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

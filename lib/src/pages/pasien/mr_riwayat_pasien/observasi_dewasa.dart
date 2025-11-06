import 'package:admin_dokter_panggil/src/models/mr_kunjungan_observasi_model.dart';
import 'package:admin_dokter_panggil/src/models/pasien_show_model.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_observasi_komprehensif.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ObservasiDewasa extends StatefulWidget {
  const ObservasiDewasa({
    super.key,
    this.onScroll,
    this.data,
    this.pasien,
    this.idKunjungan,
  });

  final Function(ScrollDirection scroll)? onScroll;
  final DataMrObservasi? data;
  final Pasien? pasien;
  final int? idKunjungan;

  @override
  State<ObservasiDewasa> createState() => _ObservasiDewasaState();
}

class _ObservasiDewasaState extends State<ObservasiDewasa> {
  List<DataObservasi> _datas = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() {
    if (widget.data!.observasi!.isNotEmpty) {
      _datas = widget.data!.observasi!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Penilaian',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tanggal/jam',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Petugas',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'GCS',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Kesadaran',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tekanan Darah Sistolik',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tekanan Darah Diastolik',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Nadi',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Pernapasan',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Suhu',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Saturasi Oksigen',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Skala Nyeri (Dewasa)',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Pencetus Nyeri',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Gambaran Nyeri',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Lokasi Nyeri',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Durasi Nyeri',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'BAB',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'BAK',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        border: false,
                      ),
                      Container(
                        width: 120,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.blueAccent.withValues(alpha: 0.2),
                            border: const Border(
                                top: BorderSide(
                                    color: Colors.grey, width: 0.5))),
                        child: const Text(
                          'Balance Cairan',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        width: 120,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withValues(alpha: 0.2),
                        ),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Input',
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Oral',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Parenteral',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        width: 120,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withValues(alpha: 0.2),
                        ),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Output',
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Kemih',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ColumnWidget(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Muntah',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        border: true,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _pengkajianPerawatWidget(context),
                        if (_datas.isNotEmpty)
                          ..._datas.map(
                            (dataObservasi) => Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      width: 0.5, color: Colors.grey),
                                ),
                              ),
                              child: Column(
                                children: [
                                  if (dataObservasi.saturasiOksigen! < 90)
                                    ColumnWidget(
                                      color: Color(0xFFFF0000),
                                      label: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Hubungi dokter segera',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(int.parse(
                                                    dataObservasi
                                                        .color!.text!))),
                                          ),
                                          Text(
                                            'Saturasi < 90%',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(int.parse(
                                                    dataObservasi
                                                        .color!.text!))),
                                          )
                                        ],
                                      ),
                                      border: true,
                                    )
                                  else
                                    ColumnWidget(
                                      color: Color(
                                        int.parse(dataObservasi.color!.body!),
                                      ),
                                      label: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${dataObservasi.penilaian!.frekuensi}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(int.parse(
                                                    dataObservasi
                                                        .color!.text!))),
                                          ),
                                          Text(
                                            '${dataObservasi.textScore}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(int.parse(
                                                    dataObservasi
                                                        .color!.text!))),
                                          )
                                        ],
                                      ),
                                      border: true,
                                    ),
                                  ColumnWidget(
                                    label: Text(
                                      '${dataObservasi.tanggal}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  ColumnWidget(
                                    label: Text(
                                      '${dataObservasi.namaPegawai}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  ColumnWidget(
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 6),
                                      color: Color(int.parse(
                                          dataObservasi.colorGcs!.body!)),
                                      child: Text(
                                        '${dataObservasi.skorGcs}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(int.parse(dataObservasi
                                                .colorGcs!.text!))),
                                      ),
                                    ),
                                  ),
                                  ColumnWidget(
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 6),
                                      color: Color(int.parse(
                                          dataObservasi.colorKesadaran!.body!)),
                                      child: Text(
                                        '${dataObservasi.kesadaran}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(int.parse(dataObservasi
                                                .colorKesadaran!.text!))),
                                      ),
                                    ),
                                  ),
                                  ColumnWidget(
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 6),
                                      color: Color(int.parse(
                                          dataObservasi.colorSistolik!.body!)),
                                      child: Text(
                                        dataObservasi.tdSistolik == null
                                            ? '-'
                                            : '${dataObservasi.tdSistolik} mmHg',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(int.parse(dataObservasi
                                                .colorSistolik!.text!))),
                                      ),
                                    ),
                                  ),
                                  ColumnWidget(
                                    label: Text(
                                      dataObservasi.tdDiastolik == null
                                          ? '-'
                                          : '${dataObservasi.tdDiastolik} mmHg',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  ColumnWidget(
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 6),
                                      color: Color(int.parse(
                                          dataObservasi.colorNadi!.body!)),
                                      child: Text(
                                        '${dataObservasi.nadi} x/menit',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(int.parse(dataObservasi
                                                .colorNadi!.text!))),
                                      ),
                                    ),
                                  ),
                                  ColumnWidget(
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 6),
                                      color: Color(int.parse(dataObservasi
                                          .colorPernapasan!.body!)),
                                      child: Text(
                                        '${dataObservasi.pernapasan} x/menit',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(int.parse(dataObservasi
                                                .colorPernapasan!.text!))),
                                      ),
                                    ),
                                  ),
                                  ColumnWidget(
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 6),
                                      color: Color(int.parse(
                                          dataObservasi.colorSuhu!.body!)),
                                      child: Text(
                                        '${dataObservasi.suhu} \xB0C',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(int.parse(dataObservasi
                                                .colorSuhu!.text!))),
                                      ),
                                    ),
                                  ),
                                  ColumnWidget(
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 6),
                                      color: Color(int.parse(
                                          dataObservasi.colorOksigen!.body!)),
                                      child: Text(
                                        '${dataObservasi.saturasiOksigen} %',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(int.parse(dataObservasi
                                                .colorOksigen!.text!))),
                                      ),
                                    ),
                                  ),
                                  ColumnWidget(
                                    label: dataObservasi.nyeri == 'Ya'
                                        ? Text(
                                            '${dataObservasi.skalaNyeri}',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          )
                                        : Text(
                                            '${dataObservasi.nyeri}',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                  ),
                                  ColumnWidget(
                                    label: dataObservasi.nyeri == 'Ya'
                                        ? Text(
                                            '${dataObservasi.pencetusNyeri}',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          )
                                        : Text(
                                            '-',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                  ),
                                  ColumnWidget(
                                    label: dataObservasi.nyeri == 'Ya'
                                        ? Text(
                                            '${dataObservasi.gambaranNyeri}',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          )
                                        : Text(
                                            '-',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                  ),
                                  ColumnWidget(
                                    label: dataObservasi.nyeri == 'Ya'
                                        ? Text(
                                            '${dataObservasi.lokasiNyeri}',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          )
                                        : Text(
                                            '-',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                  ),
                                  ColumnWidget(
                                    label: dataObservasi.nyeri == 'Ya'
                                        ? Text(
                                            '${dataObservasi.durasiNyeri}',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          )
                                        : Text(
                                            '-',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                  ),
                                  ColumnWidget(
                                    label: Text(
                                      '${dataObservasi.bab}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  ColumnWidget(
                                    label: Text(
                                      '${dataObservasi.bak}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    border: false,
                                  ),
                                  Container(
                                    width: 120,
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: kBgRedLightColor,
                                      border: Border(
                                        top: BorderSide(
                                            color: Colors.grey, width: 0.5),
                                      ),
                                    ),
                                    child: const Text(
                                      'Balance Cairan',
                                      style: TextStyle(color: kBgRedLightColor),
                                    ),
                                  ),
                                  Container(
                                    width: 120,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: const BoxDecoration(
                                        color: kBgRedLightColor),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${dataObservasi.totalBcInput} cc',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  ColumnWidget(
                                    label: Text(
                                      '${dataObservasi.bcInputOral} cc',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  ColumnWidget(
                                    label: Text(
                                      '${dataObservasi.bcInputParenteral} cc',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Container(
                                    width: 120,
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                        color: kBgRedLightColor),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${dataObservasi.totalBcOutput} cc',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ColumnWidget(
                                    label: Text(
                                      '${dataObservasi.bcOutputKemih} cc',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  ColumnWidget(
                                    label: Text(
                                      '${dataObservasi.bcOutputMuntah} cc',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget _pengkajianPerawatWidget(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(right: BorderSide(width: 0.5, color: Colors.grey))),
      child: Column(
        children: [
          if (widget.data!.tandaVital!.saturasiOksigen! < 90)
            ColumnWidget(
                color: Color(0xFFFF0000),
                label: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hubungi Dokter Segera',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    Text(
                      'Saturasi < 90%',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    )
                  ],
                ))
          else
            ColumnWidget(
              color:
                  Color(int.parse(widget.data!.tandaVital!.colorSkor!.body!)),
              label: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.data!.tandaVital!.penilaian!.frekuensi}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(int.parse(
                            widget.data!.tandaVital!.colorSkor!.text!))),
                  ),
                  Text(
                    '${widget.data!.tandaVital!.textScore}',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(int.parse(
                            widget.data!.tandaVital!.colorSkor!.text!))),
                  )
                ],
              ),
            ),
          ColumnWidget(
            label: Text(
              '${widget.data!.tanggalPengkajian}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          ColumnWidget(
            label: Text(
              '${widget.data!.namaPerawat}',
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
          ColumnWidget(
            label: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              color: Color(int.parse(widget.data!.tandaVital!.colorGcs!.body!)),
              child: Text(
                '${widget.data!.tandaVital!.scoreGcs}',
                style: TextStyle(
                    fontSize: 12,
                    color: Color(
                        int.parse(widget.data!.tandaVital!.colorGcs!.text!))),
              ),
            ),
          ),
          ColumnWidget(
            label: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              color: Color(
                  int.parse(widget.data!.tandaVital!.colorKesadaran!.body!)),
              child: Text(
                '${widget.data!.tandaVital!.kesadaran}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    color: Color(int.parse(
                        widget.data!.tandaVital!.colorKesadaran!.text!))),
              ),
            ),
          ),
          ColumnWidget(
            label: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              color: Color(
                  int.parse(widget.data!.tandaVital!.colorSistolik!.body!)),
              child: Text(
                '${widget.data!.tandaVital!.tdSistolik} mmHg',
                style: TextStyle(
                    fontSize: 12,
                    color: Color(int.parse(
                        widget.data!.tandaVital!.colorSistolik!.text!))),
              ),
            ),
          ),
          ColumnWidget(
            label: Text(
              '${widget.data!.tandaVital!.tdDiastolik} mmHg',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          ColumnWidget(
            label: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              color:
                  Color(int.parse(widget.data!.tandaVital!.colorNadi!.body!)),
              child: Text(
                '${widget.data!.tandaVital!.nadi} x/menit',
                style: TextStyle(
                    fontSize: 12,
                    color: Color(
                        int.parse(widget.data!.tandaVital!.colorNadi!.text!))),
              ),
            ),
          ),
          ColumnWidget(
            label: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              color: Color(
                  int.parse(widget.data!.tandaVital!.colorPernapasan!.body!)),
              child: Text(
                '${widget.data!.tandaVital!.pernapasan} x/menit',
                style: TextStyle(
                    fontSize: 12,
                    color: Color(int.parse(
                        widget.data!.tandaVital!.colorPernapasan!.text!))),
              ),
            ),
          ),
          ColumnWidget(
            label: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              color:
                  Color(int.parse(widget.data!.tandaVital!.colorSuhu!.body!)),
              child: Text(
                '${widget.data!.tandaVital!.suhu} \xB0C',
                style: TextStyle(
                    fontSize: 12,
                    color: Color(
                        int.parse(widget.data!.tandaVital!.colorSuhu!.text!))),
              ),
            ),
          ),
          ColumnWidget(
            label: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              color: Color(
                int.parse(widget.data!.tandaVital!.colorOksigen!.body!),
              ),
              child: Text(
                '${widget.data!.tandaVital!.saturasiOksigen} %',
                style: TextStyle(
                    fontSize: 12,
                    color: Color(int.parse(
                        widget.data!.tandaVital!.colorOksigen!.text!))),
              ),
            ),
          ),
          ColumnWidget(
            label: widget.data!.tandaVital!.nyeri == 'Ya'
                ? Text(
                    '${widget.data!.tandaVital!.skalaNyeri}',
                    style: const TextStyle(fontSize: 12),
                  )
                : Text(
                    '${widget.data!.tandaVital!.nyeri}',
                    style: const TextStyle(fontSize: 12),
                  ),
          ),
          ColumnWidget(
            label: widget.data!.tandaVital!.nyeri == 'Ya'
                ? Text(
                    '${widget.data!.tandaVital!.pencetusNyeri}',
                    style: const TextStyle(fontSize: 12),
                  )
                : Text(
                    '-',
                    style: const TextStyle(fontSize: 12),
                  ),
          ),
          ColumnWidget(
            label: widget.data!.tandaVital!.nyeri == 'Ya'
                ? Text(
                    '${widget.data!.tandaVital!.lokasiNyeri}',
                    style: const TextStyle(fontSize: 12),
                  )
                : Text(
                    '-',
                    style: const TextStyle(fontSize: 12),
                  ),
          ),
          ColumnWidget(
            label: widget.data!.tandaVital!.nyeri == 'Ya'
                ? Text(
                    '${widget.data!.tandaVital!.gambaranNyeri}',
                    style: const TextStyle(fontSize: 12),
                  )
                : Text(
                    '-',
                    style: const TextStyle(fontSize: 12),
                  ),
          ),
          ColumnWidget(
            label: widget.data!.tandaVital!.nyeri == 'Ya'
                ? Text(
                    '${widget.data!.tandaVital!.durasiNyeri}',
                    style: const TextStyle(fontSize: 12),
                  )
                : Text(
                    '-',
                    style: const TextStyle(fontSize: 12),
                  ),
          ),
          ColumnWidget(
            label: Text(
              '${widget.data!.tandaVital!.bab}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          ColumnWidget(
            label: Text(
              '${widget.data!.tandaVital!.bak}',
              style: const TextStyle(fontSize: 12),
            ),
            border: false,
          ),
          Container(
            width: 120,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: kBgRedLightColor,
              border: Border(
                top: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: const Text(
              'Balance Cairan',
              style: TextStyle(color: kBgRedLightColor),
            ),
          ),
          Container(
            width: 120,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(color: kBgRedLightColor),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '${widget.data!.tandaVital!.totalInput} cc',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ColumnWidget(
            label: Text(
              '${widget.data!.tandaVital!.cairanInputOral} cc',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          ColumnWidget(
            label: Text(
              '${widget.data!.tandaVital!.cairanInputParenteral} cc',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 120,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: kBgRedLightColor),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '${widget.data!.tandaVital!.totalOutput} cc',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
          ),
          ColumnWidget(
            label: Text(
              '${widget.data!.tandaVital!.cairanOutputKemih} cc',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          ColumnWidget(
            label: Text(
              '${widget.data!.tandaVital!.cairanOutputMuntah} cc',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

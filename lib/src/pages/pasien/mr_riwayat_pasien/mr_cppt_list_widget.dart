import 'package:admin_dokter_panggil/src/models/mr_kunjungan_cppt_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_observasi_anak_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_observasi_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/bullet_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/deskripsi_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/tile_data_card.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/cppt_view_card_widget.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_cppt.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MrCpptListWidget extends StatefulWidget {
  const MrCpptListWidget({
    super.key,
    required this.dataCppt,
    this.dataDashboard,
    this.controller,
  });

  final List<DataCppt> dataCppt;
  final MrRiwayatKunjungan? dataDashboard;
  final ScrollController? controller;

  @override
  State<MrCpptListWidget> createState() => _MrCpptListWidgetState();
}

class _MrCpptListWidgetState extends State<MrCpptListWidget> {
  final List<CpptOrder> _orderCppt = [];
  List<DataCppt> _dataCppt = [];
  final _tanggalFormat = DateFormat('dd-MM-yyyy', 'id');

  @override
  void initState() {
    super.initState();
    _dataCppt = widget.dataCppt;
    _groupCppt(_dataCppt);
  }

  void _groupCppt(List<DataCppt> dataCppt) {
    setState(() {
      if (_orderCppt.isNotEmpty) _orderCppt.clear();
      final groupData =
          groupBy(dataCppt, (cppt) => '${cppt.createdAt}-${cppt.pegawaiId}');
      groupData.forEach(
        (key, cppt) {
          _orderCppt.add(
            CpptOrder(
              tanggal: key.substring(0, 10),
              pegawaiId: int.parse(key.substring(11)),
              cppt: cppt,
              verifiedAt: cppt.first.verifiedAt,
              verifiedBy: cppt.first.verifiedBy,
              isVerifier: cppt.first.isVerifier,
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.controller,
      physics: ClampingScrollPhysics(),
      child: Column(
        children: _orderCppt
            .map(
              (order) => Column(
                children: [
                  ...order.cppt!.map(
                    (cppt) {
                      if (cppt.isSoap == true) {
                        var soap = cppt.cpptable as CpptableSoap;
                        return Column(
                          children: [
                            IntrinsicHeight(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cppt.profesi == 'Dokter'
                                      ? Colors.blue.withValues(alpha: 0.1)
                                      : Colors.red.withValues(alpha: 0.1),
                                  border: _dataCppt.indexOf(cppt) != 0
                                      ? Border(
                                          top: BorderSide(
                                              color: Colors.grey[300]!,
                                              width: 4),
                                        )
                                      : null,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0, vertical: 18.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              '${cppt.tanggal}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              '${cppt.jam}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                              ),
                                              child: Text(
                                                '${cppt.profesi}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const VerticalDivider(
                                      width: 0,
                                      color: Colors.grey,
                                    ),
                                    Expanded(
                                      flex: 10,
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 18.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 22,
                                                    child: Center(
                                                      child: Text(
                                                        'S',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(':'),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                    '${soap.subjektif}',
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ))
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8.0,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 22,
                                                    child: Center(
                                                      child: Text(
                                                        'O',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(':'),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                    '${soap.objektif}',
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ))
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8.0,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 22,
                                                    child: Center(
                                                      child: Text(
                                                        'A',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(':'),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Diagnosa Icd 10',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        ...soap.assesment!.map(
                                                            (diagnosa) =>
                                                                BulletWidget(
                                                                  title:
                                                                      '${diagnosa.kodeIcd10} - ${diagnosa.namaDiagnosa}',
                                                                  subtitle:
                                                                      Text(
                                                                    '${diagnosa.type}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        color: diagnosa.type ==
                                                                                'Primary'
                                                                            ? kGreenColor
                                                                            : kSecondaryColor),
                                                                  ),
                                                                )),
                                                        if (soap.diagnosaIcd9!
                                                            .isNotEmpty)
                                                          const Text(
                                                            'Diagnosa Icd 9',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        if (soap.diagnosaIcd9!
                                                            .isNotEmpty)
                                                          ...soap.diagnosaIcd9!
                                                              .map(
                                                            (diagnosa) =>
                                                                BulletWidget(
                                                              title:
                                                                  '${diagnosa.kodeIcd9} - ${diagnosa.namaDiagnosa}',
                                                              subtitle: Text(
                                                                '${diagnosa.type}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: diagnosa.type ==
                                                                            'Primary'
                                                                        ? kGreenColor
                                                                        : kSecondaryColor),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8.0,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 22,
                                                    child: Center(
                                                      child: Text(
                                                        'P',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(':'),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${soap.planning}',
                                                          textAlign:
                                                              TextAlign.justify,
                                                        ),
                                                        if (soap.tindakan!
                                                            .isNotEmpty)
                                                          CpptViewCardWidget(
                                                            title: 'Tindakan',
                                                            data: Column(
                                                              children:
                                                                  soap.tindakan!
                                                                      .map(
                                                                        (tindakan) =>
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              child: BulletWidget(
                                                                                title: '${tindakan.namaTindakan}',
                                                                              ),
                                                                            ),
                                                                            if (tindakan.foc ==
                                                                                1)
                                                                              SizedBox(
                                                                                width: 12,
                                                                              ),
                                                                            if (tindakan.foc ==
                                                                                1)
                                                                              Container(
                                                                                width: 42,
                                                                                margin: EdgeInsets.only(top: 2),
                                                                                padding: EdgeInsets.symmetric(vertical: 2),
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.green,
                                                                                  borderRadius: BorderRadius.circular(32),
                                                                                ),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    'FOC',
                                                                                    style: TextStyle(fontSize: 10, color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                          ],
                                                                        ),
                                                                      )
                                                                      .toList(),
                                                            ),
                                                          ),
                                                        if (soap.obatInjeksi!
                                                            .isNotEmpty)
                                                          CpptViewCardWidget(
                                                            title:
                                                                'Obat Injeksi',
                                                            data: Column(
                                                              children: soap
                                                                  .obatInjeksi!
                                                                  .map(
                                                                    (obat) =>
                                                                        BulletWidget(
                                                                      title:
                                                                          '${obat.namaBarang}',
                                                                      subtitle:
                                                                          Text(
                                                                              '${obat.jumlah} buah - ${obat.aturanPakai}'),
                                                                    ),
                                                                  )
                                                                  .toList(),
                                                            ),
                                                          ),
                                                        if (soap
                                                            .bhp!.isNotEmpty)
                                                          CpptViewCardWidget(
                                                            title:
                                                                'Barang Habis Pakai',
                                                            data: Column(
                                                              children:
                                                                  soap.bhp!
                                                                      .map(
                                                                        (bhp) =>
                                                                            BulletWidget(
                                                                          title:
                                                                              '${bhp.namaBarang}',
                                                                          subtitle:
                                                                              Text('${bhp.jumlah} buah'),
                                                                        ),
                                                                      )
                                                                      .toList(),
                                                            ),
                                                          ),
                                                        if (soap
                                                            .resep!.isNotEmpty)
                                                          CpptViewCardWidget(
                                                            title: 'Obat Oral',
                                                            data: Column(
                                                              children: soap
                                                                  .resep!
                                                                  .map((resep) =>
                                                                      BulletWidget(
                                                                        title:
                                                                            '${resep.namaBarang}',
                                                                        subtitle:
                                                                            Text('${resep.jumlah} buah - ${resep.aturanPakai}'),
                                                                      ))
                                                                  .toList(),
                                                            ),
                                                          ),
                                                        if (soap.resepRacikan!
                                                            .isNotEmpty)
                                                          CpptViewCardWidget(
                                                            title:
                                                                'Obat Racikan',
                                                            data: Column(
                                                              children: soap
                                                                  .resepRacikan!
                                                                  .map(
                                                                    (racikan) =>
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              8.0),
                                                                      margin: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              4),
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                              color: kPrimaryColor,
                                                                              width: 0.5)),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          const SizedBox(
                                                                            height:
                                                                                4,
                                                                          ),
                                                                          const Text(
                                                                            'Nama Racikan',
                                                                            style:
                                                                                TextStyle(fontSize: 13.0, color: Colors.grey),
                                                                          ),
                                                                          Text(
                                                                              '${racikan.namaRacikan}'),
                                                                          const SizedBox(
                                                                            height:
                                                                                4.0,
                                                                          ),
                                                                          const Text(
                                                                            'Barang/Obat',
                                                                            style:
                                                                                TextStyle(fontSize: 13.0, color: Colors.grey),
                                                                          ),
                                                                          Column(
                                                                              children: ListTile.divideTiles(
                                                                            context:
                                                                                context,
                                                                            tiles: racikan.barangRacikan!
                                                                                .map((barang) => BulletWidget(
                                                                                      title: '${barang.namaBarang}',
                                                                                      subtitle: Text('Dosis: ${barang.dosis}'),
                                                                                    ))
                                                                                .toList(),
                                                                          ).toList()),
                                                                          const SizedBox(
                                                                            height:
                                                                                4,
                                                                          ),
                                                                          const Text(
                                                                            'Petunjuk',
                                                                            style:
                                                                                TextStyle(fontSize: 13.0, color: Colors.grey),
                                                                          ),
                                                                          Text(
                                                                              '${racikan.petunjuk}'),
                                                                          const SizedBox(
                                                                            height:
                                                                                4.0,
                                                                          ),
                                                                          const Text(
                                                                            'Aturan pakai',
                                                                            style:
                                                                                TextStyle(fontSize: 13.0, color: Colors.grey),
                                                                          ),
                                                                          Text(
                                                                              '${racikan.aturanPakai}'),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                  .toList(),
                                                            ),
                                                          ),
                                                        if (soap
                                                            .lab!.isNotEmpty)
                                                          CpptViewCardWidget(
                                                            title:
                                                                'Laboratorium',
                                                            data: Column(
                                                              children: soap
                                                                  .lab!
                                                                  .map((lab) =>
                                                                      BulletWidget(
                                                                        title:
                                                                            '${lab.namaTindakanLab}',
                                                                      ))
                                                                  .toList(),
                                                            ),
                                                          ),
                                                        if (soap
                                                            .rad!.isNotEmpty)
                                                          CpptViewCardWidget(
                                                            title: 'Radiologi',
                                                            data: Column(
                                                              children: soap
                                                                  .rad!
                                                                  .map((rad) =>
                                                                      BulletWidget(
                                                                        title:
                                                                            '${rad.namaTindakanRad}',
                                                                      ))
                                                                  .toList(),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: CpptViewCardWidget(
                                                  title: 'Petugas',
                                                  data: Text(
                                                      '${cppt.namaPegawai}'),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      if (cppt.isSoapPerawat!) {
                        var soapPerawat = cppt.cpptable as CpptableSoapPerawat;
                        if (!soapPerawat.isDewasa!) {
                          var ttv = soapPerawat.ttv as DataObservasiAnak;
                          return Column(
                            children: [
                              IntrinsicHeight(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: cppt.profesi == 'Dokter'
                                        ? Colors.blue.withValues(alpha: 0.1)
                                        : Colors.red.withValues(alpha: 0.1),
                                    border: _dataCppt.indexOf(cppt) != 0
                                        ? Border(
                                            top: BorderSide(
                                                color: Colors.grey[300]!,
                                                width: 4),
                                          )
                                        : null,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 18.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                '${cppt.tanggal}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                '${cppt.jam}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(22),
                                                ),
                                                child: Text(
                                                  '${cppt.profesi}',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const VerticalDivider(
                                        width: 0,
                                        color: Colors.grey,
                                      ),
                                      Expanded(
                                        flex: 10,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 18.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 22,
                                                    child: Center(
                                                      child: Text(
                                                        'S',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(':'),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                    '${soapPerawat.subjektif}',
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ))
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8.0,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 22,
                                                    child: Center(
                                                      child: Text(
                                                        'O',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(':'),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${soapPerawat.objektif}',
                                                          textAlign:
                                                              TextAlign.justify,
                                                        ),
                                                        SizedBox(height: 8),
                                                        RowTtvCpptWidget(
                                                          title: 'Penilaian',
                                                          body:
                                                              '${ttv.penilaian}\n${ttv.textScore}',
                                                          colorBody: Color(
                                                              int.parse(ttv
                                                                  .color!
                                                                  .body!)),
                                                          colorText: Color(
                                                              int.parse(ttv
                                                                  .color!
                                                                  .text!)),
                                                        ),
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black,
                                                        ),
                                                        RowTtvCpptWidget(
                                                          title: 'Kesadaran',
                                                          body:
                                                              '${ttv.kesadaran}',
                                                          colorBody: Color(
                                                              int.parse(ttv
                                                                  .colorKesadaran!
                                                                  .body!)),
                                                          colorText: Color(
                                                              int.parse(ttv
                                                                  .colorKesadaran!
                                                                  .text!)),
                                                        ),
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black,
                                                        ),
                                                        RowTtvCpptWidget(
                                                          title: 'TD Sistolik',
                                                          body:
                                                              '${ttv.tdSistolik} mmHg',
                                                          colorBody: Color(
                                                              int.parse(ttv
                                                                  .colorSistolik!
                                                                  .body!)),
                                                          colorText: Color(
                                                              int.parse(ttv
                                                                  .colorSistolik!
                                                                  .text!)),
                                                        ),
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black,
                                                        ),
                                                        RowTtvCpptWidget(
                                                          title: 'TD Diastolik',
                                                          body:
                                                              '${ttv.tdDiastolik} mmHg',
                                                        ),
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black,
                                                        ),
                                                        RowTtvCpptWidget(
                                                          title: 'Nadi',
                                                          body:
                                                              '${ttv.nadi} x/menit',
                                                          colorBody: Color(
                                                              int.parse(ttv
                                                                  .colorNadi!
                                                                  .body!)),
                                                          colorText: Color(
                                                              int.parse(ttv
                                                                  .colorNadi!
                                                                  .text!)),
                                                        ),
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black,
                                                        ),
                                                        RowTtvCpptWidget(
                                                          title: 'Pernapasan',
                                                          body:
                                                              '${ttv.pernapasan} x/menit',
                                                          colorBody: Color(
                                                              int.parse(ttv
                                                                  .colorPernapasan!
                                                                  .body!)),
                                                          colorText: Color(
                                                              int.parse(ttv
                                                                  .colorPernapasan!
                                                                  .text!)),
                                                        ),
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black,
                                                        ),
                                                        RowTtvCpptWidget(
                                                          title: 'Suhu',
                                                          body:
                                                              '${ttv.suhu} \xB0C',
                                                        ),
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black,
                                                        ),
                                                        RowTtvCpptWidget(
                                                          title: 'Sat. Oksigen',
                                                          body:
                                                              '${ttv.saturasiOksigen} %',
                                                        ),
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black,
                                                        ),
                                                        RowTtvCpptWidget(
                                                          title:
                                                              'Alat Bantu Oksigen',
                                                          body: ttv.alatBantuOksigen ==
                                                                  'Ya'
                                                              ? '${ttv.alatBantuOksigen}, ${ttv.nilaiAlatBantu} L/mnt'
                                                              : '${ttv.alatBantuOksigen}',
                                                          colorBody: Color(
                                                            int.parse(
                                                                '${ttv.colorAlatBantu!.body}'),
                                                          ),
                                                          colorText: Color(
                                                            int.parse(
                                                                '${ttv.colorAlatBantu!.text}'),
                                                          ),
                                                        ),
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black,
                                                        ),
                                                        RowTtvCpptWidget(
                                                          title:
                                                              'Waktu Isi Kapiler',
                                                          body:
                                                              '${ttv.waktuIsiKapiler} detik',
                                                          colorBody: Color(
                                                            int.parse(
                                                                '${ttv.colorIsiKapiler!.body}'),
                                                          ),
                                                          colorText: Color(
                                                            int.parse(
                                                                '${ttv.colorIsiKapiler!.text}'),
                                                          ),
                                                        ),
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black,
                                                        ),
                                                        if (ttv.nyeri == 'Ya')
                                                          RowTtvCpptWidget(
                                                            title:
                                                                'Skala Nyeri',
                                                            body:
                                                                '${ttv.skalaNyeri}',
                                                          )
                                                        else
                                                          RowTtvCpptWidget(
                                                            title:
                                                                'Skala Nyeri',
                                                            body:
                                                                '${ttv.nyeri}',
                                                          ),
                                                        if (ttv.nyeri == 'Ya')
                                                          Divider(
                                                            height: 0,
                                                            color: Colors.black,
                                                          ),
                                                        if (ttv.nyeri == 'Ya')
                                                          RowTtvCpptWidget(
                                                            title:
                                                                'Pencetus Nyeri',
                                                            body:
                                                                '${ttv.pencetusNyeri}',
                                                          ),
                                                        if (ttv.nyeri == 'Ya')
                                                          Divider(
                                                            height: 0,
                                                            color: Colors.black,
                                                          ),
                                                        if (ttv.nyeri == 'Ya')
                                                          RowTtvCpptWidget(
                                                            title:
                                                                'Gambaran Nyeri',
                                                            body:
                                                                '${ttv.gambaranNyeri}',
                                                          ),
                                                        if (ttv.nyeri == 'Ya')
                                                          Divider(
                                                            height: 0,
                                                            color: Colors.black,
                                                          ),
                                                        if (ttv.nyeri == 'Ya')
                                                          RowTtvCpptWidget(
                                                            title:
                                                                'Lokasi Nyeri',
                                                            body:
                                                                '${ttv.lokasiNyeri}',
                                                          ),
                                                        if (ttv.nyeri == 'Ya')
                                                          Divider(
                                                            height: 0,
                                                            color: Colors.black,
                                                          ),
                                                        if (ttv.nyeri == 'Ya')
                                                          RowTtvCpptWidget(
                                                            title:
                                                                'Durasi Nyeri',
                                                            body:
                                                                '${ttv.durasiNyeri}',
                                                          ),
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black,
                                                        ),
                                                        RowTtvCpptWidget(
                                                          title: 'BAB',
                                                          body: '${ttv.bab}',
                                                        ),
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black,
                                                        ),
                                                        RowTtvCpptWidget(
                                                          title: 'BAK',
                                                          body: '${ttv.bak}',
                                                        ),
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black,
                                                        ),
                                                        RowTtvCpptWidget(
                                                          title:
                                                              'Balance Cairan Input',
                                                          body:
                                                              'Total: ${ttv.totalBcInput} cc\nOral: ${ttv.bcInputOral} cc\nParenteral: ${ttv.bcInputParenteral} cc',
                                                        ),
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black,
                                                        ),
                                                        RowTtvCpptWidget(
                                                          title:
                                                              'Balance Cairan Output',
                                                          body:
                                                              'Total: ${ttv.totalBcOutput} cc\nMuntah: ${ttv.bcOutputMuntah} cc\nKemih: ${ttv.bcOutputKemih} cc',
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8.0,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 22,
                                                    child: Center(
                                                      child: Text(
                                                        'A',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(':'),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          soapPerawat.assesmentText ==
                                                                  null
                                                              ? '-'
                                                              : '${soapPerawat.assesmentText}',
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        const Text(
                                                          'Diagnosa Perawat',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        ...soapPerawat
                                                            .assesment!
                                                            .map(
                                                          (assesment) =>
                                                              BulletWidget(
                                                            title:
                                                                '${assesment.diagnosa}',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8.0,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 22,
                                                    child: Center(
                                                      child: Text(
                                                        'P',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(':'),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          soapPerawat.planningText ==
                                                                  null
                                                              ? '-'
                                                              : '${soapPerawat.planningText}',
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        const Text(
                                                          'Rencana Keperawatan',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        ...soapPerawat.planning!
                                                            .map(
                                                          (planning) =>
                                                              BulletWidget(
                                                            title:
                                                                '${planning.namaTindakan}',
                                                            subtitle: Text(
                                                              '${planning.namaDiagnosa}',
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                        ),
                                                        if (soapPerawat
                                                            .tindakanPerawat!
                                                            .isNotEmpty)
                                                          SizedBox(
                                                            height: 12,
                                                          ),
                                                        if (soapPerawat
                                                            .tindakanPerawat!
                                                            .isNotEmpty)
                                                          const Text(
                                                            'Tindakan Perawat',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        if (soapPerawat
                                                            .tindakanPerawat!
                                                            .isNotEmpty)
                                                          ...soapPerawat
                                                              .tindakanPerawat!
                                                              .map(
                                                            (tindakan) =>
                                                                BulletWidget(
                                                              title:
                                                                  '${tindakan.namaTindakan}',
                                                            ),
                                                          ),
                                                        if (soapPerawat
                                                            .barangHabisPakai!
                                                            .isNotEmpty)
                                                          SizedBox(
                                                            height: 12,
                                                          ),
                                                        if (soapPerawat
                                                            .barangHabisPakai!
                                                            .isNotEmpty)
                                                          const Text(
                                                            'Barang Habis Pakai',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        ...soapPerawat
                                                            .barangHabisPakai!
                                                            .map(
                                                          (bhp) => BulletWidget(
                                                            title:
                                                                '${bhp.namaBarang}',
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        var ttv = soapPerawat.ttv as DataObservasi;
                        return Column(
                          children: [
                            IntrinsicHeight(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cppt.profesi == 'Dokter'
                                      ? Colors.blue.withValues(alpha: 0.1)
                                      : Colors.red.withValues(alpha: 0.1),
                                  border: _dataCppt.indexOf(cppt) != 0
                                      ? Border(
                                          top: BorderSide(
                                              color: Colors.grey[300]!,
                                              width: 4),
                                        )
                                      : null,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0, vertical: 18.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              '${cppt.tanggal}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              '${cppt.jam}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                              ),
                                              child: Text(
                                                '${cppt.profesi}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const VerticalDivider(
                                      width: 0,
                                      color: Colors.grey,
                                    ),
                                    Expanded(
                                      flex: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0, vertical: 18.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 22,
                                                  child: Center(
                                                    child: Text(
                                                      'S',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                                const Text(':'),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  '${soapPerawat.subjektif}',
                                                  textAlign: TextAlign.justify,
                                                ))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8.0,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 22,
                                                  child: Center(
                                                    child: Text(
                                                      'O',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                                const Text(':'),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${soapPerawat.objektif}',
                                                        textAlign:
                                                            TextAlign.justify,
                                                      ),
                                                      SizedBox(height: 8),
                                                      RowTtvCpptWidget(
                                                        title: 'Penilaian',
                                                        body:
                                                            '${ttv.penilaian!.frekuensi}\n${ttv.textScore}',
                                                        colorBody: Color(
                                                            int.parse(ttv
                                                                .color!.body!)),
                                                        colorText: Color(
                                                            int.parse(ttv
                                                                .color!.text!)),
                                                      ),
                                                      Divider(
                                                        height: 0,
                                                        color: Colors.black,
                                                      ),
                                                      RowTtvCpptWidget(
                                                        title: 'GCS',
                                                        body: '${ttv.skorGcs}',
                                                        colorBody: Color(
                                                            int.parse(ttv
                                                                .colorGcs!
                                                                .body!)),
                                                        colorText: Color(
                                                            int.parse(ttv
                                                                .colorGcs!
                                                                .text!)),
                                                      ),
                                                      Divider(
                                                        height: 0,
                                                        color: Colors.black,
                                                      ),
                                                      RowTtvCpptWidget(
                                                        title: 'Kesadaran',
                                                        body:
                                                            '${ttv.kesadaran}',
                                                        colorBody: Color(
                                                            int.parse(ttv
                                                                .colorKesadaran!
                                                                .body!)),
                                                        colorText: Color(
                                                            int.parse(ttv
                                                                .colorKesadaran!
                                                                .text!)),
                                                      ),
                                                      Divider(
                                                        height: 0,
                                                        color: Colors.black,
                                                      ),
                                                      RowTtvCpptWidget(
                                                        title: 'TD Sistolik',
                                                        body:
                                                            '${ttv.tdSistolik} mmHg',
                                                        colorBody: Color(
                                                            int.parse(ttv
                                                                .colorSistolik!
                                                                .body!)),
                                                        colorText: Color(
                                                            int.parse(ttv
                                                                .colorSistolik!
                                                                .text!)),
                                                      ),
                                                      Divider(
                                                        height: 0,
                                                        color: Colors.black,
                                                      ),
                                                      RowTtvCpptWidget(
                                                        title: 'TD Diastolik',
                                                        body:
                                                            '${ttv.tdDiastolik} mmHg',
                                                      ),
                                                      Divider(
                                                        height: 0,
                                                        color: Colors.black,
                                                      ),
                                                      RowTtvCpptWidget(
                                                        title: 'Nadi',
                                                        body:
                                                            '${ttv.nadi} x/menit',
                                                        colorBody: Color(
                                                            int.parse(ttv
                                                                .colorNadi!
                                                                .body!)),
                                                        colorText: Color(
                                                            int.parse(ttv
                                                                .colorNadi!
                                                                .text!)),
                                                      ),
                                                      Divider(
                                                        height: 0,
                                                        color: Colors.black,
                                                      ),
                                                      RowTtvCpptWidget(
                                                        title: 'Pernapasan',
                                                        body:
                                                            '${ttv.pernapasan} x/menit',
                                                        colorBody: Color(
                                                            int.parse(ttv
                                                                .colorPernapasan!
                                                                .body!)),
                                                        colorText: Color(
                                                            int.parse(ttv
                                                                .colorPernapasan!
                                                                .text!)),
                                                      ),
                                                      Divider(
                                                        height: 0,
                                                        color: Colors.black,
                                                      ),
                                                      RowTtvCpptWidget(
                                                        title: 'Suhu',
                                                        body:
                                                            '${ttv.suhu} \xB0C',
                                                        colorBody: Color(
                                                            int.parse(ttv
                                                                .colorSuhu!
                                                                .body!)),
                                                        colorText: Color(
                                                            int.parse(ttv
                                                                .colorSuhu!
                                                                .text!)),
                                                      ),
                                                      Divider(
                                                        height: 0,
                                                        color: Colors.black,
                                                      ),
                                                      RowTtvCpptWidget(
                                                        title: 'Sat. Oksigen',
                                                        body:
                                                            '${ttv.saturasiOksigen} %',
                                                        colorBody: Color(
                                                            int.parse(ttv
                                                                .colorOksigen!
                                                                .body!)),
                                                        colorText: Color(
                                                            int.parse(ttv
                                                                .colorOksigen!
                                                                .text!)),
                                                      ),
                                                      Divider(
                                                        height: 0,
                                                        color: Colors.black,
                                                      ),
                                                      if (ttv.nyeri == 'Ya')
                                                        RowTtvCpptWidget(
                                                          title: 'Skala Nyeri',
                                                          body:
                                                              '${ttv.skalaNyeri}',
                                                        )
                                                      else
                                                        RowTtvCpptWidget(
                                                          title: 'Skala Nyeri',
                                                          body: '${ttv.nyeri}',
                                                        ),
                                                      if (ttv.nyeri == 'Ya')
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black,
                                                        ),
                                                      if (ttv.nyeri == 'Ya')
                                                        RowTtvCpptWidget(
                                                          title:
                                                              'Pencetus Nyeri',
                                                          body:
                                                              '${ttv.pencetusNyeri}',
                                                        ),
                                                      if (ttv.nyeri == 'Ya')
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black,
                                                        ),
                                                      if (ttv.nyeri == 'Ya')
                                                        RowTtvCpptWidget(
                                                          title:
                                                              'Gambaran Nyeri',
                                                          body:
                                                              '${ttv.gambaranNyeri}',
                                                        ),
                                                      if (ttv.nyeri == 'Ya')
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black,
                                                        ),
                                                      if (ttv.nyeri == 'Ya')
                                                        RowTtvCpptWidget(
                                                          title: 'Lokasi Nyeri',
                                                          body:
                                                              '${ttv.lokasiNyeri}',
                                                        ),
                                                      if (ttv.nyeri == 'Ya')
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black,
                                                        ),
                                                      if (ttv.nyeri == 'Ya')
                                                        RowTtvCpptWidget(
                                                          title: 'Durasi Nyeri',
                                                          body:
                                                              '${ttv.durasiNyeri}',
                                                        ),
                                                      Divider(
                                                        height: 0,
                                                        color: Colors.black,
                                                      ),
                                                      RowTtvCpptWidget(
                                                        title: 'BAB',
                                                        body: '${ttv.bab}',
                                                      ),
                                                      Divider(
                                                        height: 0,
                                                        color: Colors.black,
                                                      ),
                                                      RowTtvCpptWidget(
                                                        title: 'BAK',
                                                        body: '${ttv.bak}',
                                                      ),
                                                      Divider(
                                                        height: 0,
                                                        color: Colors.black,
                                                      ),
                                                      RowTtvCpptWidget(
                                                        title:
                                                            'Balance Cairan Input',
                                                        body:
                                                            'Total: ${ttv.totalBcInput} cc\nOral: ${ttv.bcInputOral} cc\nParenteral: ${ttv.bcInputParenteral} cc',
                                                      ),
                                                      Divider(
                                                        height: 0,
                                                        color: Colors.black,
                                                      ),
                                                      RowTtvCpptWidget(
                                                        title:
                                                            'Balance Cairan Output',
                                                        body:
                                                            'Total: ${ttv.totalBcOutput} cc\nMuntah: ${ttv.bcOutputMuntah} cc\nKemih: ${ttv.bcOutputKemih} cc',
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8.0,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 22,
                                                  child: Center(
                                                    child: Text(
                                                      'A',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                                const Text(':'),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        soapPerawat.assesmentText ==
                                                                null
                                                            ? '-'
                                                            : '${soapPerawat.assesmentText}',
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      const Text(
                                                        'Diagnosa Perawat',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey),
                                                      ),
                                                      ...soapPerawat.assesment!
                                                          .map(
                                                        (assesment) =>
                                                            BulletWidget(
                                                          title:
                                                              '${assesment.diagnosa}',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8.0,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 22,
                                                  child: Center(
                                                    child: Text(
                                                      'P',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                                const Text(':'),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        soapPerawat.planningText ==
                                                                null
                                                            ? '-'
                                                            : '${soapPerawat.planningText}',
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      const Text(
                                                        'Rencana Keperawatan',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey),
                                                      ),
                                                      ...soapPerawat.planning!
                                                          .map(
                                                        (planning) =>
                                                            BulletWidget(
                                                          title:
                                                              '${planning.namaTindakan}',
                                                          subtitle: Text(
                                                            '${planning.namaDiagnosa}',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        ),
                                                      ),
                                                      if (soapPerawat
                                                          .tindakanPerawat!
                                                          .isNotEmpty)
                                                        SizedBox(
                                                          height: 12,
                                                        ),
                                                      if (soapPerawat
                                                          .tindakanPerawat!
                                                          .isNotEmpty)
                                                        const Text(
                                                          'Tindakan Keperawatan',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      if (soapPerawat
                                                          .tindakanPerawat!
                                                          .isNotEmpty)
                                                        ...soapPerawat
                                                            .tindakanPerawat!
                                                            .map(
                                                          (tindakan) =>
                                                              BulletWidget(
                                                            title:
                                                                '${tindakan.namaTindakan}',
                                                          ),
                                                        ),
                                                      if (soapPerawat
                                                          .barangHabisPakai!
                                                          .isNotEmpty)
                                                        SizedBox(
                                                          height: 12,
                                                        ),
                                                      if (soapPerawat
                                                          .barangHabisPakai!
                                                          .isNotEmpty)
                                                        const Text(
                                                          'Barang Habis Pakai',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      if (soapPerawat
                                                          .barangHabisPakai!
                                                          .isNotEmpty)
                                                        ...soapPerawat
                                                            .barangHabisPakai!
                                                            .map(
                                                          (bhp) => BulletWidget(
                                                            title:
                                                                '${bhp.namaBarang}',
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: CpptViewCardWidget(
                                                title: 'Petugas',
                                                data:
                                                    Text('${cppt.namaPegawai}'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      var sbar = cppt.cpptable as CpptableSbar;
                      return Column(
                        children: [
                          IntrinsicHeight(
                            child: Container(
                              decoration: BoxDecoration(
                                color: cppt.profesi == 'Dokter'
                                    ? Colors.blue.withValues(alpha: 0.1)
                                    : Colors.red.withValues(alpha: 0.1),
                                border: _dataCppt.indexOf(cppt) != 0
                                    ? Border(
                                        top: BorderSide(
                                            color: Colors.grey[300]!, width: 4),
                                      )
                                    : null,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 18.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            '${cppt.tanggal}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            '${cppt.jam}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(22),
                                            ),
                                            child: Text(
                                              '${cppt.profesi}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const VerticalDivider(
                                    width: 0,
                                    color: Colors.grey,
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 18.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 22,
                                                child: Center(
                                                  child: Text(
                                                    'S',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                              const Text(':'),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                '${sbar.situation}',
                                                textAlign: TextAlign.justify,
                                              ))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 22,
                                                child: Center(
                                                  child: Text(
                                                    'B',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                              const Text(':'),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                '${sbar.background}',
                                                textAlign: TextAlign.justify,
                                              ))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 22,
                                                child: Center(
                                                  child: Text(
                                                    'A',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                              const Text(':'),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Diagnosa ICD 10',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                    ),
                                                    ...sbar.assesment!.map(
                                                      (diagnosa) =>
                                                          BulletWidget(
                                                        title:
                                                            '${diagnosa.kodeIcd10} - ${diagnosa.namaDiagnosa}',
                                                        subtitle: Text(
                                                          '${diagnosa.type}',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color: diagnosa
                                                                          .type ==
                                                                      'Primary'
                                                                  ? kGreenColor
                                                                  : kSecondaryColor),
                                                        ),
                                                      ),
                                                    ),
                                                    if (sbar.diagnosaIcd9!
                                                        .isNotEmpty)
                                                      const Text(
                                                        'Diagnosa ICD 9',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey),
                                                      ),
                                                    if (sbar.diagnosaIcd9!
                                                        .isNotEmpty)
                                                      ...sbar.diagnosaIcd9!.map(
                                                          (diagnosa) =>
                                                              BulletWidget(
                                                                title:
                                                                    '${diagnosa.kodeIcd9} - ${diagnosa.namaDiagnosa}',
                                                                subtitle: Text(
                                                                  '${diagnosa.type}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: diagnosa.type ==
                                                                              'Primary'
                                                                          ? kGreenColor
                                                                          : kSecondaryColor),
                                                                ),
                                                              ))
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 22,
                                                child: Center(
                                                  child: Text(
                                                    'R',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                              const Text(':'),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${sbar.recomendation}',
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                    if (sbar
                                                        .tindakan!.isNotEmpty)
                                                      CpptViewCardWidget(
                                                        title: 'Tindakan',
                                                        data: Column(
                                                          children:
                                                              sbar.tindakan!
                                                                  .map(
                                                                    (tindakan) =>
                                                                        Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              BulletWidget(
                                                                            title:
                                                                                '${tindakan.namaTindakan}',
                                                                          ),
                                                                        ),
                                                                        if (tindakan.foc ==
                                                                            1)
                                                                          SizedBox(
                                                                            width:
                                                                                12,
                                                                          ),
                                                                        if (tindakan.foc ==
                                                                            1)
                                                                          Container(
                                                                            width:
                                                                                42,
                                                                            margin:
                                                                                EdgeInsets.only(top: 2),
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: 2),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.green,
                                                                              borderRadius: BorderRadius.circular(32),
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                'FOC',
                                                                                style: TextStyle(fontSize: 10, color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          )
                                                                      ],
                                                                    ),
                                                                  )
                                                                  .toList(),
                                                        ),
                                                      ),
                                                    if (sbar.obatInjeksi!
                                                        .isNotEmpty)
                                                      CpptViewCardWidget(
                                                        title: 'Obat Injeksi',
                                                        data: Column(
                                                          children: sbar
                                                              .obatInjeksi!
                                                              .map((obat) =>
                                                                  BulletWidget(
                                                                    title:
                                                                        '${obat.namaBarang}',
                                                                    subtitle: Text(
                                                                        '${obat.jumlah} buah - ${obat.aturanPakai}'),
                                                                  ))
                                                              .toList(),
                                                        ),
                                                      ),
                                                    if (sbar.bhp!.isNotEmpty)
                                                      CpptViewCardWidget(
                                                        title:
                                                            'Barang Habis Pakai',
                                                        data: Column(
                                                          children: sbar.bhp!
                                                              .map(
                                                                (bhp) =>
                                                                    BulletWidget(
                                                                  title:
                                                                      '${bhp.namaBarang}',
                                                                  subtitle: Text(
                                                                      '${bhp.jumlah} buah'),
                                                                ),
                                                              )
                                                              .toList(),
                                                        ),
                                                      ),
                                                    if (sbar.resep!.isNotEmpty)
                                                      CpptViewCardWidget(
                                                        title: 'Obat Oral',
                                                        data: Column(
                                                          children: sbar.resep!
                                                              .map((resep) =>
                                                                  BulletWidget(
                                                                    title:
                                                                        '${resep.namaBarang}',
                                                                    subtitle: Text(
                                                                        '${resep.jumlah} buah - ${resep.aturanPakai}'),
                                                                  ))
                                                              .toList(),
                                                        ),
                                                      ),
                                                    if (sbar.resepRacikan!
                                                        .isNotEmpty)
                                                      CpptViewCardWidget(
                                                        title: 'Obat Racikan',
                                                        data: Column(
                                                          children:
                                                              sbar.resepRacikan!
                                                                  .map(
                                                                    (racikan) =>
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border.all(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            width:
                                                                                0.5),
                                                                      ),
                                                                      margin: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              4),
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              8.0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          const SizedBox(
                                                                            height:
                                                                                4,
                                                                          ),
                                                                          const Text(
                                                                            'Nama Racikan',
                                                                            style:
                                                                                TextStyle(fontSize: 13.0, color: Colors.grey),
                                                                          ),
                                                                          Text(
                                                                              '${racikan.namaRacikan}'),
                                                                          const SizedBox(
                                                                            height:
                                                                                4.0,
                                                                          ),
                                                                          const Text(
                                                                            'Barang/Obat',
                                                                            style:
                                                                                TextStyle(fontSize: 13.0, color: Colors.grey),
                                                                          ),
                                                                          Column(
                                                                              children: ListTile.divideTiles(
                                                                            context:
                                                                                context,
                                                                            tiles: racikan.barangRacikan!
                                                                                .map((barang) => BulletWidget(
                                                                                      title: '${barang.namaBarang}',
                                                                                      subtitle: Text('Dosis: ${barang.dosis}'),
                                                                                    ))
                                                                                .toList(),
                                                                          ).toList()),
                                                                          const SizedBox(
                                                                            height:
                                                                                4,
                                                                          ),
                                                                          const Text(
                                                                            'Petunjuk',
                                                                            style:
                                                                                TextStyle(fontSize: 13.0, color: Colors.grey),
                                                                          ),
                                                                          Text(
                                                                              '${racikan.petunjuk}'),
                                                                          const SizedBox(
                                                                            height:
                                                                                4.0,
                                                                          ),
                                                                          const Text(
                                                                            'Aturan pakai',
                                                                            style:
                                                                                TextStyle(fontSize: 13.0, color: Colors.grey),
                                                                          ),
                                                                          Text(
                                                                              '${racikan.aturanPakai}'),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                  .toList(),
                                                        ),
                                                      ),
                                                    if (sbar.lab!.isNotEmpty)
                                                      CpptViewCardWidget(
                                                        title: 'Laboratorium',
                                                        data: Column(
                                                          children: sbar.lab!
                                                              .map((lab) =>
                                                                  BulletWidget(
                                                                    title:
                                                                        '${lab.namaTindakanLab}',
                                                                  ))
                                                              .toList(),
                                                        ),
                                                      ),
                                                    if (sbar.rad!.isNotEmpty)
                                                      CpptViewCardWidget(
                                                        title: 'Radiologi',
                                                        data: Column(
                                                          children: sbar.rad!
                                                              .map((rad) =>
                                                                  BulletWidget(
                                                                    title:
                                                                        '${rad.namaTindakanRad}',
                                                                  ))
                                                              .toList(),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 0.5,
                                                color: kSecondaryColor,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Text(
                                                      'TBAK telah dilakukan dengan benar'),
                                                ),
                                                const Divider(
                                                  height: 0,
                                                  color: kSecondaryColor,
                                                ),
                                                IntrinsicHeight(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                'Pemberi Instruksi',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                            ),
                                                            const Divider(
                                                              height: 0,
                                                              color:
                                                                  kSecondaryColor,
                                                            ),
                                                            if (sbar.confirmAt ==
                                                                null)
                                                              const Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            22.0),
                                                                child: Text(
                                                                  'Menunggu konfirmasi Penerima Sbar',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic),
                                                                ),
                                                              )
                                                            else
                                                              Column(
                                                                children: [
                                                                  TileDataCard(
                                                                    title:
                                                                        'Tanggal',
                                                                    body: Text(
                                                                        '${sbar.confirmAt}'),
                                                                  ),
                                                                  TileDataCard(
                                                                    title:
                                                                        'Jam',
                                                                    body: Text(
                                                                        '${sbar.jamConfirm}'),
                                                                  ),
                                                                  TileDataCard(
                                                                    title:
                                                                        'Nama',
                                                                    body: Text(
                                                                        '${sbar.pemberiInstruksi?.namaPegawai}'),
                                                                  ),
                                                                ],
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        child: VerticalDivider(
                                                          width: 0,
                                                          color: Colors.red,
                                                        ),
                                                        // height: 120,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                'Penerima Instruksi',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                            ),
                                                            const Divider(
                                                              height: 0,
                                                              color:
                                                                  kSecondaryColor,
                                                            ),
                                                            TileDataCard(
                                                              title: 'Tanggal',
                                                              body: Text(
                                                                  '${cppt.tanggal}'),
                                                            ),
                                                            TileDataCard(
                                                              title: 'Jam',
                                                              body: Text(
                                                                  '${cppt.jam}'),
                                                            ),
                                                            TileDataCard(
                                                              title: 'Nama',
                                                              body: Text(
                                                                  '${cppt.namaPegawai}'),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(8),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                          width:
                                                                              0.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              32),
                                                                ),
                                                                child:
                                                                    const Text(
                                                                  'SBAR',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: CpptViewCardWidget(
                                              title: 'Petugas',
                                              data: Text('${cppt.namaPegawai}'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  if (order.isVerifier!)
                    const Divider(
                      height: 0,
                      thickness: 5,
                    ),
                  if (order.isVerifier!)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 8,
                      ),
                      color: order.verifiedAt == null
                          ? Colors.orangeAccent[100]
                          : kGreenColor.withValues(alpha: 0.2),
                      child: order.verifiedAt == null
                          ? Text(
                              'Tanggal: ${_tanggalFormat.format(DateTime.parse(order.tanggal!))}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: DeskripsiWidget(
                                    title: 'Tanggal',
                                    body: Text('${order.verifiedAt}'),
                                  ),
                                ),
                                Expanded(
                                  child: DeskripsiWidget(
                                    title: 'Dokter',
                                    body: Text('${order.verifiedBy}'),
                                  ),
                                ),
                              ],
                            ),
                    )
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class CpptOrder {
  String? tanggal;
  int? pegawaiId;
  List<DataCppt>? cppt;
  String? verifiedAt;
  String? verifiedBy;
  bool? isVerifier;
  CpptOrder({
    this.tanggal,
    this.pegawaiId,
    this.cppt,
    this.verifiedAt,
    this.verifiedBy,
    this.isVerifier = false,
  });
}

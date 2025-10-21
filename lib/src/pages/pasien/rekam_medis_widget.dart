import 'package:admin_dokter_panggil/src/blocs/resume_pemeriksaan_pasien_bloc.dart';
import 'package:admin_dokter_panggil/src/models/resume_pemeriksaan_pasien_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/resume_pemeriksaan_pasien_page.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';

class RekamMedisWidget extends StatefulWidget {
  const RekamMedisWidget({
    super.key,
    required this.idKunjungan,
    required this.idPetugas,
  });
  final int idKunjungan;
  final int idPetugas;

  @override
  State<RekamMedisWidget> createState() => _RekamMedisWidgetState();
}

class _RekamMedisWidgetState extends State<RekamMedisWidget> {
  final _resumePemeriksaanPasienBloc = ResumePemeriksaanPasienBloc();

  @override
  void initState() {
    super.initState();
    _getRiwayatPemeriksaanPasien();
  }

  void _getRiwayatPemeriksaanPasien() {
    _resumePemeriksaanPasienBloc.idKunjunganSink.add(widget.idKunjungan);
    _resumePemeriksaanPasienBloc.idPetugasSink.add(widget.idPetugas);
    _resumePemeriksaanPasienBloc.getResumePemeriksaanPasien();
  }

  @override
  void dispose() {
    _resumePemeriksaanPasienBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseResumePemeriksaanPasienModel>>(
      stream: _resumePemeriksaanPasienBloc.resumePemeriksaanPasienStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 200,
                child: LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () {
                  _resumePemeriksaanPasienBloc.getResumePemeriksaanPasien();
                  setState(() {});
                },
              );
            case Status.completed:
              var data = snapshot.data!.data!.data;
              return ListView(
                padding:
                    const EdgeInsets.fromLTRB(22, 22, 22, kToolbarHeight + 22),
                children: [
                  Container(
                    padding: const EdgeInsets.all(22.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: Offset(3.0, 3.0))
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Layanan pemeriksaan',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        const Divider(
                          height: 32.0,
                        ),
                        if (data!.kunjunganTindakan!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: TilePemeriksaanWidget(
                              title: 'Tindakan',
                              subtitle: Column(
                                children: data.kunjunganTindakan!
                                    .map(
                                      (tindakan) => ListDataPemeriksaan(
                                        data: tindakan.namaTindakan,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        if (data.diagnosaDokter!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: TilePemeriksaanWidget(
                              title: 'Diagnosa',
                              subtitle: Column(
                                children: data.diagnosaDokter!
                                    .map((diagnosa) => ListDataPemeriksaan(
                                          data: diagnosa.namaDiagnosa,
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        if (data.anamnesaDokter!.isNotEmpty)
                          Padding(
                              padding: const EdgeInsets.only(bottom: 18.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 18.0),
                                    child: TilePemeriksaanWidget(
                                      title: 'Keluhan utama',
                                      subtitle: Column(
                                        children: data.anamnesaDokter!
                                            .map((anamnesa) =>
                                                ListDataPemeriksaan(
                                                  data: anamnesa.keluhanUtama,
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 18.0),
                                    child: TilePemeriksaanWidget(
                                      title: 'Riwayat penyakit sebelumnya',
                                      subtitle: Column(
                                        children: data.anamnesaDokter!
                                            .map((anamnesa) =>
                                                ListDataPemeriksaan(
                                                  data: anamnesa
                                                          .riwayatPenyakitSebelumnya ??
                                                      '-',
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  TilePemeriksaanWidget(
                                    title: 'Riwayat penyakit sekarang',
                                    subtitle: Column(
                                      children: data.anamnesaDokter!
                                          .map(
                                              (anamnesa) => ListDataPemeriksaan(
                                                    data: anamnesa
                                                            .riwayatPenyakitSekarang ??
                                                        '-',
                                                  ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              )),
                        if (data.fisikDokter!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              children: data.fisikDokter!
                                  .map(
                                    (fisik) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GridView.count(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          crossAxisCount: 2,
                                          shrinkWrap: true,
                                          childAspectRatio: 3 / 1,
                                          children: [
                                            TilePemeriksaanFisik(
                                              title: 'Tekanan darah',
                                              subtitle: '${fisik.tekananDarah}',
                                            ),
                                            TilePemeriksaanFisik(
                                              title: 'Nadi',
                                              subtitle: '${fisik.nadi}',
                                            ),
                                            TilePemeriksaanFisik(
                                              title: 'Pernafasan',
                                              subtitle: '${fisik.pernafasan}',
                                            ),
                                            TilePemeriksaanFisik(
                                              title: 'Suhu',
                                              subtitle: '${fisik.suhu}',
                                            ),
                                            TilePemeriksaanFisik(
                                              title: 'Berat badan',
                                              subtitle: '${fisik.beratBadan}',
                                            ),
                                            TilePemeriksaanFisik(
                                              title: 'Tinggi badan',
                                              subtitle: '${fisik.tinggiBadan}',
                                            ),
                                          ],
                                        ),
                                        if (fisik.catatan != null)
                                          TilePemeriksaanFisik(
                                            title: 'Catatan Pemeriksaan Fisik',
                                            subtitle: '${fisik.catatan}',
                                          )
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        if (data.diagnosaPerawat!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: TilePemeriksaanWidget(
                              title: 'Diagnosa Perawat',
                              subtitle: Column(
                                children: data.diagnosaPerawat!
                                    .map(
                                      (diagnosa) => ListDataPemeriksaan(
                                        data: diagnosa.catatanDiagnosa,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        if (data.anamnesaPerawat!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 18.0),
                                  child: TilePemeriksaanWidget(
                                    title: 'Keluhan utama',
                                    subtitle: Column(
                                      children: data.anamnesaPerawat!
                                          .map(
                                            (anamnesa) => ListDataPemeriksaan(
                                              data: anamnesa.keluhanUtama,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 18.0),
                                  child: TilePemeriksaanWidget(
                                    title: 'Riwayat penyakit sebelumnya',
                                    subtitle: Column(
                                      children: data.anamnesaPerawat!
                                          .map(
                                            (anamnesa) => ListDataPemeriksaan(
                                              data: anamnesa
                                                  .riwayatPenyakitSebelumnya,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                                TilePemeriksaanWidget(
                                  title: 'Riwayat penyakit sekarang',
                                  subtitle: Column(
                                    children: data.anamnesaPerawat!
                                        .map(
                                          (anamnesa) => ListDataPemeriksaan(
                                            data: anamnesa
                                                .riwayatPenyakitSekarang,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (data.fisikPerawat!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              children: data.fisikPerawat!
                                  .map(
                                    (fisik) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GridView.count(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          crossAxisCount: 2,
                                          shrinkWrap: true,
                                          childAspectRatio: 3 / 1,
                                          children: [
                                            TilePemeriksaanFisik(
                                              title: 'Tekanan darah',
                                              subtitle: '${fisik.tekananDarah}',
                                            ),
                                            TilePemeriksaanFisik(
                                              title: 'Nadi',
                                              subtitle: '${fisik.nadi}',
                                            ),
                                            TilePemeriksaanFisik(
                                              title: 'Pernafasan',
                                              subtitle: '${fisik.pernafasan}',
                                            ),
                                            TilePemeriksaanFisik(
                                              title: 'Suhu',
                                              subtitle: '${fisik.suhu}',
                                            ),
                                            TilePemeriksaanFisik(
                                              title: 'Berat badan',
                                              subtitle: '${fisik.beratBadan}',
                                            ),
                                            TilePemeriksaanFisik(
                                              title: 'Tinggi badan',
                                              subtitle: '${fisik.tinggiBadan}',
                                            ),
                                          ],
                                        ),
                                        if (fisik.catatan != null)
                                          TilePemeriksaanFisik(
                                            title: 'Catatan Pemeriksaan Fisik',
                                            subtitle: '${fisik.catatan}',
                                          )
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        if (data.resep!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: TilePemeriksaanWidget(
                              title: 'Resep',
                              subtitle: Column(
                                children: data.resep!
                                    .map((resep) => ListDataPemeriksaan(
                                        data: resep.catatanTambahan != null
                                            ? '${resep.barang} / ${resep.jumlah} buah / ${resep.aturanPakai} /${resep.catatanTambahan}'
                                            : '${resep.barang} / ${resep.jumlah} buah / ${resep.aturanPakai} '))
                                    .toList(),
                              ),
                            ),
                          ),
                        if (data.resepRacikan!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: TilePemeriksaanWidget(
                              title: 'Resep Racikan',
                              subtitle: Column(
                                children: data.resepRacikan!
                                    .map(
                                      (resep) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Petunjuk: ${resep.petunjuk} / Aturan pakai: ${resep.aturanPakai}'),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: resep.barang!
                                                .map((barang) => Row(
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .arrow_right_rounded,
                                                          color: Colors.grey,
                                                        ),
                                                        Expanded(
                                                            child: ListTile(
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          dense: true,
                                                          title: Text(
                                                              '${barang.barang}'),
                                                          subtitle: Text(
                                                              '${barang.dosis}'),
                                                        ))
                                                      ],
                                                    ))
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        if (data.planningPerawat!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: TilePemeriksaanWidget(
                              title: 'Planning perawat',
                              subtitle: Column(
                                children: data.planningPerawat!
                                    .map((planning) => Text(
                                          '${planning.catatan}',
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        if (data.implementasiPerawat!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: TilePemeriksaanWidget(
                              title: 'Implementasi perawat',
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: data.implementasiPerawat!
                                    .map((implementasi) => Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 4.0, right: 4),
                                              child: Icon(
                                                Icons.arrow_right_rounded,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Flexible(
                                              child: ListTile(
                                                dense: true,
                                                isThreeLine: true,
                                                contentPadding: EdgeInsets.zero,
                                                minVerticalPadding: 8,
                                                titleTextStyle: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black),
                                                title: Text(
                                                  '${implementasi.tindakan}',
                                                ),
                                                subtitle: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Tanggal: ',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color:
                                                              Colors.grey[600]),
                                                    ),
                                                    const SizedBox(
                                                      width: 8.0,
                                                    ),
                                                    Text('${implementasi.jam}'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        if (data.bhp!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: TilePemeriksaanWidget(
                              title: 'Consume',
                              subtitle: Column(
                                children: data.bhp!
                                    .map(
                                      (bhp) => ListDataPemeriksaan(
                                        data: bhp.barang!.namaBarang,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        if (data.obatInjeksi!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: TilePemeriksaanWidget(
                              title: 'Obat Injeksi',
                              subtitle: Column(
                                children: data.obatInjeksi!
                                    .map((injeksi) => ListDataPemeriksaan(
                                          data: injeksi.barang!.namaBarang,
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        if (data.tindakanLab!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: TilePemeriksaanWidget(
                              title: 'Tindakan laboratorium',
                              subtitle: Column(
                                children: data.tindakanLab!
                                    .map((lab) => ListDataPemeriksaan(
                                          data: lab.tindakanLab,
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        if (data.tindakanRad!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: TilePemeriksaanWidget(
                              title: 'Tindakan radiologi',
                              subtitle: Column(
                                children: data.tindakanRad!
                                    .map((rad) => ListDataPemeriksaan(
                                          data: rad.tindakanRad,
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

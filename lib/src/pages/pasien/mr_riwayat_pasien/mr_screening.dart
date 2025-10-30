import 'package:admin_dokter_panggil/src/blocs/mr_kunjungan_skrining_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_skrining_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_detail_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_card_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class MrScreening extends StatefulWidget {
  const MrScreening({
    super.key,
    this.data,
  });

  final MrRiwayatDetail? data;

  @override
  State<MrScreening> createState() => _MrScreeningState();
}

class _MrScreeningState extends State<MrScreening> {
  final _mrKunjunganSkriningBloc = MrKunjunganSkriningBloc();

  @override
  void initState() {
    super.initState();
    _getSkrining();
  }

  void _getSkrining() {
    _mrKunjunganSkriningBloc.idKunjunganSink.add(widget.data!.id!);
    _mrKunjunganSkriningBloc.getSkrining();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MrKunjunganSkriningModel>>(
      stream: _mrKunjunganSkriningBloc.skriningStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: kPrimaryColor,
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () {
                  _getSkrining();
                  setState(() {});
                },
              );
            case Status.completed:
              if (snapshot.data!.data!.data!.skriningPasien == null) {
                return ErrorResponse(
                  message: 'Data skrining tidak tersedia',
                  onTap: () {
                    _getSkrining();
                    setState(() {});
                  },
                );
              }
              var skrining = snapshot.data!.data!.data!.skriningPasien;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DashboardCardWidget(
                      title: 'Screening visual',
                      errorMessage: 'Data screening visual tidak tersedia',
                      dataCard: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Tanda dan Gejala',
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                              subtitle: Text(
                                '${skrining!.skrining!.skrining}',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (skrining.resikoJatuh != null)
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: const Text(
                                            'Resiko Jatuh',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey),
                                          ),
                                          subtitle: Text(
                                            '${skrining.resikoJatuh}',
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      const Text(
                                        'Keputusan',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.grey),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text('${skrining.skrining!.keputusan}'),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      if (skrining.keputusanResikoJatuh != null)
                                        Text('${skrining.keputusanResikoJatuh}')
                                    ],
                                  ),
                                ),
                                Wrap(
                                  direction: Axis.vertical,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    const Text(
                                      'Indikator',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Container(
                                      width: 72,
                                      height: 72,
                                      decoration: BoxDecoration(
                                          color: Color(
                                            int.parse(
                                                skrining.skrining!.warna!),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0)),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 12.0,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 6,
                      color: Colors.grey[300],
                    ),
                    DashboardCardWidget(
                      title: 'Data Pasien',
                      errorMessage: 'Data screening visual tidak tersedia',
                      dataCard: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Wrap(
                                    direction: Axis.vertical,
                                    spacing: 2,
                                    children: [
                                      const Text(
                                        'Nama pasien',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.grey),
                                      ),
                                      Text(
                                          '${skrining.pasienSkrining!.namaPasien}')
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Wrap(
                                    direction: Axis.vertical,
                                    spacing: 2,
                                    children: [
                                      const Text(
                                        'Tgl.lahir/Umur',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.grey),
                                      ),
                                      Text(
                                          '${skrining.pasienSkrining!.tanggalLahir}/${skrining.pasienSkrining!.umur}')
                                    ],
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
                                  child: Wrap(
                                    direction: Axis.vertical,
                                    spacing: 2,
                                    children: [
                                      const Text(
                                        'Nomor RM',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.grey),
                                      ),
                                      Text(
                                          '${skrining.pasienSkrining!.normSprint}')
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Wrap(
                                    direction: Axis.vertical,
                                    spacing: 2,
                                    children: [
                                      const Text(
                                        'Nomor Telepon',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.grey),
                                      ),
                                      Text(
                                          '${skrining.pasienSkrining!.nomorTelepon}')
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Wrap(
                              direction: Axis.vertical,
                              spacing: 2,
                              children: [
                                const Text(
                                  'Alamat',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                                Text('${skrining.pasienSkrining!.alamat}')
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (skrining.waliPasien != null)
                      Divider(
                        thickness: 6,
                        color: Colors.grey[300],
                      ),
                    if (skrining.waliPasien != null)
                      DashboardCardWidget(
                        title: 'Nama wali',
                        errorMessage: 'Data screening visual tidak tersedia',
                        dataCard: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Wrap(
                                      direction: Axis.vertical,
                                      spacing: 2,
                                      children: [
                                        const Text(
                                          'Nama Wali',
                                          style: TextStyle(
                                              fontSize: 13, color: Colors.grey),
                                        ),
                                        Text('${skrining.waliPasien?.namaWali}')
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Wrap(
                                      direction: Axis.vertical,
                                      spacing: 2,
                                      children: [
                                        const Text(
                                          'Hubungan',
                                          style: TextStyle(
                                              fontSize: 13, color: Colors.grey),
                                        ),
                                        Text('${skrining.waliPasien!.hubungan}')
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Wrap(
                                direction: Axis.vertical,
                                spacing: 2,
                                children: [
                                  const Text(
                                    'Nomor telepon',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  ),
                                  Text('${skrining.waliPasien!.nomorKontak}')
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

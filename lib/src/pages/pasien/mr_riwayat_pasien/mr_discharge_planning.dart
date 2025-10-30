import 'package:admin_dokter_panggil/src/blocs/mr_kunjungan_discharge_planning_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_discharge_planning_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_detail_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_card_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class MrDischargePlanning extends StatefulWidget {
  const MrDischargePlanning({
    super.key,
    this.data,
  });

  final MrRiwayatDetail? data;

  @override
  State<MrDischargePlanning> createState() => _MrDischargePlanningState();
}

class _MrDischargePlanningState extends State<MrDischargePlanning> {
  final _mrKunjunganDischargePlanningBloc = MrKunjunganDischargePlanningBloc();

  @override
  void initState() {
    super.initState();
    _getDischargePlanning();
  }

  void _getDischargePlanning() {
    _mrKunjunganDischargePlanningBloc.idKunjunganSink.add(widget.data!.id!);
    _mrKunjunganDischargePlanningBloc.getDischargePlanning();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MrKunjunganDischargePlanningModel>>(
      stream: _mrKunjunganDischargePlanningBloc.dischargePlanningStream,
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
                  _getDischargePlanning();
                  setState(() {});
                },
              );
            case Status.completed:
              return _mrDischargePlanningWidget(
                  context, snapshot.data!.data!.data!.dataDischargePlanning);
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _mrDischargePlanningWidget(
      BuildContext context, DataDischargePlanning? dischargePlanning) {
    if (dischargePlanning == null) {
      return _noDataDischargeWidget(context);
    }
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 22),
            children: [
              DashboardCardWidget(
                title: 'Skrining Faktor Resiko Pasien Pulang',
                errorMessage: 'Data skrining tidak bersedia',
                dataCard: dischargePlanning.dischargeSkrining!.isEmpty
                    ? null
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Column(
                          children: dischargePlanning.dischargeSkrining!
                              .map(
                                (skrining) => ListTile(
                                  leading: const Icon(
                                      Icons.keyboard_arrow_right_rounded),
                                  title: Text('${skrining.deskripsi}'),
                                  horizontalTitleGap: 0.0,
                                  minVerticalPadding: 0.0,
                                  trailing: Text(
                                    '${skrining.jawaban}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 4),
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
              if (dischargePlanning.dischargeRencana!.isNotEmpty)
                DashboardCardWidget(
                  title: 'Rencana Pulang/Discharge Planning',
                  errorMessage: 'Tidak ada data rencana pulang',
                  dataCard: dischargePlanning.dischargeRencana!.isEmpty
                      ? null
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            children: dischargePlanning.dischargeRencana!
                                .map((rencana) => ListTile(
                                      leading: const Icon(
                                          Icons.keyboard_arrow_right_rounded),
                                      title: Text('${rencana.rencana}'),
                                      horizontalTitleGap: 0.0,
                                      minVerticalPadding: 0.0,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 4),
                                    ))
                                .toList(),
                          ),
                        ),
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -4),
            )
          ]),
          child: SafeArea(
            top: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  isThreeLine: dischargePlanning.isUpdate!,
                  title: Text(
                    '${dischargePlanning.namaPegawai}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Simpan: ${dischargePlanning.createdAt}',
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      if (dischargePlanning.isUpdate!)
                        Text(
                          'Update: ${dischargePlanning.tanggal}',
                          style:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _noDataDischargeWidget(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'images/no_data.png',
              height: 180,
            ),
            const SizedBox(
              height: 12.0,
            ),
            const Center(
              child: Text(
                'Perhatian',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
              child: Center(
                child: Text(
                  'Data discahrge planning tidak tersedia',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

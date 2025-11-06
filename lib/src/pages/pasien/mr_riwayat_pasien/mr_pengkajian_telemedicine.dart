import 'package:admin_dokter_panggil/src/blocs/mr_pengkajian_telemedicine_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_pengkajian_telemedicine_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_card_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_sub_form_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/list_tile_data_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_anamnesa_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_diagnosa_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_dokumentasi_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_obat_injeksi_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_prosedur_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_rencana_terapi_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_resep_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_resep_racikan_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_tindakan_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_tindakan_lab_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_tindakan_rad_form.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class MrPengkajianTelemedicine extends StatefulWidget {
  const MrPengkajianTelemedicine({
    super.key,
    this.idKunjungan,
  });

  final int? idKunjungan;

  @override
  State<MrPengkajianTelemedicine> createState() =>
      _MrPengkajianTelemedicineState();
}

class _MrPengkajianTelemedicineState extends State<MrPengkajianTelemedicine> {
  final _mrPengkajianTelemedicineBloc = MrPengkajianTelemedicineBloc();

  @override
  void initState() {
    super.initState();
    _getPengkajianTelemedicine();
  }

  void _getPengkajianTelemedicine() {
    _mrPengkajianTelemedicineBloc.idKunjunganSink.add(widget.idKunjungan!);
    _mrPengkajianTelemedicineBloc.getPengkajianTelemedicine();
  }

  @override
  void dispose() {
    super.dispose();
    _mrPengkajianTelemedicineBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MrKunjunganTelemedicineModel>>(
      stream: _mrPengkajianTelemedicineBloc.pengkajianTelemedicineStream,
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
                  _getPengkajianTelemedicine();
                  setState(() {});
                },
              );
            case Status.completed:
              return PengkajianTelemedicineWidget(
                data: snapshot.data!.data!.data,
                idKunjungan: widget.idKunjungan,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class PengkajianTelemedicineWidget extends StatefulWidget {
  const PengkajianTelemedicineWidget({
    super.key,
    this.data,
    this.idKunjungan,
  });

  final DataMrKunjunganTemedicine? data;
  final int? idKunjungan;

  @override
  State<PengkajianTelemedicineWidget> createState() =>
      _PengkajianTelemedicineWidgetState();
}

class _PengkajianTelemedicineWidgetState
    extends State<PengkajianTelemedicineWidget> {
  DataMrKunjunganTemedicine? _data;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _data = widget.data!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                MrAnamnesaForm(
                  idKunjungan: widget.idKunjungan,
                  mrKunjunganAnamnesa: _data?.anamnesa,
                ),
                Divider(
                  color: Colors.grey[200],
                  thickness: 5,
                  height: 5,
                ),
                MrDokumentasiForm(
                  idKunjungan: widget.idKunjungan,
                  mrKunjunganDokumentasi: _data?.dokumentasi,
                ),
                Divider(
                  color: Colors.grey[200],
                  thickness: 5,
                  height: 5,
                ),
                DashboardCardWidget(
                  title: 'Diagnosa',
                  errorMessage: 'Data diagnosa tidak tersedia',
                  dataCard: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MrDiagnosaForm(
                        idKunjungan: widget.idKunjungan,
                        mrDiagnosaDokter: _data?.mrDiagnosaDokter,
                        mrDiagnosaIcdDokter: _data?.mrDiagnosaIcdDokter,
                      ),
                      Divider(
                        color: Colors.grey[200],
                        thickness: 5,
                        height: 5,
                      ),
                      MrProsedurForm(
                        idKunjungan: widget.idKunjungan,
                        mrProsedur: _data?.mrProsedur,
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                  thickness: 5,
                  height: 5,
                ),
                DashboardCardWidget(
                  title: 'Rencana Terapi',
                  errorMessage: 'Data rencana terapi tidak tersedia',
                  dataCard: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MrRencanaTerapiForm(
                        idKunjungan: widget.idKunjungan,
                        mrKunjunganRencanaTerapi: _data!.rencanaTerapi,
                      ),
                      const Divider(
                        height: 0,
                        color: Colors.grey,
                      ),
                      MrTindakanForm(
                        idKunjungan: widget.idKunjungan,
                        tindakan: _data?.kunjunganTindakan,
                      ),
                      Divider(
                        color: Colors.grey[200],
                        thickness: 5,
                        height: 5,
                      ),
                      MrObatInjeksiForm(
                        idKunjungan: widget.idKunjungan,
                        mrKunjunganObatInjeksi: _data?.kunjunganObatInjeksi,
                      ),
                      Divider(
                        color: Colors.grey[200],
                        thickness: 5,
                        height: 5,
                      ),
                      MrResepForm(
                        idKunjungan: widget.idKunjungan,
                        mrKunjunganResep: _data?.kunjunganResep,
                      ),
                      Divider(
                        color: Colors.grey[200],
                        thickness: 5,
                        height: 5,
                      ),
                      MrResepRacikanForm(
                        idKunjungan: widget.idKunjungan,
                        mrKunjunganResepRacikan: _data?.kunjunganResepRacikan,
                      ),
                      Divider(
                        color: Colors.grey[200],
                        thickness: 5,
                        height: 5,
                      ),
                      MrTindakanLabForm(
                        idKunjungan: widget.idKunjungan,
                        mrKunjunganTindakanLab: _data?.kunjunganTindakanLab,
                        dokumenLab: _data!.dokumenLab,
                      ),
                      Divider(
                        color: Colors.grey[200],
                        thickness: 5,
                        height: 5,
                      ),
                      MrTindakanRadForm(
                        idKunjungan: widget.idKunjungan,
                        mrKunjunganTindakanRad: _data?.kunjunganTindakanRad,
                        dokumenRad: _data?.dokumenRad,
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                  thickness: 5,
                  height: 5,
                ),
                if (_data!.layananLanjutan!.isNotEmpty)
                  DashboardSubFormWidget(
                    title: 'Layanan lanjutan',
                    dataCard: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _data!.layananLanjutan!
                          .map(
                            (lanjutan) => ListTileDataWidget(
                              title: Text('${lanjutan.namaLayanan}'),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
          ),
        ),
        if (_data!.selesaiLayanan != null)
          Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(-2, 0),
              )
            ]),
            padding: EdgeInsets.all(18),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${_data!.selesaiLayanan!.namaPegawai}',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          'Created at: ${_data!.selesaiLayanan!.createdAt}',
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[800]),
                        ),
                        Text(
                          'Updated at: ${_data!.selesaiLayanan!.updatedAt}',
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[800]),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:admin_dokter_panggil/src/blocs/mr_pengkajian_dokter_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_pengkajian_dokter_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_detail_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_card_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_anamnesa_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_diagnosa_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_obat_injeksi_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_pemeriksaan_fisis_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_prosedur_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_rencana_terapi_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_resep_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_resep_racikan_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_tindakan_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_tindakan_lab_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_tindakan_lanjutan_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_tindakan_rad_form.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class MrPengkajianDokter extends StatefulWidget {
  const MrPengkajianDokter({
    super.key,
    this.data,
  });

  final MrRiwayatDetail? data;

  @override
  State<MrPengkajianDokter> createState() => _MrPengkajianDokterState();
}

class _MrPengkajianDokterState extends State<MrPengkajianDokter> {
  final _mrPengkajianDokterBloc = MrPengkajianDokterBloc();

  @override
  void initState() {
    super.initState();
    _getPengkajian();
  }

  void _getPengkajian() {
    _mrPengkajianDokterBloc.idKunjunganSik.add(widget.data!.id!);
    _mrPengkajianDokterBloc.getPengkajianDokter();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<DataMrPengkajianDokter>>(
      stream: _mrPengkajianDokterBloc.pengkajianDokterStream,
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
                  _getPengkajian();
                  setState(() {});
                },
              );
            case Status.completed:
              return _mrPengkajianDokterWidget(context, snapshot.data!.data!);
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _mrPengkajianDokterWidget(
      BuildContext context, DataMrPengkajianDokter? pengkajian) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MrAnamnesaForm(
                  idKunjungan: widget.data!.id,
                  mrKunjunganAnamnesa: pengkajian!.anamnesa,
                ),
                Divider(
                  color: Colors.grey[200],
                  thickness: 5,
                  height: 5,
                ),
                MrPemeriksaanFisisForm(
                  idKunjungan: widget.data!.id,
                  mrKunjunganPemeriksaanFisis: pengkajian.pemeriksaanFisis,
                  pasien: widget.data!.pasien,
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
                        idKunjungan: widget.data!.id,
                        mrDiagnosaDokter: pengkajian.mrDiagnosaDokter,
                        mrDiagnosaIcdDokter: pengkajian.mrDiagnosaIcdDokter,
                      ),
                      const Divider(
                        height: 0,
                        color: Colors.grey,
                      ),
                      MrProsedurForm(
                        idKunjungan: widget.data!.id,
                        mrProsedur: pengkajian.mrProsedur,
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
                        idKunjungan: widget.data!.id,
                        mrKunjunganRencanaTerapi: pengkajian.rencanaTerapi,
                      ),
                      const Divider(
                        height: 0,
                        color: Colors.grey,
                      ),
                      MrTindakanForm(
                        idKunjungan: widget.data!.id,
                        tindakan: pengkajian.kunjunganTindakan,
                      ),
                      const Divider(
                        height: 0,
                        color: Colors.grey,
                      ),
                      MrObatInjeksiForm(
                        idKunjungan: widget.data!.id,
                        mrKunjunganObatInjeksi: pengkajian.kunjunganObatInjeksi,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const Divider(
                        height: 0,
                        color: Colors.grey,
                      ),
                      MrResepForm(
                        idKunjungan: widget.data!.id,
                        mrKunjunganResep: pengkajian.kunjunganResep!,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const Divider(
                        height: 0,
                        color: Colors.grey,
                      ),
                      MrResepRacikanForm(
                        idKunjungan: widget.data!.id,
                        mrKunjunganResepRacikan:
                            pengkajian.kunjunganResepRacikan,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const Divider(
                        height: 0,
                        color: Colors.grey,
                      ),
                      MrTindakanLabForm(
                        idKunjungan: widget.data!.id,
                        mrKunjunganTindakanLab: pengkajian.kunjunganTindakanLab,
                        dokumenLab: pengkajian.dokumenLab,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const Divider(
                        height: 0,
                        color: Colors.grey,
                      ),
                      MrTindakanRadForm(
                        idKunjungan: widget.data!.id,
                        mrKunjunganTindakanRad: pengkajian.kunjunganTindakanRad,
                        dokumenRad: pengkajian.dokumenRad,
                      ),
                    ],
                  ),
                ),
                if (pengkajian.layananLanjutan != null)
                  const Divider(
                    height: 0,
                    color: Colors.grey,
                  ),
                if (pengkajian!.layananLanjutan != null)
                  MrTindakanLanjutanForm(
                    idKunjungan: widget.data!.id,
                    layananLanjutan: pengkajian.layananLanjutan,
                  ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

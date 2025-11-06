import 'package:admin_dokter_panggil/src/blocs/mr_kunjungan_resume_medis_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_resume_medis_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/deskripsi_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class MrResumeMedis extends StatefulWidget {
  const MrResumeMedis({
    super.key,
    this.idKunjungan,
  });

  final int? idKunjungan;

  @override
  State<MrResumeMedis> createState() => _MrResumeMedisState();
}

class _MrResumeMedisState extends State<MrResumeMedis> {
  final _mrKunjunganResumeMedisBloc = MrKunjunganResumeMedisBloc();

  @override
  void initState() {
    super.initState();
    _getResumeMedis();
  }

  void _getResumeMedis() {
    _mrKunjunganResumeMedisBloc.idKunjunganSink.add(widget.idKunjungan!);
    _mrKunjunganResumeMedisBloc.getResumeMedis();
  }

  @override
  void dispose() {
    super.dispose();
    _mrKunjunganResumeMedisBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MrKunjunganResumeMedisModel>>(
      stream: _mrKunjunganResumeMedisBloc.resumeMedisStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: kPrimaryColor,
              );
            case Status.error:
              return Center(
                child: SingleChildScrollView(
                  child: ErrorResponse(
                    message: snapshot.data!.message,
                    onTap: () {
                      _getResumeMedis();
                      setState(() {});
                    },
                  ),
                ),
              );
            case Status.completed:
              if (snapshot.data!.data!.data == null) {
                return Stack(
                  children: [
                    Center(
                      child: SingleChildScrollView(
                        child: ErrorResponse(
                          message: snapshot.data!.data!.message!,
                          onTap: () {
                            _getResumeMedis();
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
              return ResumeMedisWidget(
                data: snapshot.data!.data!.data,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ResumeMedisWidget extends StatefulWidget {
  const ResumeMedisWidget({
    super.key,
    this.data,
  });

  final DataResumeMedis? data;

  @override
  State<ResumeMedisWidget> createState() => _ResumeMedisWidgetState();
}

class _ResumeMedisWidgetState extends State<ResumeMedisWidget> {
  DataResumeMedis? _data;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(22.0),
          child: Row(
            children: [
              Expanded(
                child: const Text(
                  'Resume Medis',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
            children: [
              Row(
                children: [
                  Expanded(
                    child: DeskripsiWidget(
                      title: 'Tanggal Layanan',
                      body: Text(_data!.tanggalLayanan ?? '-'),
                    ),
                  ),
                  Expanded(
                    child: DeskripsiWidget(
                      title: 'Tanggal Selesai Layanan',
                      body: Text('${_data!.createdAt}'),
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 18,
              ),
              DeskripsiWidget(
                title: 'Diagnosis masuk/Indikasi pasien dirawat',
                body: Text('${_data!.diagnosisMasuk}'),
              ),
              const Divider(
                height: 18,
              ),
              DeskripsiWidget(
                title: 'Ringkasan riwayat penyakit',
                body: Text('${_data!.ringkasanRiwayatPenyakit}'),
              ),
              const Divider(
                height: 18,
              ),
              DeskripsiWidget(
                title: 'Ringkasan pemeriksaan fisik',
                body: Text('${_data!.ringkasanPemeriksaanFisik}'),
              ),
              const Divider(
                height: 18,
              ),
              DeskripsiWidget(
                title: 'Ringkasan pemeriksaan penunjang',
                body: Text('${_data!.ringkasanRiwayatPenunjang}'),
              ),
              const Divider(
                height: 18,
              ),
              DeskripsiWidget(
                title: 'Ringkasan pemeriksaan fisik',
                body: Text('${_data!.ringkasanPemeriksaanFisik}'),
              ),
              const Divider(
                height: 18,
              ),
              DeskripsiWidget(
                title: 'Riwayat Alergi',
                body: Text('${_data!.riwayatAlergi}'),
              ),
              const Divider(
                height: 18,
              ),
              Text(
                'Diagnosa ICD 10',
                style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
              ),
              Column(
                children: _data!.icd10!
                    .map(
                      (diagnosa) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.arrow_right_rounded),
                        minLeadingWidth: 8,
                        horizontalTitleGap: 8,
                        title: Text(
                            '${diagnosa.kodeIcd10} - ${diagnosa.namaDiagnosa}'),
                        subtitle: Text(
                          '${diagnosa.type}',
                          style: TextStyle(
                            color: diagnosa.type == 'Primary'
                                ? kGreenColor
                                : Colors.orange,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              if (_data!.icd9!.isNotEmpty)
                const Divider(
                  height: 18,
                ),
              if (_data!.icd9!.isNotEmpty)
                Text(
                  'Diagnosa ICD 9',
                  style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                ),
              if (_data!.icd9!.isNotEmpty)
                Column(
                  children: _data!.icd9!
                      .map(
                        (diagnosa) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.arrow_right_rounded),
                          minLeadingWidth: 8,
                          horizontalTitleGap: 8,
                          title: Text(
                              '${diagnosa.kodeIcd9} - ${diagnosa.namaDiagnosa}'),
                          subtitle: Text(
                            '${diagnosa.type}',
                            style: TextStyle(
                              color: diagnosa.type == 'Primary'
                                  ? kGreenColor
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              const Divider(
                height: 18,
              ),
              DeskripsiWidget(
                title: 'Tanggal Kontrol',
                body: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text('${_data!.tanggalKontrol}'),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 18,
              ),
              const DeskripsiWidget(
                title: 'Kondisi waktu keluar',
                body: Text(
                  'Menunggu final layanan',
                  style: TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ),
              const Divider(
                height: 18,
              ),
              DeskripsiWidget(
                title: 'Terapi selama homecare',
                body: Text('${_data!.terapiSelamaHomecare}'),
              ),
              const Divider(
                height: 18,
              ),
              DeskripsiWidget(
                title: 'Instruksi tindak lanjut',
                body: Text('${_data!.terapiSelamaHomecare}'),
              ),
              const Divider(
                height: 18,
              ),
              DeskripsiWidget(
                title: 'Terapi lanjutan',
                body: Text('${_data!.terapiPerluLanjut}'),
              ),
              const Divider(
                height: 18,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: DeskripsiWidget(
                      title: 'Tanggal Resume Medis',
                      body: Text('${_data!.createdAt}'),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: DeskripsiWidget(
                      title: 'DPJP',
                      body: Text(_data!.namaPegawai ?? '-'),
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 22,
              ),
              if (_data!.isUpdate!)
                Divider(
                  height: 12,
                  color: Colors.grey[400],
                ),
              if (_data!.isUpdate!)
                const Text(
                  'Diperbarui',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              if (_data!.isUpdate!)
                const SizedBox(
                  height: 8,
                ),
              if (_data!.isUpdate!)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: DeskripsiWidget(
                        title: 'Tanggal Update',
                        body: Text('${_data!.updatedAt}'),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: DeskripsiWidget(
                        title: 'DPJP',
                        body: Text(_data!.namaPegawai ?? '-'),
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        )
      ],
    );
  }
}

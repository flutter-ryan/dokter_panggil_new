import 'package:dokter_panggil/src/blocs/cppt_pasien_bloc.dart';
import 'package:dokter_panggil/src/models/cppt_pasien_model.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/pasien/resume_pemeriksaan_pasien_page.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';

class CpptPasienWidget extends StatefulWidget {
  const CpptPasienWidget({
    super.key,
    required this.idKunjungan,
    required this.idPetugas,
  });

  final int idKunjungan;
  final int idPetugas;

  @override
  State<CpptPasienWidget> createState() => _CpptPasienWidgetState();
}

class _CpptPasienWidgetState extends State<CpptPasienWidget> {
  final _cpptPasienBloc = CpptPasienBloc();

  @override
  void initState() {
    super.initState();
    _getCpptPasien();
  }

  void _getCpptPasien() {
    _cpptPasienBloc.idKunjunganSink.add(widget.idKunjungan);
    _cpptPasienBloc.idPegawaiSink.add(widget.idPetugas);
    _cpptPasienBloc.getCpptPasien();
  }

  @override
  void dispose() {
    _cpptPasienBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<CpptPasienModel>>(
      stream: _cpptPasienBloc.cpptPasienStream,
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
                  _getCpptPasien();
                  setState(() {});
                },
              );
            case Status.completed:
              return ListView.separated(
                padding:
                    const EdgeInsets.fromLTRB(22, 22, 22, kToolbarHeight + 22),
                itemBuilder: (context, i) {
                  var cppt = snapshot.data!.data!.data![i];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(22.0),
                          child: Wrap(
                            spacing: 8.0,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Icon(
                                Icons.calendar_month_rounded,
                                color: Colors.grey,
                              ),
                              Text(
                                '${cppt.tanggal}',
                                style: const TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 0,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 22.0),
                          child: TilePemeriksaanWidget(
                            title: 'Subjective',
                            subtitle: ListDataPemeriksaan(
                              data: cppt.subjective,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 22.0),
                          child: TilePemeriksaanWidget(
                            title: 'Objective',
                            subtitle: ListDataPemeriksaan(
                              data: cppt.objective,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 22.0),
                          child: TilePemeriksaanWidget(
                            title: 'Assesment',
                            subtitle: ListDataPemeriksaan(
                              data: cppt.assesment,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 22.0),
                          child: TilePemeriksaanWidget(
                            title: 'Planning',
                            subtitle: ListDataPemeriksaan(
                              data: cppt.planning,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 22.0),
                          child: TilePemeriksaanWidget(
                            title: 'Instruksi',
                            subtitle: ListDataPemeriksaan(
                              data: cppt.instruksi,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, i) => const SizedBox(
                  height: 18.0,
                ),
                itemCount: snapshot.data!.data!.data!.length,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

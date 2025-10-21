import 'package:admin_dokter_panggil/src/blocs/kunjungan_resep_racikan_bloc.dart';
import 'package:admin_dokter_panggil/src/models/kunjungan_resep_racikan_model.dart';
import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/tagihan/e_resep_racikan_widget.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';

class ResepRacikanWidget extends StatefulWidget {
  const ResepRacikanWidget({
    super.key,
    this.dokter,
  });

  final Dokter? dokter;

  @override
  State<ResepRacikanWidget> createState() => _ResepRacikanWidgetState();
}

class _ResepRacikanWidgetState extends State<ResepRacikanWidget> {
  final _kunjunganResepRacikanBloc = KunjunganResepRacikanBloc();
  @override
  void initState() {
    super.initState();
    _kunjunganResepRacikanBloc.idDokterSink.add(widget.dokter!.idDokter!);
    _kunjunganResepRacikanBloc.idKunjunganSink.add(widget.dokter!.idKunjungan!);
    _kunjunganResepRacikanBloc.getKunjunganResepRacikan();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseKunjunganResepRacikanModel>>(
      stream: _kunjunganResepRacikanBloc.kunjunganResepRacikanStream,
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
                button: false,
              );
            case Status.completed:
              return EresepRacikanWidget(
                idKunjungan: widget.dokter!.idKunjungan!,
                data: snapshot.data!.data!.data,
                idPegawai: widget.dokter!.idDokter,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

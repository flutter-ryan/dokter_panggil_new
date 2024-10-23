import 'package:dokter_panggil/src/blocs/kunjungan_resep_bloc.dart';
import 'package:dokter_panggil/src/models/kunjungan_resep_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/e_resep_widget.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';

class ResepWidget extends StatefulWidget {
  const ResepWidget({
    super.key,
    this.dokter,
  });

  final Dokter? dokter;

  @override
  State<ResepWidget> createState() => _ResepWidgetState();
}

class _ResepWidgetState extends State<ResepWidget> {
  final _kunjunganResepBloc = KunjunganResepBloc();
  @override
  void initState() {
    super.initState();
    _kunjunganResepBloc.idDokterSink.add(widget.dokter!.idDokter!);
    _kunjunganResepBloc.idKunjunganSink.add(widget.dokter!.idKunjungan!);
    _kunjunganResepBloc.getKunjunganResep();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseKunjunganResepModel>>(
      stream: _kunjunganResepBloc.kunjunganResepStream,
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
                  _kunjunganResepBloc.getKunjunganResep();
                  setState(() {});
                },
              );
            case Status.completed:
              return EresepWidget(
                dokter: widget.dokter!,
                data: snapshot.data!.data!.data,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

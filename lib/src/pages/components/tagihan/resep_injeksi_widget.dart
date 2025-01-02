import 'package:dokter_panggil/src/blocs/resep_injeksi_bloc.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/models/resep_injeksi_model.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';

class ResepInjeksiWidget extends StatefulWidget {
  const ResepInjeksiWidget({
    super.key,
    this.dokter,
    this.idKunjungan,
  });

  final Dokter? dokter;
  final int? idKunjungan;

  @override
  State<ResepInjeksiWidget> createState() => _ResepInjeksiWidgetState();
}

class _ResepInjeksiWidgetState extends State<ResepInjeksiWidget> {
  final _resepInjeksiBloc = ResepInjeksiBloc();

  @override
  void initState() {
    super.initState();
    _getResepInjeksi();
  }

  void _getResepInjeksi() {
    _resepInjeksiBloc.idKunjunganSink.add(widget.idKunjungan!);
    _resepInjeksiBloc.idDokterSink.add(widget.dokter!.idDokter!);
    _resepInjeksiBloc.getResepInjeksi();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResepInjeksiModel>>(
      stream: _resepInjeksiBloc.resepInjeksiStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Center(
                child: LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                button: true,
                onTap: () {
                  _getResepInjeksi();
                  setState(() {});
                },
              );
            case Status.completed:
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 32),
                itemBuilder: (context, i) {
                  var injeksi = snapshot.data!.data!.data![i];
                  return Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: ListTile(
                      title: Text('${injeksi.tanggalResepInjeksi}'),
                      subtitle: Column(
                        children: [],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, i) => SizedBox(
                  height: 22,
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

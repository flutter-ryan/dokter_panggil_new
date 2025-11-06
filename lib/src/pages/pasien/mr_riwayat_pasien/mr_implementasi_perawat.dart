import 'package:admin_dokter_panggil/src/blocs/mr_kunjungan_implementasi_keperawatan_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_implementasi_keperawatan_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/models/pasien_show_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class MrImplementasiPerawat extends StatefulWidget {
  const MrImplementasiPerawat({
    super.key,
    this.riwayatKunjungan,
  });

  final MrRiwayatKunjungan? riwayatKunjungan;

  @override
  State<MrImplementasiPerawat> createState() => _MrImplementasiPerawatState();
}

class _MrImplementasiPerawatState extends State<MrImplementasiPerawat> {
  final _mrImplementasiKeperawatanBloc =
      MrKunjunganImplementasiKeperawatanBloc();

  @override
  void initState() {
    super.initState();
    _getImplementasiKeperawatan();
  }

  void _getImplementasiKeperawatan() {
    _mrImplementasiKeperawatanBloc.idKunjunganSink
        .add(widget.riwayatKunjungan!.idKunjungan!);
    _mrImplementasiKeperawatanBloc.getImplementasiKeperawatan();
  }

  @override
  void dispose() {
    super.dispose();
    _mrImplementasiKeperawatanBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MrKunjunganImplementasiKeperawatanModel>>(
      stream: _mrImplementasiKeperawatanBloc.implementasiKeperawatanStream,
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
                  _getImplementasiKeperawatan();
                  setState(() {});
                },
              );
            case Status.completed:
              return MrImplementasiKeperawatanWidget(
                pasien: widget.riwayatKunjungan!.pasien!,
                data: snapshot.data!.data!.data,
                idKunjungan: widget.riwayatKunjungan!.idKunjungan,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class MrImplementasiKeperawatanWidget extends StatefulWidget {
  const MrImplementasiKeperawatanWidget({
    super.key,
    this.data,
    this.idKunjungan,
    required this.pasien,
  });

  final DataImplementasiKeperawatan? data;
  final int? idKunjungan;
  final Pasien pasien;

  @override
  State<MrImplementasiKeperawatanWidget> createState() =>
      _MrImplementasiKeperawatanWidgetState();
}

class _MrImplementasiKeperawatanWidgetState
    extends State<MrImplementasiKeperawatanWidget> {
  DataImplementasiKeperawatan? _impelmentasi;

  @override
  void initState() {
    super.initState();
    _impelmentasi = widget.data!;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 32.0,
          ),
          Container(
            color: kBgRedLightColor,
            child: const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                    child: Text(
                      'Tanggal',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                    child: Text(
                      'Implementasi',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                    child: Text(
                      'Petugas',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            children: _impelmentasi!.implementasi!
                .map(
                  (implementasi) => Container(
                    color:
                        _impelmentasi!.implementasi!.indexOf(implementasi).isOdd
                            ? Colors.grey[100]
                            : Colors.white,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 12.0),
                            child: Text(
                              '${implementasi.jam}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 12.0),
                            child: Text(
                              '${implementasi.tindakan}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 12.0,
                            ),
                            child: Text(
                              '${implementasi.pegawai}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

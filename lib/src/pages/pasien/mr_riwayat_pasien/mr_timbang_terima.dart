import 'package:admin_dokter_panggil/src/blocs/mr_kunjungan_timbang_terima_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_timbang_terima_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/models/pasien_show_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class MrTimbangTerima extends StatefulWidget {
  const MrTimbangTerima({
    super.key,
    this.riwayatKunjungan,
  });

  final MrRiwayatKunjungan? riwayatKunjungan;

  @override
  State<MrTimbangTerima> createState() => _MrTimbangTerimaState();
}

class _MrTimbangTerimaState extends State<MrTimbangTerima> {
  final _mrKunjunganTimbangTerimaBloc = MrKunjunganTimbangTerimaBloc();

  @override
  void initState() {
    super.initState();
    _getTimbangTerima();
  }

  void _getTimbangTerima() {
    _mrKunjunganTimbangTerimaBloc.idKunjunganSink
        .add(widget.riwayatKunjungan!.idKunjungan!);
    _mrKunjunganTimbangTerimaBloc.getTimbangTerima();
  }

  @override
  void dispose() {
    super.dispose();
    _mrKunjunganTimbangTerimaBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MrKunjunganTimbangTerimaModel>>(
      stream: _mrKunjunganTimbangTerimaBloc.timbangTerimaStream,
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
                  _getTimbangTerima();
                  setState(() {});
                },
              );
            case Status.completed:
              return MrTimbangTerimaWidget(
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

class MrTimbangTerimaWidget extends StatefulWidget {
  const MrTimbangTerimaWidget({
    super.key,
    this.idKunjungan,
    this.data,
    required this.pasien,
  });

  final int? idKunjungan;
  final MrKunjunganTimbangTerima? data;
  final Pasien pasien;

  @override
  State<MrTimbangTerimaWidget> createState() => _MrTimbangTerimaWidgetState();
}

class _MrTimbangTerimaWidgetState extends State<MrTimbangTerimaWidget> {
  List<TimbangTerima> _timbangTerimas = [];

  @override
  void initState() {
    super.initState();
    if (widget.data!.timbangTerima != null) {
      _timbangTerimas = widget.data!.timbangTerima!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 22.0,
        ),
        Container(
          color: kBgRedLightColor,
          child: const Row(
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
                  child: Text(
                    'Tgl/Jam',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
                  child: Text(
                    'Shift',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
                  child: Text(
                    'Indikator',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
                  child: Text(
                    'Petugas',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
            child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _timbangTerimas
                .map(
                  (timbangTerima) => Container(
                    color: _timbangTerimas.indexOf(timbangTerima).isOdd
                        ? Colors.grey[50]
                        : Colors.white,
                    child: InkWell(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 8.0),
                              child: Text(
                                '${timbangTerima.tanggal}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 8.0),
                              child: Text(
                                '${timbangTerima.shift}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Keadaan Umum',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    '${timbangTerima.keadaanUmum}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                    'Intervensi yang dilakukan',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    '${timbangTerima.intervensiDilakukan}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                    'Intervensi belum dilakukan',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    '${timbangTerima.intervensiBelumDilakukan}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                    'Catatan khusus',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    '${timbangTerima.catatanKhusus}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pembuat:',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    '${timbangTerima.pegawai}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Penerima:',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                      Text(
                                        '${timbangTerima.penerimaTimbang?.nama}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ))
      ],
    );
  }
}

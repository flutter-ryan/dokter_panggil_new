import 'package:admin_dokter_panggil/src/blocs/mr_kunjungan_pengobatan_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_pengobatan_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';

class MrDaftarPengobatan extends StatefulWidget {
  const MrDaftarPengobatan({
    super.key,
    this.riwayatKunjungan,
  });

  final MrRiwayatKunjungan? riwayatKunjungan;

  @override
  State<MrDaftarPengobatan> createState() => _MrDaftarPengobatanState();
}

class _MrDaftarPengobatanState extends State<MrDaftarPengobatan> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            child: Text(
              'Daftar Pengobatan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const Divider(
            height: 0,
          ),
          TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey[400],
            indicatorColor: Colors.blue,
            isScrollable: true,
            tabs: const [
              Tab(
                text: 'Injeksi',
              ),
              Tab(
                text: 'Oral',
              ),
              Tab(
                text: 'Racikan',
              )
            ],
          ),
          const Divider(),
          Expanded(
            child: TabBarView(
              children: [
                TabDaftarPengobatanWidget(
                  jenis: 'resep-injeksi',
                  idKunjungan: widget.riwayatKunjungan!.idKunjungan,
                ),
                TabDaftarPengobatanWidget(
                  jenis: 'resep-oral',
                  idKunjungan: widget.riwayatKunjungan!.idKunjungan,
                ),
                TabDaftarPengobatanWidget(
                    jenis: 'resep-racikan',
                    idKunjungan: widget.riwayatKunjungan!.idKunjungan),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TabDaftarPengobatanWidget extends StatefulWidget {
  const TabDaftarPengobatanWidget({
    super.key,
    this.jenis,
    this.idKunjungan,
  });

  final String? jenis;
  final int? idKunjungan;

  @override
  State<TabDaftarPengobatanWidget> createState() =>
      _TabDaftarPengobatanWidgetState();
}

class _TabDaftarPengobatanWidgetState extends State<TabDaftarPengobatanWidget> {
  final _mrKunjunganPengobatanBloc = MrKunjunganPengobatanBloc();

  @override
  void initState() {
    super.initState();
    _getPengobatan();
  }

  void _getPengobatan() {
    _mrKunjunganPengobatanBloc.idKunjunganSink.add(widget.idKunjungan!);
    _mrKunjunganPengobatanBloc.jenisSink.add(widget.jenis!);
    _mrKunjunganPengobatanBloc.getPengobatan();
  }

  @override
  void dispose() {
    super.dispose();
    _mrKunjunganPengobatanBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MrKunjunganPengobatanModel>>(
      stream: _mrKunjunganPengobatanBloc.pengobatanStream,
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
                  _getPengobatan();
                  setState(() {});
                },
              );
            case Status.completed:
              return DaftarPengobatanWidget(
                data: snapshot.data!.data!.data,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class DaftarPengobatanWidget extends StatefulWidget {
  const DaftarPengobatanWidget({
    super.key,
    this.data,
  });

  final List<MrKunjunganPengobatan>? data;

  @override
  State<DaftarPengobatanWidget> createState() => _DaftarPengobatanWidgetState();
}

class _DaftarPengobatanWidgetState extends State<DaftarPengobatanWidget> {
  List<MrKunjunganPengobatan> _pengobatan = [];

  @override
  void initState() {
    super.initState();
    _pengobatan = widget.data!;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemBuilder: (context, i) {
        var obat = _pengobatan[i];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                '${obat.pengobatan!.namaObat}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 4.0,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'Dosis',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const Text(
                        ':',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(child: Text('${obat.pengobatan!.dosis}'))
                    ],
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'Rute',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const Text(
                        ':',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(child: Text('${obat.pengobatan!.rute}'))
                    ],
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  if (obat.tanggalMulai != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 100,
                          child: Text(
                            'Tanggal Mulai',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        const Text(
                          ':',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(child: Text('${obat.tanggalMulai}'))
                      ],
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: const Text(
                'Waktu pemberian obat',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            if (obat.timeline!.isNotEmpty)
              SizedBox(
                height: 140,
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: obat.timeline!
                      .map(
                        (timeline) => Container(
                          width: 100,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 0.3),
                              right: BorderSide(width: 0.3),
                              bottom: BorderSide(width: 0.3),
                              left: BorderSide(width: 0.3),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${timeline.pengobatanAt}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Divider(
                                height: 0,
                                color: Colors.black,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: SingleChildScrollView(
                                      child: Text(
                                        '${timeline.namaPegawai}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Riwayat pemberian obat tidak tersedia',
                    style: TextStyle(
                        color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ),
              )
          ],
        );
      },
      separatorBuilder: (context, i) => Divider(
        color: Colors.grey[300],
        thickness: 6,
        height: 52,
      ),
      itemCount: widget.data!.length,
    );
  }
}

import 'package:admin_dokter_panggil/src/blocs/mr_kunjungan_anastesi_bedah_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_anastesi_bedah_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/models/pasien_show_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_card_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/identitas_pasien_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class MrTindakanAnastesiBedah extends StatefulWidget {
  const MrTindakanAnastesiBedah({
    super.key,
    this.riwayatKunjungan,
  });

  final MrRiwayatKunjungan? riwayatKunjungan;

  @override
  State<MrTindakanAnastesiBedah> createState() =>
      _MrTindakanAnastesiBedahState();
}

class _MrTindakanAnastesiBedahState extends State<MrTindakanAnastesiBedah> {
  final _mrKunjunganAnastesiBedahBloc = MrKunjunganAnastesiBedahBloc();

  @override
  void initState() {
    super.initState();
    _getTindakanAnastesiBedah();
  }

  void _getTindakanAnastesiBedah() {
    _mrKunjunganAnastesiBedahBloc.idKunjunganSink
        .add(widget.riwayatKunjungan!.idKunjungan!);
    _mrKunjunganAnastesiBedahBloc.getAnastesiBedah();
  }

  @override
  void dispose() {
    super.dispose();
    _mrKunjunganAnastesiBedahBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MrKunjunganAnastesiBedahModel>>(
      stream: _mrKunjunganAnastesiBedahBloc.anastesiBedahStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: kPrimaryColor,
              );
            case Status.error:
              return Center(
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () {
                    _getTindakanAnastesiBedah();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              if (snapshot.data!.data!.data == null) {
                return AnastesiBedahWidget(
                  pasien: widget.riwayatKunjungan!.pasien!,
                  idKunjungan: widget.riwayatKunjungan!.idKunjungan,
                  reload: () {
                    _getTindakanAnastesiBedah();
                    setState(() {});
                  },
                );
              }
              return AnastesiBedahWidget(
                data: snapshot.data!.data?.data,
                pasien: widget.riwayatKunjungan!.pasien!,
                idKunjungan: widget.riwayatKunjungan!.idKunjungan,
                reload: () {
                  _getTindakanAnastesiBedah();
                  setState(() {});
                },
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class AnastesiBedahWidget extends StatefulWidget {
  const AnastesiBedahWidget({
    super.key,
    this.data,
    required this.pasien,
    this.reload,
    this.idKunjungan,
  });

  final AnastesiBedah? data;
  final Pasien pasien;
  final VoidCallback? reload;
  final int? idKunjungan;

  @override
  State<AnastesiBedahWidget> createState() => _AnastesiBedahWidgetState();
}

class _AnastesiBedahWidgetState extends State<AnastesiBedahWidget> {
  AnastesiBedah? _anastesiBedah;

  @override
  void initState() {
    super.initState();
    _anastesiBedah = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_anastesiBedah != null)
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_anastesiBedah!.anastesi != null)
                  DashboardCardWidget(
                    title: 'Tindakan Anastesi',
                    errorMessage: 'Data tidak tersedia',
                    dataCard: Column(
                      children: [
                        Row(
                          children: [
                            const ColumnTindakanAnastesiWidget(
                              height: 60,
                              colorRow: kBgRedLightColor,
                              width: 92,
                              label: 'Kondisi',
                              tglRow: Text(
                                'Tanggal/Jam',
                                style: TextStyle(fontSize: 12),
                              ),
                              tdRow: Text(
                                'Tekanan Darah',
                                style: TextStyle(fontSize: 12),
                              ),
                              nadiRow: Text(
                                'Nadi',
                                style: TextStyle(fontSize: 12),
                              ),
                              pernapasanRow: Text(
                                'Pernapasan',
                                style: TextStyle(fontSize: 12),
                              ),
                              oksigenRow: Text(
                                'Saturasi Oksigen',
                                style: TextStyle(fontSize: 12),
                              ),
                              ncsRow: Text(
                                'GCS',
                                style: TextStyle(fontSize: 12),
                              ),
                              keteranganRow: Text(
                                'Ket',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _anastesiBedah!.anastesi!.anastesi!
                                      .map(
                                        (anastesi) =>
                                            ColumnTindakanAnastesiWidget(
                                          height: 60,
                                          label: '${anastesi.jenis}',
                                          tglRow: Center(
                                              child:
                                                  Text('${anastesi.tanggal}')),
                                          tdRow: Center(
                                              child: Text(
                                                  '${anastesi.tekananDarah}')),
                                          nadiRow: Center(
                                              child: Text('${anastesi.nadi}')),
                                          pernapasanRow: Center(
                                              child: Text(
                                                  '${anastesi.pernapasan}')),
                                          oksigenRow: Center(
                                              child: Text(
                                                  '${anastesi.saturasiOksigen}')),
                                          ncsRow: Center(
                                              child: Text('${anastesi.ncs}')),
                                          keteranganRow: Center(
                                              child: Text(
                                                  '${anastesi.keterangan}')),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(18),
                          color: Colors.grey[100],
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Tgl.Save: ${_anastesiBedah!.anastesi!.createdAt}'),
                                    if (_anastesiBedah!
                                            .anastesi!.anastesiUpdatedAt !=
                                        null)
                                      const SizedBox(
                                        height: 8,
                                      ),
                                    if (_anastesiBedah!
                                            .anastesi!.anastesiUpdatedAt !=
                                        null)
                                      Text(
                                          'Tgl.Update: ${_anastesiBedah!.anastesi!.anastesiUpdatedAt}'),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 18,
                              ),
                              Expanded(
                                child: Text(
                                    'Oleh: ${_anastesiBedah!.anastesi!.pegawai}'),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_anastesiBedah!.bedah != null &&
                    _anastesiBedah!.bedah!.bedah!.isNotEmpty)
                  Divider(
                    color: Colors.grey[300],
                    thickness: 5,
                    height: 32,
                  ),
                if (_anastesiBedah!.bedah != null)
                  DashboardCardWidget(
                    title: 'Tindakan Bedah',
                    errorMessage: 'Data tidak tersedia',
                    dataCard: Column(
                      children: [
                        Row(
                          children: [
                            const ColumnTindakanBedahWidget(
                              colorRow: kBgRedLightColor,
                              width: 100,
                              label: 'Laporan',
                              sRow: Text(
                                'Subjective',
                                style: TextStyle(fontSize: 14),
                              ),
                              oRow: Text(
                                'Objective',
                                style: TextStyle(fontSize: 14),
                              ),
                              aRow: Text(
                                'Asessement',
                                style: TextStyle(fontSize: 14),
                              ),
                              pRow: Text(
                                'Planning',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _anastesiBedah!.bedah!.bedah!
                                      .map(
                                        (bedah) => ColumnTindakanBedahWidget(
                                          label: '${bedah.jenis}',
                                          sRow: Text('${bedah.subjektif}'),
                                          oRow: Text('${bedah.objektif}'),
                                          aRow: Text('${bedah.assesment}'),
                                          pRow: Text('${bedah.planning}'),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(18),
                          color: Colors.grey[100],
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Tg.Save: ${_anastesiBedah!.bedah!.createdAt}'),
                                    if (_anastesiBedah!.bedah!.bedahUpdatedAt !=
                                        null)
                                      const SizedBox(
                                        height: 4,
                                      ),
                                    if (_anastesiBedah!.bedah!.bedahUpdatedAt !=
                                        null)
                                      Text(
                                          'Tg.Update: ${_anastesiBedah!.bedah!.bedahUpdatedAt}'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                    'Oleh: ${_anastesiBedah!.bedah!.pegawai}'),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class FormTindakanAnastesiBedah extends StatefulWidget {
  const FormTindakanAnastesiBedah({
    super.key,
    required this.pasien,
  });

  final Pasien pasien;

  @override
  State<FormTindakanAnastesiBedah> createState() =>
      _FormTindakanAnastesiBedahState();
}

class _FormTindakanAnastesiBedahState extends State<FormTindakanAnastesiBedah> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'MR.12 Tindakan Anastesi Bedah',
          style: TextStyle(fontSize: 16),
        ),
        foregroundColor: Colors.black,
        backgroundColor: kBgRedLightColor,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: IdentitasPasienWidget(
            pasien: widget.pasien,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: kBgRedLightColor,
              child: TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[400],
                indicatorColor: kSecondaryColor,
                tabs: const [
                  Tab(
                    text: 'Anastesi',
                  ),
                  Tab(
                    text: 'Bedah',
                  )
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  const FormAnastesi(),
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FormAnastesi extends StatefulWidget {
  const FormAnastesi({super.key});

  @override
  State<FormAnastesi> createState() => _FormAnastesiState();
}

class _FormAnastesiState extends State<FormAnastesi> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [],
      ),
    );
  }
}

class ColumnTindakanAnastesiWidget extends StatelessWidget {
  const ColumnTindakanAnastesiWidget({
    super.key,
    this.label,
    this.tglRow,
    this.tdRow,
    this.nadiRow,
    this.pernapasanRow,
    this.oksigenRow,
    this.ncsRow,
    this.keteranganRow,
    this.width = 180,
    this.colorRow,
    this.height = 80,
  });

  final String? label;
  final Widget? tglRow;
  final Widget? tdRow;
  final Widget? nadiRow;
  final Widget? pernapasanRow;
  final Widget? oksigenRow;
  final Widget? ncsRow;
  final Widget? keteranganRow;
  final double width;
  final double height;
  final Color? colorRow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(width: 0.6, color: Colors.grey),
          top: BorderSide(width: 0.6, color: Colors.grey),
          bottom: BorderSide(width: 0.6, color: Colors.grey),
        ),
      ),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: kBgRedLightColor,
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Text(
              '$label',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: double.infinity,
            height: height,
            color: colorRow ?? Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Align(alignment: Alignment.centerLeft, child: tglRow),
          ),
          Container(
            width: double.infinity,
            height: height,
            color: colorRow ?? Colors.grey[50],
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Align(alignment: Alignment.centerLeft, child: tdRow),
          ),
          Container(
            width: double.infinity,
            height: height,
            color: colorRow ?? Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Align(alignment: Alignment.centerLeft, child: nadiRow),
          ),
          Container(
            width: double.infinity,
            height: height,
            color: colorRow ?? Colors.grey[50],
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Align(alignment: Alignment.centerLeft, child: pernapasanRow),
          ),
          Container(
            width: double.infinity,
            height: height,
            color: colorRow ?? Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: oksigenRow,
            ),
          ),
          Container(
            width: double.infinity,
            height: height,
            color: colorRow ?? Colors.grey[50],
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Align(alignment: Alignment.centerLeft, child: ncsRow),
          ),
          Container(
            width: double.infinity,
            height: height,
            color: colorRow ?? Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Align(alignment: Alignment.centerLeft, child: keteranganRow),
          ),
        ],
      ),
    );
  }
}

class TindakanAnastesiData {
  String? jenis;
  String? tanggal;
  String? tekananDarah;
  String? nadi;
  String? pernapasan;
  String? oksigen;
  String? ncs;
  String? keterangan;

  TindakanAnastesiData({
    this.jenis,
    this.tanggal,
    this.tekananDarah,
    this.nadi,
    this.pernapasan,
    this.oksigen,
    this.ncs,
    this.keterangan,
  });
}

class ColumnTindakanBedahWidget extends StatelessWidget {
  const ColumnTindakanBedahWidget({
    super.key,
    this.label,
    this.sRow,
    this.oRow,
    this.aRow,
    this.pRow,
    this.width = 180,
    this.colorRow,
    this.height = 80,
  });

  final String? label;
  final Widget? sRow;
  final Widget? oRow;
  final Widget? aRow;
  final Widget? pRow;
  final double width;
  final double height;
  final Color? colorRow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(width: 0.6, color: Colors.grey),
          top: BorderSide(width: 0.6, color: Colors.grey),
          bottom: BorderSide(width: 0.6, color: Colors.grey),
        ),
      ),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: kBgRedLightColor,
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Text(
              '$label',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: double.infinity,
            height: height,
            color: colorRow ?? Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Align(alignment: Alignment.centerLeft, child: sRow),
          ),
          Container(
            width: double.infinity,
            height: height,
            color: colorRow ?? Colors.grey[50],
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Align(alignment: Alignment.centerLeft, child: oRow),
          ),
          Container(
            width: double.infinity,
            height: height,
            color: colorRow ?? Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Align(alignment: Alignment.centerLeft, child: aRow),
          ),
          Container(
            width: double.infinity,
            height: height,
            color: colorRow ?? Colors.grey[50],
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Align(alignment: Alignment.centerLeft, child: pRow),
          ),
        ],
      ),
    );
  }
}

class TindakanBedahData {
  String? jenis;
  String? subjective;
  String? objective;
  String? assesment;
  String? planning;

  TindakanBedahData({
    this.jenis,
    this.subjective,
    this.objective,
    this.assesment,
    this.planning,
  });
}

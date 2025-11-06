import 'package:admin_dokter_panggil/src/blocs/mr_hasil_lab_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_hasil_lab_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/bullet_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/pdfview_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/tile_data_card.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MrHasilLab extends StatefulWidget {
  const MrHasilLab({
    super.key,
    this.riwayatKunjungan,
  });

  final MrRiwayatKunjungan? riwayatKunjungan;

  @override
  State<MrHasilLab> createState() => _MrHasilLabState();
}

class _MrHasilLabState extends State<MrHasilLab> {
  final _mrHasilLabBloc = MrHasilLabBloc();

  @override
  void initState() {
    super.initState();
    _getHasilLab();
  }

  void _getHasilLab() {
    _mrHasilLabBloc.idKunjunganSink.add(widget.riwayatKunjungan!.idKunjungan!);
    _mrHasilLabBloc.getHasilLab();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MrHasilLabModel>>(
      stream: _mrHasilLabBloc.hasilLabStream,
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
                    _getHasilLab();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              return MrHasilLabWidget(
                idKunjungan: widget.riwayatKunjungan!.idKunjungan,
                data: snapshot.data!.data!.data,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class MrHasilLabWidget extends StatefulWidget {
  const MrHasilLabWidget({
    super.key,
    this.idKunjungan,
    this.data,
  });

  final int? idKunjungan;
  final List<DataMrHasilLab>? data;

  @override
  State<MrHasilLabWidget> createState() => _MrHasilLabWidgetState();
}

class _MrHasilLabWidgetState extends State<MrHasilLabWidget> {
  List<DataMrHasilLab> _hasilLab = [];

  @override
  void initState() {
    super.initState();
    _hasilLab = widget.data!;
  }

  void _showMore(DokumenLabRiwayat? dokumen) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        top: false,
        child: _showMoreWidget(context, dokumen),
      ),
    ).then((value) async {
      if (value != null) {
        var type = value as String;
        if (type == 'view') {
          if (dokumen!.extension == '.pdf') {
            _showPdfView(dokumen.url);
          } else {
            final imageProvider = Image.network('${dokumen.url}').image;
            if (!mounted) return;
            showImageViewer(
              context,
              imageProvider,
              useSafeArea: true,
              swipeDismissible: true,
              closeButtonColor: kPrimaryColor,
              onViewerDismissed: () {
                // print("dismissed");
              },
            );
          }
        }
      }
    });
  }

  void _showPdfView(String? url) {
    showMaterialModalBottomSheet(
      context: context,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => PdfviewWidget(
        url: url,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(22.0),
          child: Text(
            'Daftar Hasil Lab',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Column(
              children: _hasilLab
                  .map(
                    (lab) => Column(
                      children: lab.hasilLab!
                          .map((hasilLab) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 6,
                                          offset: Offset(0, 3))
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        title: Row(
                                          children: [
                                            Text(
                                              '${hasilLab.createdAt}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                          ],
                                        ),
                                        subtitle: Container(
                                          width: 90,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          decoration: BoxDecoration(
                                              color:
                                                  hasilLab.confirmedAt == null
                                                      ? Colors.red
                                                      : Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Center(
                                            child: Text(
                                              hasilLab.confirmedAt == null
                                                  ? 'Belum Terverifikasi'
                                                  : 'Telah Terverifikasi',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        leading: SvgPicture.asset(
                                          'images/pdf-ic.svg',
                                          height: 42,
                                        ),
                                        minLeadingWidth: 12.0,
                                        trailing: CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.grey[100],
                                          foregroundColor: Colors.blue,
                                          child: IconButton(
                                            onPressed: () =>
                                                _showMore(hasilLab),
                                            icon: const Icon(
                                              Icons.more_vert_rounded,
                                              size: 18,
                                            ),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: TileDataCard(
                                          title: 'Dokter',
                                          body: Text('${lab.namaPegawai}'),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: TileDataCard(
                                          title: 'Pemeriksaan lab',
                                          body: Column(
                                            children: lab.tindakanLab!
                                                .map(
                                                  (tindakanLab) => BulletWidget(
                                                    title:
                                                        '${tindakanLab.tindakanLab}',
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      if (hasilLab.confirmedAt != null)
                                        const Divider(
                                          height: 0,
                                        ),
                                      if (hasilLab.confirmedAt != null)
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: TileDataCard(
                                                  title: 'Tanggal Verifikasi',
                                                  body: Text(
                                                      '${hasilLab.confirmedAt}'),
                                                ),
                                              ),
                                              Expanded(
                                                child: TileDataCard(
                                                  title: 'Dokter Verifikasi',
                                                  body: Text(
                                                      '${hasilLab.confirmedBy}'),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  )
                  .toList(),
            ),
          ),
        )
      ],
    );
  }

  Widget _showMoreWidget(BuildContext context, DokumenLabRiwayat? dokumen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(22.0),
          child: Text(
            'Pilih Salah Satu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        ListTile(
          onTap: () => Navigator.pop(context, 'view'),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 22),
          leading: SvgPicture.asset('images/pdf.svg'),
          title: Text('Lihat Dokumen'),
        ),
      ],
    );
  }
}

import 'package:admin_dokter_panggil/src/blocs/mr_kunjungan_penghentian_layanan_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_penghentian_layanan_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/card_file_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/pdfview_widget.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MrPenghentianLayanan extends StatefulWidget {
  const MrPenghentianLayanan({
    super.key,
    this.riwayatKunjungan,
  });

  final MrRiwayatKunjungan? riwayatKunjungan;

  @override
  State<MrPenghentianLayanan> createState() => _MrPenghentianLayananState();
}

class _MrPenghentianLayananState extends State<MrPenghentianLayanan> {
  final _mrKunjunganPenghentianLayananBloc =
      MrKunjunganPenghentianLayananBloc();

  @override
  void initState() {
    super.initState();
    _getPenghentian();
  }

  void _getPenghentian() {
    _mrKunjunganPenghentianLayananBloc.idKunjunganSink
        .add(widget.riwayatKunjungan!.idKunjungan!);
    _mrKunjunganPenghentianLayananBloc.getPenghentian();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MrKunjunganPenghentianLayananModel>>(
      stream: _mrKunjunganPenghentianLayananBloc.penghentianLayananStream,
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
                    _getPenghentian();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              return MrPenghentianLayananWidget(
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

class MrPenghentianLayananWidget extends StatefulWidget {
  const MrPenghentianLayananWidget({
    super.key,
    this.idKunjungan,
    this.data,
  });

  final int? idKunjungan;
  final List<DataKunjunganPenghentianLayanan>? data;

  @override
  State<MrPenghentianLayananWidget> createState() =>
      _MrPenghentianLayananWidgetState();
}

class _MrPenghentianLayananWidgetState
    extends State<MrPenghentianLayananWidget> {
  List<DataKunjunganPenghentianLayanan> _penghentian = [];

  @override
  void initState() {
    super.initState();
    _penghentian = widget.data!;
  }

  void _showMore(DataKunjunganPenghentianLayanan? layanan) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => _showMoreWidget(context),
    ).then((value) async {
      if (value != null) {
        var type = value as String;
        if (type == 'download') {
          if (layanan!.extension == 'pdf') {
            _showPdfView(layanan.url);
          } else {
            final imageProvider = Image.network('${layanan.url}').image;
            if (!mounted) return;
            showImageViewer(
              context,
              imageProvider,
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
            'Daftar Dokumen Edukasi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            children: _penghentian
                .map(
                  (penghentian) => CardFileWidget(
                    title: 'Penghentian Layanan Pasien',
                    subtitle: '${penghentian.fileName}',
                    tanggal: '${penghentian.createdAt}',
                    petugas: '${penghentian.namaPegawai}',
                    onPressed: () => _showMore(penghentian),
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }

  Widget _showMoreWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context, 'download'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    )
                  ],
                  borderRadius: BorderRadius.circular(8)),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.view_array_outlined,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text('Lihat Dokumen')
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 12,
          )
        ],
      ),
    );
  }
}

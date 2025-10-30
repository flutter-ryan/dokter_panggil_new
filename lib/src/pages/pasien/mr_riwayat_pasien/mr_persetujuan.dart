import 'package:admin_dokter_panggil/src/blocs/mr_kunjungan_persetujuan_pasien_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_persetujuan_pasien_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_detail_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/card_file_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/pdfview_widget.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MrPersetujuan extends StatefulWidget {
  const MrPersetujuan({
    super.key,
    this.data,
    this.isPerawat = false,
  });

  final MrRiwayatDetail? data;
  final bool isPerawat;

  @override
  State<MrPersetujuan> createState() => _MrPersetujuanState();
}

class _MrPersetujuanState extends State<MrPersetujuan> {
  final _mrKunjunganPersetujuanPasienBloc = MrKunjunganPersetujuanPasienBloc();

  @override
  void initState() {
    super.initState();
    _getPersetujuan();
  }

  void _getPersetujuan() {
    _mrKunjunganPersetujuanPasienBloc.idKunjunganSink
        .add(widget.data!.kunjungan!.id!);
    _mrKunjunganPersetujuanPasienBloc.getPersetujuan();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MrKunjunganPersetujuanPasienModel>>(
      stream: _mrKunjunganPersetujuanPasienBloc.persetujuanStream,
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
                  _getPersetujuan();
                  setState(() {});
                },
              );
            case Status.completed:
              return DataPersetujuanWidget(
                datas: snapshot.data!.data!.data,
                isPerawat: widget.isPerawat,
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildPilihanPersetujuan(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(22),
            child: Text(
              'Pilih Persetujuan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () => Navigator.pop(context, 'observasi'),
            title: const Text('Persetujuan Observasi'),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          const Divider(
            height: 0,
          ),
          ListTile(
            onTap: () => Navigator.pop(context, 'rawatInap'),
            title: const Text('Persetujuan Rawat Inap'),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
            trailing: const Icon(Icons.keyboard_arrow_right),
          )
        ],
      ),
    );
  }
}

class DataPersetujuanWidget extends StatefulWidget {
  const DataPersetujuanWidget({
    super.key,
    this.datas,
    this.isPerawat = false,
  });

  final List<DataPersetujuanPasien>? datas;
  final bool isPerawat;

  @override
  State<DataPersetujuanWidget> createState() => _DataPersetujuanWidgetState();
}

class _DataPersetujuanWidgetState extends State<DataPersetujuanWidget> {
  List<DataPersetujuanPasien> _persetujuan = [];

  @override
  void initState() {
    super.initState();
    _persetujuan = widget.datas!;
  }

  void _showMore(DataPersetujuanPasien persetujuan) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => _showMoreWidget(context),
    ).then((value) async {
      if (value != null) {
        if (persetujuan.extension == 'pdf') {
          _showPdfView(persetujuan.url);
        } else {
          final imageProvider = Image.network('${persetujuan.url}').image;
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
          padding: EdgeInsets.all(22),
          child: Text(
            'Daftar persetujuan pasien',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: _persetujuan
                  .map(
                    (persetujuan) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22.0, vertical: 8),
                      child: CardFileWidget(
                        title: 'Persetujuan ${persetujuan.jenis}',
                        subtitle: '${persetujuan.namaFile}',
                        tanggal: '${persetujuan.createdAt}',
                        petugas: '${persetujuan.namaPegawai}',
                        onPressed: () => _showMore(persetujuan),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _showMoreWidget(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => Navigator.pop(context, 'download'),
                child: Container(
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
                    borderRadius: BorderRadius.circular(8),
                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}

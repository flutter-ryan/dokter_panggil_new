import 'package:admin_dokter_panggil/src/blocs/mr_kunjungan_consent_tindakan_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_consent_tindakan_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/card_file_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/pdfview_widget.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MrPersetujuanTindakan extends StatefulWidget {
  const MrPersetujuanTindakan({
    super.key,
    this.riwayatKunjungan,
  });

  final MrRiwayatKunjungan? riwayatKunjungan;

  @override
  State<MrPersetujuanTindakan> createState() => _MrPersetujuanTindakanState();
}

class _MrPersetujuanTindakanState extends State<MrPersetujuanTindakan> {
  final _mrKunjunganConsentTindakanBloc = MrKunjunganConsentTindakanBloc();

  @override
  void initState() {
    super.initState();
    _getPersetujuanTindakan();
  }

  void _getPersetujuanTindakan() {
    _mrKunjunganConsentTindakanBloc.idKunjunganSink
        .add(widget.riwayatKunjungan!.idKunjungan!);
    _mrKunjunganConsentTindakanBloc.getConsentTindakan();
  }

  @override
  void dispose() {
    super.dispose();
    _mrKunjunganConsentTindakanBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MrKunjunganConsentTindakanModel>>(
      stream: _mrKunjunganConsentTindakanBloc.consentTindakanStream,
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
                    _getPersetujuanTindakan();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              return MrConsentTindakanWidget(
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

class MrConsentTindakanWidget extends StatefulWidget {
  const MrConsentTindakanWidget({
    super.key,
    this.idKunjungan,
    this.data,
  });

  final int? idKunjungan;
  final List<DataKunjunganConsentTindakan>? data;

  @override
  State<MrConsentTindakanWidget> createState() =>
      _MrConsentTindakanWidgetState();
}

class _MrConsentTindakanWidgetState extends State<MrConsentTindakanWidget> {
  List<DataKunjunganConsentTindakan> _consents = [];

  @override
  void initState() {
    super.initState();
    _consents = widget.data!;
  }

  void _showMore(DataKunjunganConsentTindakan? consent) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => _showMoreWidget(context),
    ).then((value) async {
      if (value != null) {
        var type = value as String;
        if (type == 'download') {
          _showPdfView(consent!.url);
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
            'Daftar Dokumen Consent Tindakan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            children: _consents
                .map(
                  (consent) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CardFileWidget(
                      title: consent.jenis == 'terima'
                          ? 'Terima Tindakan'
                          : 'Tolak Tindakan',
                      subtitle: '${consent.fileName}',
                      tanggal: '${consent.createdAt}',
                      petugas: '${consent.namaPegawai}',
                      onPressed: () => _showMore(consent),
                    ),
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
            height: MediaQuery.of(context).padding.bottom + 22,
          )
        ],
      ),
    );
  }
}

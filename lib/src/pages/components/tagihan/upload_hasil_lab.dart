import 'package:dokter_panggil/src/blocs/dokumen_lab_bloc.dart';
import 'package:dokter_panggil/src/blocs/dokumen_lab_save_bloc.dart';
import 'package:dokter_panggil/src/models/dokumen_lab_model.dart';
import 'package:dokter_panggil/src/models/dokumen_lab_save_model.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/deskripsi_widget.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/form_dokumen_lab.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/pdfview_widget.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';

import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart' as p;

class UploadHasilLab extends StatefulWidget {
  const UploadHasilLab({
    super.key,
    this.idPengantar,
  });

  final int? idPengantar;

  @override
  State<UploadHasilLab> createState() => _UploadHasilLabState();
}

class _UploadHasilLabState extends State<UploadHasilLab> {
  final _dokumenLabBloc = DokumenLabBloc();
  DokumenLab? _dokumenLab;

  @override
  void initState() {
    super.initState();
    _getDokumenLab();
  }

  void _getDokumenLab() {
    _dokumenLabBloc.idPengantarSink.add(widget.idPengantar!);
    _dokumenLabBloc.getDokumenLab();
  }

  void _showFormDokumen() {
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => FormDokumenLab(
        idPengantar: widget.idPengantar,
      ),
    ).then((value) {
      if (value != null) {
        var dokumen = value as DokumenLab;
        _dokumenLabBloc.getDokumenLab();
        setState(() {
          _dokumenLab = dokumen;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _dokumenLabBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text('Hasil Laboratorium'),
      ),
      body: Stack(
        children: [
          _streamDokumenLabWidget(context),
          Positioned(
            bottom: 22,
            right: 22,
            child: FloatingActionButton(
              onPressed: _showFormDokumen,
              child: Icon(Icons.add_rounded),
            ),
          )
        ],
      ),
    );
  }

  Widget _streamDokumenLabWidget(BuildContext context) {
    return StreamBuilder<ApiResponse<DokumenLabModel>>(
      stream: _dokumenLabBloc.dokumenLabStream,
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
              return Center(
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () {
                    _getDokumenLab();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              return DokumenLabWidget(
                data: snapshot.data!.data!.data,
                dokumenAdd: _dokumenLab,
              );
          }
        }
        return const SizedBox(
          height: 300,
        );
      },
    );
  }
}

class DokumenLabWidget extends StatefulWidget {
  const DokumenLabWidget({
    super.key,
    this.data,
    this.dokumenAdd,
  });

  final List<DokumenLab>? data;
  final DokumenLab? dokumenAdd;

  @override
  State<DokumenLabWidget> createState() => _DokumenLabWidgetState();
}

class _DokumenLabWidgetState extends State<DokumenLabWidget> {
  final _dokumenLabSaveBloc = DokumenLabSaveBloc();
  List<DokumenLab> _dokumens = [];

  @override
  void initState() {
    super.initState();
    _dokumens = widget.data!;
  }

  void _showMore(DokumenLab? doc) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => _buildMoreDialog(context),
    ).then((value) {
      if (value != null) {
        var data = value as String;
        if (data == 'view') {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!mounted) return;
            _showDokumen(doc);
          });
        } else if (data == 'hapus') {
          Future.delayed(const Duration(milliseconds: 500), () {
            _konfirmasiDokumenLab(doc!.id);
          });
        }
      }
    });
  }

  void _konfirmasiDokumenLab(int? id) {
    showAnimatedDialog(
      context: context,
      builder: (context) => ConfirmDialogWidget(
        onConfirm: () => Navigator.pop(context, 'confirm'),
      ),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _dokumenLabSaveBloc.idDokumenSink.add(id!);
          _dokumenLabSaveBloc.deleteDokumenLab();
          _showStreamDokumenLab();
        });
      }
    });
  }

  void _showDokumen(DokumenLab? doc) {
    String ext = p.extension(doc!.url!);
    if (ext == '.pdf') {
      Navigator.push(
        context,
        SlideLeftRoute(
          page: PdfviewWidget(
            url: doc.url,
          ),
        ),
      );
    } else {
      final imageProvider = Image.network(doc.url!).image;
      showImageViewer(
        context,
        imageProvider,
        useSafeArea: true,
      );
    }
  }

  void _showStreamDokumenLab() {
    showAnimatedDialog(
      context: context,
      builder: (context) => _buildStreamDokumenLab(context),
      animationType: DialogTransitionType.slideFromTopFade,
    ).then((value) {
      if (value != null) {
        var dokumen = value as DokumenLab;
        setState(() {
          _dokumens.removeWhere((dok) => dok.id == dokumen.id);
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant DokumenLabWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dokumenAdd != widget.dokumenAdd) {
      _dokumens.add(widget.dokumenAdd!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _dokumenLabSaveBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_dokumens.isEmpty) {
      return Center(
        child: ErrorResponse(
          message: 'Data dokumen Lab tidak tersedia',
          onTap: () {
            setState(() {});
          },
        ),
      );
    }
    return ListView.separated(
        padding: EdgeInsets.all(22),
        itemBuilder: (context, i) {
          var dokumen = _dokumens[i];
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 4))
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  onTap: dokumen.confirmedAt != null
                      ? () => _showDokumen(dokumen)
                      : null,
                  leading: SvgPicture.asset('images/pdf.svg'),
                  title: Text(
                    p.basename(dokumen.url!),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: dokumen.confirmedAt == null
                      ? null
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(22)),
                            child: const Text(
                              'Terkonfirmasi',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),
                  minLeadingWidth: 12.0,
                  trailing: dokumen.confirmedAt != null
                      ? const Icon(Icons.chevron_right)
                      : IconButton(
                          onPressed: () => _showMore(dokumen),
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.more_vert,
                          ),
                        ),
                ),
                if (dokumen.confirmedAt != null) const Divider(),
                if (dokumen.confirmedAt != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22.0, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: DeskripsiWidget(
                            title: 'Tanggal',
                            body: Text(
                              '${dokumen.confirmedAt}',
                            ),
                          ),
                        ),
                        Expanded(
                          child: DeskripsiWidget(
                            title: 'Petugas',
                            body: Text(
                              '${dokumen.confirmedBy}',
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          );
        },
        separatorBuilder: (context, i) => SizedBox(
              height: 12,
            ),
        itemCount: _dokumens.length);
  }

  Widget _buildMoreDialog(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 12,
        ),
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          onTap: () => Navigator.pop(context, 'view'),
          leading: const Icon(Icons.view_array_outlined),
          title: const Text('Lihat Dokumen'),
        ),
        const Divider(
          height: 0,
        ),
        ListTile(
          onTap: () => Navigator.pop(context, 'hapus'),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          leading: const Icon(Icons.delete_outline_rounded),
          title: const Text('Hapus Dokumen'),
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom + 18,
        )
      ],
    );
  }

  Widget _buildStreamDokumenLab(BuildContext context) {
    return StreamBuilder<ApiResponse<DokumenLabSaveModel>>(
      stream: _dokumenLabSaveBloc.dokumenLabStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit();
            case Status.error:
              return ErrorDialog(
                message: snapshot.data!.message,
                onTap: () => Navigator.pop(context),
              );
            case Status.completed:
              return SuccessDialog(
                message: snapshot.data!.data!.message,
                onTap: () => Navigator.pop(context, snapshot.data!.data!.data),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

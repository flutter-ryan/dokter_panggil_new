import 'package:admin_dokter_panggil/src/models/mr_pengkajian_telemedicine_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_sub_form_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/deskripsi_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/pdfview_widget.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/resep_card_widget.dart';
import 'package:admin_dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart' as p;

class MrTindakanRadForm extends StatefulWidget {
  const MrTindakanRadForm({
    super.key,
    this.idKunjungan,
    this.mrKunjunganTindakanRad,
    this.dokumenRad,
  });

  final int? idKunjungan;
  final List<MrPengantarRad>? mrKunjunganTindakanRad;
  final List<RiwayatDokumenRad>? dokumenRad;

  @override
  State<MrTindakanRadForm> createState() => _MrTindakanRadFormState();
}

class _MrTindakanRadFormState extends State<MrTindakanRadForm> {
  List<MrPengantarRad> _pengantarRad = [];
  @override
  void initState() {
    super.initState();
    if (widget.mrKunjunganTindakanRad != null) {
      _pengantarRad = widget.mrKunjunganTindakanRad!;
    }
  }

  void _showHasilRad() {
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => HasilDokumenRadWidget(
        idKunjungan: widget.idKunjungan,
        dokumenRad: widget.dokumenRad,
      ),
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          // _showConfrimationDialog();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DashboardSubFormWidget(
      title: 'Radiologi',
      errorMessage: 'Data tindakan radiologi tidak tersedia',
      onAdd: null,
      dataCard: _pengantarRad.isEmpty
          ? null
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: _pengantarRad
                      .map(
                        (pengantarRad) => ResepCardWidget(
                          title: '${pengantarRad.tanggalPengantar}',
                          onView: _showHasilRad,
                          dataResep: Column(
                            children: pengantarRad.tindakanRad!
                                .map(
                                  (tindakanRad) => ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    title: Text('${tindakanRad.tindakanRad}'),
                                    leading:
                                        const Icon(Icons.arrow_right_rounded),
                                    minLeadingWidth: 8,
                                    horizontalTitleGap: 8,
                                  ),
                                )
                                .toList(),
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

class HasilDokumenRadWidget extends StatefulWidget {
  const HasilDokumenRadWidget({
    super.key,
    this.idKunjungan,
    this.dokumenRad,
  });

  final int? idKunjungan;
  final List<RiwayatDokumenRad>? dokumenRad;

  @override
  State<HasilDokumenRadWidget> createState() => _HasilDokumenRadWidgetState();
}

class _HasilDokumenRadWidgetState extends State<HasilDokumenRadWidget> {
  List<RiwayatDokumenRad> _dokumens = [];

  @override
  void initState() {
    super.initState();
    if (widget.dokumenRad != null) {
      _dokumens = widget.dokumenRad!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(22),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Dokumen Hasil Rad',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.grey,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close_rounded),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  var data = _dokumens[i];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 22),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          onTap: data.confirmedAt == null
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    SlideLeftRoute(
                                      page: PdfviewWidget(
                                        url: data.url,
                                      ),
                                    ),
                                  );
                                },
                          title: Text(
                            p.basename(data.url!),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          leading: SvgPicture.asset(
                            'images/pdf-ic.svg',
                            height: 42,
                          ),
                          subtitle: data.confirmedAt == null
                              ? null
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(22)),
                                    child: const Text(
                                      'Terkonfirmasi',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                ),
                          minLeadingWidth: 12.0,
                        ),
                        if (data.confirmedAt != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22.0, vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: DeskripsiWidget(
                                    title: 'Tanggal',
                                    body: Text(
                                      '${data.confirmedAt}',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: DeskripsiWidget(
                                    title: 'Petugas',
                                    body: Text(
                                      '${data.confirmedBy}',
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
                separatorBuilder: (context, i) => const SizedBox(
                  height: 18.0,
                ),
                itemCount: _dokumens.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

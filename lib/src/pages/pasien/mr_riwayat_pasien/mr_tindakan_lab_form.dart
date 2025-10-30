import 'package:admin_dokter_panggil/src/models/mr_pengkajian_telemedicine_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_sub_form_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/deskripsi_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/pdfview_widget.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/resep_card_widget.dart';
import 'package:admin_dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart' as p;

class MrTindakanLabForm extends StatefulWidget {
  const MrTindakanLabForm({
    super.key,
    this.idKunjungan,
    this.mrKunjunganTindakanLab,
    this.dokumenLab,
  });

  final int? idKunjungan;
  final List<MrPengantarLab>? mrKunjunganTindakanLab;
  final List<RiwayatDokumenLab>? dokumenLab;

  @override
  State<MrTindakanLabForm> createState() => _MrTindakanLabFormState();
}

class _MrTindakanLabFormState extends State<MrTindakanLabForm> {
  List<MrPengantarLab> _pengantarLab = [];

  @override
  void initState() {
    super.initState();
    if (widget.mrKunjunganTindakanLab != null) {
      _pengantarLab = widget.mrKunjunganTindakanLab!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardSubFormWidget(
      title: 'Laboratorium',
      errorMessage: 'Data tindakan laboratorium tidak tersedia',
      onAdd: null,
      dataCard: _pengantarLab.isEmpty
          ? null
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: _pengantarLab
                      .map((pengantarLab) => ResepCardWidget(
                            title: '${pengantarLab.tanggalPengantar}',
                            dataResep: Column(
                              children: pengantarLab.tindakanLab!
                                  .map(
                                    (tindakanLab) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          dense: true,
                                          title: Text(
                                              '${tindakanLab.tindakanLab}'),
                                          leading: const Icon(
                                              Icons.arrow_right_rounded),
                                          minLeadingWidth: 8,
                                          horizontalTitleGap: 8,
                                        ),
                                        if (tindakanLab.bhpLab!.isNotEmpty)
                                          Padding(
                                            padding: EdgeInsets.only(left: 32),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: tindakanLab.bhpLab!
                                                  .map((bhpLab) => Text(
                                                        '\u2022 ${bhpLab.namaBarang}',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey[600]),
                                                      ))
                                                  .toList(),
                                            ),
                                          )
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
    );
  }
}

class HasilLabImageWidget extends StatefulWidget {
  const HasilLabImageWidget({
    super.key,
    this.idKunjungan,
    this.dokumenLab,
  });

  final int? idKunjungan;
  final List<RiwayatDokumenLab>? dokumenLab;

  @override
  State<HasilLabImageWidget> createState() => _HasilLabImageWidgetState();
}

class _HasilLabImageWidgetState extends State<HasilLabImageWidget> {
  List<RiwayatDokumenLab> _dokumenLab = [];

  @override
  void initState() {
    super.initState();
    if (widget.dokumenLab != null) {
      _dokumenLab = widget.dokumenLab!;
    }
  }

  void _showDokumen(RiwayatDokumenLab? doc) {
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
                      'Dokumen Hasil Lab',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                itemBuilder: (context, i) {
                  var data = _dokumenLab[i];
                  return CardDokumenLabWidget(
                    onTap: data.confirmedAt != null
                        ? () => _showDokumen(data)
                        : null,
                    title: p.basename(data.url!),
                    subtitle: data.confirmedAt == null
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
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ),
                          ),
                    isConfirmed: data.confirmedAt != null,
                    tanggal: data.confirmedAt,
                    petugas: data.confirmedBy,
                  );
                },
                separatorBuilder: (context, i) => const Divider(
                  height: 12.0,
                ),
                itemCount: _dokumenLab.length,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }
}

class CardDokumenLabWidget extends StatelessWidget {
  const CardDokumenLabWidget({
    super.key,
    this.onTap,
    this.title,
    this.subtitle,
    this.trailing,
    this.isConfirmed = false,
    this.tanggal,
    this.petugas,
  });

  final VoidCallback? onTap;
  final String? title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool isConfirmed;
  final String? tanggal;
  final String? petugas;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: onTap,
            title: Text(
              '$title',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: subtitle,
            leading: SvgPicture.asset(
              'images/pdf-ic.svg',
              height: 42,
            ),
            minLeadingWidth: 12.0,
            trailing: trailing,
          ),
          if (isConfirmed) const Divider(),
          if (isConfirmed)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: DeskripsiWidget(
                      title: 'Tanggal',
                      body: Text(
                        '$tanggal',
                      ),
                    ),
                  ),
                  Expanded(
                    child: DeskripsiWidget(
                      title: 'Petugas',
                      body: Text(
                        '$petugas',
                      ),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

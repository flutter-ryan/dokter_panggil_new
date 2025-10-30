import 'dart:convert';
import 'dart:io';

import 'package:admin_dokter_panggil/src/models/mr_pengkajian_telemedicine_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_card_widget.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart' as p;

class MrDokumentasiForm extends StatefulWidget {
  const MrDokumentasiForm({
    super.key,
    this.idKunjungan,
    this.mrKunjunganDokumentasi,
  });

  final int? idKunjungan;
  final List<MrKunjunganDokumentasi>? mrKunjunganDokumentasi;

  @override
  State<MrDokumentasiForm> createState() => _MrDokumentasiFormState();
}

class _MrDokumentasiFormState extends State<MrDokumentasiForm> {
  List<MrKunjunganDokumentasi> _dokumentasis = [];

  @override
  void initState() {
    super.initState();
    if (widget.mrKunjunganDokumentasi != null) {
      _dokumentasis = widget.mrKunjunganDokumentasi!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCardWidget(
      title: 'Dokumentasi Telemedicine',
      errorMessage: 'Data dokumentasi tidak tersedia',
      onAdd: null,
      dataCard: _dokumentasis.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 22.0),
              child: SizedBox(
                height: 200,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    var data = _dokumentasis[i];
                    final imageProvider = Image.network(data.url!).image;
                    return InkWell(
                      onTap: () => showImageViewer(
                        context,
                        imageProvider,
                        useSafeArea: true,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Center(
                          child: Image.network(
                            data.url!,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, i) => const SizedBox(
                    width: 12.0,
                  ),
                  itemCount: _dokumentasis.length,
                ),
              ),
            ),
    );
  }
}

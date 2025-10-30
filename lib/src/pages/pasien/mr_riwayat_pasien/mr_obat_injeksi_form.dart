import 'package:admin_dokter_panggil/src/models/mr_pengkajian_dokter_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_sub_form_widget.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/resep_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MrObatInjeksiForm extends StatefulWidget {
  const MrObatInjeksiForm({
    super.key,
    this.idKunjungan,
    this.mrKunjunganObatInjeksi,
  });

  final int? idKunjungan;
  final List<MrKunjunganResepObatInjeksi>? mrKunjunganObatInjeksi;

  @override
  State<MrObatInjeksiForm> createState() => _MrObatInjeksiFormState();
}

class _MrObatInjeksiFormState extends State<MrObatInjeksiForm> {
  List<MrKunjunganResepObatInjeksi> _obatInjeksi = [];

  @override
  void initState() {
    super.initState();
    if (widget.mrKunjunganObatInjeksi != null) {
      _obatInjeksi = widget.mrKunjunganObatInjeksi!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardSubFormWidget(
      title: 'Obat Injeksi',
      errorMessage: 'Data obat injeksi tidak tersedia',
      onAdd: null,
      dataCard: _obatInjeksi.isEmpty
          ? null
          : Column(
              children: _obatInjeksi
                  .map(
                    (resep) => ResepCardWidget(
                      title: '${resep.tanggalResepInjeksi}',
                      dataResep: Column(
                        children: resep.obatInjeksi!
                            .map(
                              (obatInjeksi) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                isThreeLine:
                                    obatInjeksi.catatan != null ? true : false,
                                leading: const Icon(
                                  Icons.arrow_right_rounded,
                                ),
                                horizontalTitleGap: 8,
                                minLeadingWidth: 8,
                                title:
                                    Text('${obatInjeksi.barang!.namaBarang}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${obatInjeksi.aturanPakai} - ${obatInjeksi.jumlah!} buah',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    if (obatInjeksi.catatan != null)
                                      Text('Catatan: ${obatInjeksi.catatan}')
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  )
                  .toList()),
    );
  }
}

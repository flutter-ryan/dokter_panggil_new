import 'package:admin_dokter_panggil/src/models/mr_pengkajian_telemedicine_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_sub_form_widget.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/resep_card_widget.dart';
import 'package:flutter/material.dart';

class MrResepForm extends StatefulWidget {
  const MrResepForm({
    super.key,
    this.idKunjungan,
    this.mrKunjunganResep,
  });

  final int? idKunjungan;
  final List<MrKunjunganResepOral>? mrKunjunganResep;

  @override
  State<MrResepForm> createState() => _MrResepFormState();
}

class _MrResepFormState extends State<MrResepForm> {
  List<MrKunjunganResepOral> _resep = [];

  @override
  void initState() {
    super.initState();
    if (widget.mrKunjunganResep != null) {
      _resep = widget.mrKunjunganResep!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardSubFormWidget(
      title: 'Resep Oral',
      errorMessage: 'Data resep tidak tersedia',
      onAdd: null,
      dataCard: _resep.isEmpty
          ? null
          : Column(
              children: _resep
                  .map(
                    (resep) => ResepCardWidget(
                      title: '${resep.tanggalResepOral}',
                      dataResep: Column(
                        children: resep.obatOral!
                            .map(
                              (oral) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text('${oral.barang}'),
                                leading: const Icon(Icons.arrow_right_rounded),
                                minLeadingWidth: 8,
                                horizontalTitleGap: 8,
                                isThreeLine:
                                    oral.catatanTambahan != null ? true : false,
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${oral.aturanPakai} - ${oral.jumlah} Buah',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    if (oral.catatanTambahan != null)
                                      Text('Catatan: ${oral.catatanTambahan}')
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

import 'package:admin_dokter_panggil/src/models/mr_pengkajian_telemedicine_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_sub_form_widget.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class MrResepRacikanForm extends StatefulWidget {
  const MrResepRacikanForm({
    super.key,
    this.idKunjungan,
    this.mrKunjunganResepRacikan,
  });

  final int? idKunjungan;
  final List<MrKunjunganResepRacikan>? mrKunjunganResepRacikan;

  @override
  State<MrResepRacikanForm> createState() => _MrResepRacikanFormState();
}

class _MrResepRacikanFormState extends State<MrResepRacikanForm> {
  List<MrKunjunganResepRacikan> _resepRacikan = [];

  @override
  void initState() {
    super.initState();
    if (widget.mrKunjunganResepRacikan != null) {
      _resepRacikan = widget.mrKunjunganResepRacikan!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardSubFormWidget(
      title: 'Resep Racikan',
      errorMessage: 'Data racikan tidak tersedia',
      isRacikan: true,
      onAdd: null,
      dataCard: _resepRacikan.isEmpty
          ? null
          : Column(
              children: ListTile.divideTiles(
                context: context,
                tiles: _resepRacikan.map((resepRacikan) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                        color: kBgRedLightColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kPrimaryColor, width: 0.5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            '${resepRacikan.namaRacikan}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          dense: true,
                          subtitle: Text(
                            '${resepRacikan.tanggalRacikan}',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        const Text(
                          'Barang/Obat',
                          style: TextStyle(fontSize: 13.0, color: Colors.grey),
                        ),
                        Column(
                            children: ListTile.divideTiles(
                          context: context,
                          tiles: resepRacikan.barang!
                              .map(
                                (barang) => ListTile(
                                  leading: const Icon(
                                    Icons.arrow_right_rounded,
                                  ),
                                  minLeadingWidth: 8,
                                  horizontalTitleGap: 8,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    '${barang.barang}',
                                  ),
                                  subtitle: Text('Dosis: ${barang.dosis}'),
                                ),
                              )
                              .toList(),
                        ).toList()),
                        const Text(
                          'Petunjuk',
                          style: TextStyle(fontSize: 13.0, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text('${resepRacikan.petunjuk}'),
                        const SizedBox(
                          height: 12.0,
                        ),
                        const Text(
                          'Aturan pakai',
                          style: TextStyle(fontSize: 13.0, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text('${resepRacikan.aturanPakai}'),
                      ],
                    ),
                  );
                }).toList(),
              ).toList(),
            ),
    );
  }
}

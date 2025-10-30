import 'package:admin_dokter_panggil/src/blocs/mr_bhp_lab_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_bhp_lab_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_pengkajian_perawat_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_card_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class BarangHabisPakaiLab extends StatefulWidget {
  const BarangHabisPakaiLab({
    super.key,
    this.idKunjungan,
    this.isEdit = false,
    this.selesaiPengkajian,
  });

  final int? idKunjungan;
  final bool isEdit;
  final SelesaiPengkajianPerawat? selesaiPengkajian;

  @override
  State<BarangHabisPakaiLab> createState() => _BarangHabisPakaiLabState();
}

class _BarangHabisPakaiLabState extends State<BarangHabisPakaiLab> {
  final _mrBhpLabBloc = MrBhpLabBloc();

  @override
  void initState() {
    super.initState();
    _getBhpLab();
  }

  void _getBhpLab() {
    _mrBhpLabBloc.idKunjunganSink.add(widget.idKunjungan!);
    _mrBhpLabBloc.getBhpLab();
  }

  @override
  void dispose() {
    super.dispose();
    _mrBhpLabBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MrBhpLabModel>>(
      stream: _mrBhpLabBloc.bhpLabStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return SizedBox(
                height: 280,
                child: Center(
                  child: LoadingKit(
                    color: kPrimaryColor,
                  ),
                ),
              );
            case Status.error:
              return SizedBox(
                height: 280,
                child: Center(
                  child: Text(
                    snapshot.data!.message,
                    style: TextStyle(fontSize: 15, color: Colors.green[400]),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            case Status.completed:
              if (snapshot.data!.data!.data!.isEmpty) {
                return SizedBox();
              } else {
                return Column(
                  children: [
                    Divider(
                      color: Colors.grey[200],
                      thickness: 5,
                      height: 5,
                    ),
                    DashboardCardWidget(
                      title: 'Barang Habis Pakai (BHP) Lab',
                      errorMessage: 'Data barang habis pakai tidak tersedia',
                      dataCard: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: snapshot.data!.data!.data!
                              .map(
                                (bhpLab) => ListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  leading: const Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                  ),
                                  title: Text('${bhpLab.namaBarang}'),
                                  subtitle: Text('${bhpLab.jumlah} buah'),
                                  trailing: !widget.isEdit &&
                                          widget.selesaiPengkajian != null
                                      ? null
                                      : Icon(
                                          Icons.edit_note_rounded,
                                          color: Colors.blue,
                                        ),
                                  horizontalTitleGap: 12,
                                  minLeadingWidth: 12,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                );
              }
          }
        }
        return SizedBox(
          height: 280,
        );
      },
    );
  }
}

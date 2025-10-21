import 'package:admin_dokter_panggil/src/blocs/kunjungan_eresep_bloc.dart';
import 'package:admin_dokter_panggil/src/models/kunjungan_eresep_model.dart';
import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:admin_dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:share_plus/share_plus.dart';

class EresepRacikanWidget extends StatefulWidget {
  const EresepRacikanWidget({
    super.key,
    required this.idKunjungan,
    required this.data,
    this.idPegawai,
  });

  final int idKunjungan;
  final List<ResepRacikan> data;
  final int? idPegawai;

  @override
  State<EresepRacikanWidget> createState() => _EresepRacikanWidgetState();
}

class _EresepRacikanWidgetState extends State<EresepRacikanWidget> {
  final _controller = ScrollController();
  final _kunjunganEresepBloc = KunjunganEresepBloc();
  late List<ResepRacikan> _data;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  void _kirimEresepRacikan() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          onConfirm: () => Navigator.pop(context, 'eresep'),
          message: 'Anda yakin ingin membuat resep?',
          labelConfirm: 'Ya, Saya yakin',
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        _kunjunganEresepBloc.idPegawaisink.add(widget.idPegawai!);
        _kunjunganEresepBloc.idSink.add(widget.idKunjungan);
        _kunjunganEresepBloc.getEresepRacikanBaru();
        _showStreamEresep();
      }
    });
  }

  void _showStreamEresep() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamEresep();
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) async {
      if (value != null) {
        var data = value as Eresep;
        _share(data);
      }
    });
  }

  Future<void> _share(Eresep data) async {
    SharePlus.instance.share(
      ShareParams(
        title: 'E-Resep Pasien ${data.namaPasien}',
        text:
            'ERESEP dokter panggil\nPasien ${data.namaPasien}\n\n${Uri.parse(data.url!).toString()}',
        subject: 'E-Resep ${data.namaPasien}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              controller: _controller,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemBuilder: (context, i) {
                var racikan = _data[i];
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('${racikan.petunjuk}'),
                      subtitle: Text('Aturan pakai: ${racikan.aturanPakai}'),
                    ),
                    Column(
                      children: racikan.barang!
                          .map(
                            (barang) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: 0,
                              leading: const Icon(Icons.keyboard_arrow_right),
                              title: Text("${barang.barang}"),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, i) => const Divider(),
              itemCount: _data.length,
            ),
          ),
          const SizedBox(
            height: 22.0,
          ),
          ElevatedButton(
            onPressed: _kirimEresepRacikan,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 45.0),
              backgroundColor: kPrimaryColor,
            ),
            child: const Text('Kirim E-Resep'),
          )
        ],
      ),
    );
  }

  Widget _streamEresep() {
    return StreamBuilder<ApiResponse<KunjunganEresepModel>>(
      stream: _kunjunganEresepBloc.eresepStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit();
            case Status.error:
              return ErrorDialog(
                message: snapshot.data!.message,
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

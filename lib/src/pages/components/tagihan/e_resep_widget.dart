import 'package:dokter_panggil/src/blocs/kunjungan_eresep_bloc.dart';
import 'package:dokter_panggil/src/models/kunjungan_eresep_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

class EresepWidget extends StatefulWidget {
  const EresepWidget({
    super.key,
    this.dokter,
    required this.data,
    this.idKunjungan,
  });

  final Dokter? dokter;
  final int? idKunjungan;
  final List<Resep> data;

  @override
  State<EresepWidget> createState() => _EresepWidgetState();
}

class _EresepWidgetState extends State<EresepWidget> {
  final KunjunganEresepBloc _kunjunganEresepBloc = KunjunganEresepBloc();
  final _scrollCon = ScrollController();
  List<Resep> _data = [];

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  void _kirimEresep() {
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
        _kunjunganEresepBloc.idSink.add(widget.dokter!.idKunjungan!);
        _kunjunganEresepBloc.idPegawaisink.add(widget.dokter!.idDokter!);
        _kunjunganEresepBloc.getEresepBaru();
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
    await WhatsappShare.share(
      text: 'ERESEP dokter panggil\n\nPasien ${data.namaPasien}',
      linkUrl: Uri.parse(data.url!).toString(),
      phone: '+6281343660768',
    );
  }

  @override
  void dispose() {
    _kunjunganEresepBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              controller: _scrollCon,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              shrinkWrap: true,
              itemBuilder: (context, i) {
                var resep = _data[i];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('${resep.barang}'),
                  subtitle: Text('${resep.aturanPakai} - ${resep.jumlah} buah'),
                );
              },
              separatorBuilder: (context, i) => const Divider(),
              itemCount: _data.length,
            ),
          ),
          const SizedBox(
            height: 18.0,
          ),
          ElevatedButton(
            onPressed: _kirimEresep,
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
              return const LoadingKit(
                color: Colors.white,
              );
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

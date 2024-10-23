import 'package:dokter_panggil/src/blocs/batal_final_petugas_bloc.dart';
import 'package:dokter_panggil/src/models/batal_final_petugas_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/pages/components/badge.dart' as badge_custom;
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';

class DetailPetugasWidget extends StatefulWidget {
  const DetailPetugasWidget({
    Key? key,
    required this.data,
    this.reload,
  }) : super(key: key);

  final DetailKunjungan data;
  final Function(DetailKunjungan? data)? reload;

  @override
  State<DetailPetugasWidget> createState() => _DetailPetugasWidgetState();
}

class _DetailPetugasWidgetState extends State<DetailPetugasWidget> {
  final _batalFinalPetugasBloc = BatalFinalPetugasBloc();
  late DetailKunjungan _data;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  void _batalFinalPetugas(int? idPetugas, bool? isDokter) {
    if (idPetugas != null) {
      showAnimatedDialog(
        context: context,
        builder: (context) {
          return _showConfirmDialog(context);
        },
        duration: const Duration(milliseconds: 500),
        animationType: DialogTransitionType.slideFromBottomFade,
      ).then((value) {
        if (value != null) {
          _batalFinalPetugasBloc.idKunjunganSink.add(_data.id!);
          _batalFinalPetugasBloc.idPetugasSink.add(idPetugas);
          _batalFinalPetugasBloc.isDokterSink.add(isDokter!);
          _batalFinalPetugasBloc.batalFinal();
          _showStreamDialogBatal();
        }
      });
    }
  }

  void _showStreamDialogBatal() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamDialogBatalFinal(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        widget.reload!(data);
      }
    });
  }

  @override
  void didUpdateWidget(covariant DetailPetugasWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      setState(() {
        _data = widget.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              'Petugas',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(
            height: 22.0,
          ),
          if (_data.dokter!.isNotEmpty)
            Column(
              children: _data.dokter!
                  .map(
                    (dokter) => ListTile(
                      dense: true,
                      title: Row(
                        children: [
                          Flexible(child: Text('${dokter.dokter}')),
                          const SizedBox(
                            width: 8.0,
                          ),
                          if (dokter.konsul)
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: badge_custom.Badge(
                                color: Colors.indigo,
                                label: 'Konsul',
                              ),
                            ),
                          badge_custom.Badge(
                            color:
                                dokter.status == 3 ? Colors.green : Colors.red,
                            label: dokter.status == 3 ? 'Final' : 'Waiting',
                          ),
                        ],
                      ),
                      subtitle: Text('${dokter.profesi}'),
                      trailing: _data.status != 5
                          ? ElevatedButton(
                              onPressed: dokter.status == 3
                                  ? () =>
                                      _batalFinalPetugas(dokter.idDokter, true)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                              child: const Text('Batal'),
                            )
                          : null,
                    ),
                  )
                  .toList(),
            ),
          if (_data.perawat != null)
            Column(
              children: _data.perawat!
                  .map(
                    (perawat) => ListTile(
                      dense: true,
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(child: Text('${perawat.perawat}')),
                          const SizedBox(
                            width: 8.0,
                          ),
                          badge_custom.Badge(
                            color:
                                perawat.status == 3 ? Colors.green : Colors.red,
                            label: perawat.status == 3 ? 'Final' : 'Waiting',
                          ),
                        ],
                      ),
                      subtitle: Text('${perawat.profesi}'),
                      trailing: _data.status != 5
                          ? ElevatedButton(
                              onPressed: perawat.status == 3
                                  ? () => _batalFinalPetugas(
                                      perawat.idPerawat, false)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                              child: const Text('Batal'),
                            )
                          : null,
                    ),
                  )
                  .toList(),
            )
        ],
      ),
    );
  }

  Widget _showConfirmDialog(BuildContext context) {
    return ConfirmDialogWidget(
      message: 'Anda yakin ingin membatalkan final layanan ini?',
      labelConfirm: 'Ya, Batalkan',
      onConfirm: () => Navigator.pop(context, 'confirm'),
    );
  }

  Widget _streamDialogBatalFinal(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseBatalFinalPetugasModel>>(
        stream: _batalFinalPetugasBloc.batalFinalStream,
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
                  onTap: () =>
                      Navigator.pop(context, snapshot.data!.data!.detail),
                );
            }
          }
          return const SizedBox();
        });
  }
}

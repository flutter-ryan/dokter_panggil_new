import 'package:dokter_panggil/src/blocs/batal_final_petugas_bloc.dart';
import 'package:dokter_panggil/src/blocs/tambah_perawat_bloc.dart';
import 'package:dokter_panggil/src/blocs/tambah_perawat_hapus_bloc.dart';
import 'package:dokter_panggil/src/models/batal_final_petugas_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/models/pegawai_dokter_model.dart';
import 'package:dokter_panggil/src/models/tambah_perawat_hapus_model.dart';
import 'package:dokter_panggil/src/models/tambah_perawat_model.dart';
import 'package:dokter_panggil/src/pages/components/badge.dart' as badge_custom;
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/pasien/pilih_petugas_page.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DetailPetugasWidget extends StatefulWidget {
  const DetailPetugasWidget({
    super.key,
    required this.data,
    this.reload,
    this.isDokter,
  });

  final DetailKunjungan data;
  final Function(DetailKunjungan? data)? reload;
  final bool? isDokter;

  @override
  State<DetailPetugasWidget> createState() => _DetailPetugasWidgetState();
}

class _DetailPetugasWidgetState extends State<DetailPetugasWidget> {
  final _batalFinalPetugasBloc = BatalFinalPetugasBloc();
  final _tambahPerawatBloc = TambahPerawatBloc();
  final _tambahPerawatHapusBloc = TambahPerawatHapusBloc();
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

  void _showPerawat() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        top: false,
        child: PilihPetugasPage(
          idGroup: 2,
        ),
      ),
    ).then((value) {
      if (value != null) {
        final perawat = value as PegawaiProfesi;
        Future.delayed(const Duration(milliseconds: 500), () {
          _confirmationPerawat(perawat);
        });
      }
    });
  }

  void _confirmationPerawat(PegawaiProfesi perawat) {
    showAnimatedDialog(
      context: context,
      builder: (context) => ConfirmDialogWidget(
        message: 'Anda yakin inging menambahkan perawat ${perawat.nama}',
        onConfirm: () => Navigator.pop(context, 'confirm'),
        labelConfirm: 'Ya, Tambahkan',
      ),
      animationType: DialogTransitionType.slideFromBottom,
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _tambahPerawatBloc.idKunjunganSink.add(widget.data.id!);
          _tambahPerawatBloc.idPetugasSink.add(perawat.id!);
          _tambahPerawatBloc.tambahPerawat();
          _showStreamTambahPerawat();
        });
      }
    });
  }

  void _showStreamTambahPerawat() {
    showAnimatedDialog(
      context: context,
      builder: (context) => _streamTambahPerawat(context),
      animationType: DialogTransitionType.slideFromBottom,
    ).then((value) {
      if (value != null) {
        final perawat = value as List<Perawat>;
        setState(() {
          _data.perawat = perawat;
        });
      }
    });
  }

  void _hapusPetugas(Perawat perawat) {
    showAnimatedDialog(
      context: context,
      builder: (context) => ConfirmDialogWidget(
        message: 'Anda yakin ingin menghapus perawat ${perawat.perawat}',
        onConfirm: () => Navigator.pop(context, 'confirm'),
      ),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _tambahPerawatHapusBloc.idKonfirmasiPerawatSink.add(perawat.id!);
          _tambahPerawatHapusBloc.hapusPerawat();
          _showStreamHapusPerawat();
        });
      }
    });
  }

  void _showStreamHapusPerawat() {
    showAnimatedDialog(
      context: context,
      builder: (context) => _streamHapusPerawat(context),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        final perawat = value as Perawat;
        setState(() {
          _data.perawat!.removeWhere((data) => data.id == perawat.id);
        });
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
  void dispose() {
    super.dispose();
    _tambahPerawatBloc.dispose();
    _batalFinalPetugasBloc.dispose();
    _tambahPerawatHapusBloc.dispose();
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.isDokter! ? 'Dokter' : 'Perawat',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (!widget.isDokter!)
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.transparent,
                    foregroundColor: kPrimaryColor,
                    child: IconButton(
                      onPressed: _showPerawat,
                      icon: const Icon(Icons.add),
                      padding: EdgeInsets.zero,
                      iconSize: 22,
                    ),
                  ),
              ],
            ),
          ),
          const Divider(
            height: 22.0,
          ),
          if (widget.isDokter!)
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
            )
          else if (_data.perawat!.isEmpty)
            Padding(
              padding: EdgeInsets.all(18),
              child: Center(
                child: Text(
                  'Data tidak tersedia',
                  style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                ),
              ),
            )
          else
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
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!widget.isDokter! &&
                                    perawat.isAdminAdd == 1)
                                  IconButton(
                                    onPressed: () => _hapusPetugas(perawat),
                                    icon: Icon(
                                      Icons.delete_rounded,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                  ),
                                if (!widget.isDokter! &&
                                    perawat.isAdminAdd == 1)
                                  SizedBox(
                                    width: 8,
                                  ),
                                ElevatedButton(
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
                                ),
                              ],
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

  Widget _streamTambahPerawat(BuildContext context) {
    return StreamBuilder<ApiResponse<TambahPerawatModel>>(
      stream: _tambahPerawatBloc.tambahPerawatStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingKit();
            case Status.error:
              return ErrorDialog(
                message: snapshot.data!.message,
                onTap: () => Navigator.pop(context),
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

  Widget _streamHapusPerawat(BuildContext context) {
    return StreamBuilder<ApiResponse<TambahPerawatHapusModel>>(
      stream: _tambahPerawatHapusBloc.hapusPerawatStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingKit();
            case Status.error:
              return ErrorDialog(
                message: snapshot.data!.message,
                onTap: () => Navigator.pop(context),
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

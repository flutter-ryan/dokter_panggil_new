import 'package:admin_dokter_panggil/src/blocs/batal_final_petugas_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/mr_petugas_konsul_save_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/tambah_perawat_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/tambah_perawat_hapus_bloc.dart';
import 'package:admin_dokter_panggil/src/models/batal_final_petugas_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_petugas_konsul_save_model.dart';
import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:admin_dokter_panggil/src/models/pegawai_dokter_model.dart';
import 'package:admin_dokter_panggil/src/models/tambah_perawat_hapus_model.dart';
import 'package:admin_dokter_panggil/src/models/tambah_perawat_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/badge.dart'
    as badge_custom;
import 'package:admin_dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/pilih_petugas_page.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:admin_dokter_panggil/src/source/transition/animated_dialog.dart';
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
  final _mrPetugasKonsulSaveBloc = MrPetugasKonsulSaveBloc();
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

  void _showPilihanPetugas() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => _pilihanPetugas(context),
    ).then((value) {
      if (value != null) {
        final pilihan = value as int;
        _mrPetugasKonsulSaveBloc.pilihanPetugasSink.add(pilihan);
        Future.delayed(const Duration(milliseconds: 500), () {
          _showPetugas(1);
        });
      }
    });
  }

  void _showPetugas(int idGroup) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        top: false,
        child: PilihPetugasPage(
          idGroup: idGroup,
        ),
      ),
    ).then((value) {
      if (value != null) {
        final petugas = value as PegawaiProfesi;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (idGroup == 1) {
            _confirmationDokter(petugas);
          } else {
            _confirmationPerawat(petugas);
          }
        });
      }
    });
  }

  void _confirmationPerawat(PegawaiProfesi perawat) {
    showAnimatedDialog(
      context: context,
      builder: (context) => ConfirmDialogWidget(
        message: 'Anda yakin ingin menambahkan perawat ${perawat.nama}',
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

  void _confirmationDokter(PegawaiProfesi dokter) {
    showAnimatedDialog(
      context: context,
      builder: (context) => ConfirmDialogWidget(
        message: 'Anda yakin ingin menambahkan\n${dokter.nama}',
        onConfirm: () => Navigator.pop(context, 'confirm'),
        labelConfirm: 'Ya, Tambahkan',
      ),
      animationType: DialogTransitionType.slideFromBottom,
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _mrPetugasKonsulSaveBloc.idKunjunganSink.add(widget.data.id!);
          _mrPetugasKonsulSaveBloc.idPetugasSink.add(dokter.id!);
          _mrPetugasKonsulSaveBloc.simpanPetugasKonsul();
          _showStreamTambahDokter('create');
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

  void _showStreamTambahDokter(String jenis) {
    showAnimatedDialog(
      context: context,
      builder: (context) => _streamTambahDokter(context),
      animationType: DialogTransitionType.slideFromBottom,
    ).then((value) {
      if (value != null) {
        final dokter = value as Dokter;
        if (jenis == 'hapus') {
          setState(() {
            _data.dokter!
                .removeWhere((konfirmasi) => konfirmasi.id == dokter.id);
          });
        } else {
          setState(() {
            _data.dokter!.add(dokter);
          });
        }
      }
    });
  }

  void _hapusPerawat(Perawat perawat) {
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

  void _hapusDokter(Dokter dokter) {
    showAnimatedDialog(
      context: context,
      builder: (context) => ConfirmDialogWidget(
        message: 'Anda yakin ingin menghapus\n${dokter.dokter}',
        onConfirm: () => Navigator.pop(context, 'confirm'),
      ),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _mrPetugasKonsulSaveBloc.idKonfirmasiSink.add(dokter.id!);
          _mrPetugasKonsulSaveBloc.deletePetugasKonsul();
          _showStreamTambahDokter('hapus');
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
    _mrPetugasKonsulSaveBloc.dispose();
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
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.transparent,
                  foregroundColor: kPrimaryColor,
                  child: IconButton(
                    onPressed: !widget.isDokter!
                        ? () => _showPetugas(2)
                        : _showPilihanPetugas,
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
                      title: Text('${dokter.dokter}'),
                      subtitle: Row(
                        children: [
                          Text('${dokter.profesi}'),
                          SizedBox(
                            width: 8,
                          ),
                          if (dokter.konsul)
                            const badge_custom.Badge(
                              color: Colors.indigo,
                              label: 'Konsul',
                            ),
                          badge_custom.Badge(
                            color:
                                dokter.status == 3 ? Colors.green : Colors.red,
                            label: dokter.status == 3 ? 'Final' : 'Waiting',
                          ),
                        ],
                      ),
                      trailing: _data.status != 5
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (dokter.isAdminAdd!)
                                  IconButton(
                                    onPressed: () => _hapusDokter(dokter),
                                    icon: Icon(
                                      Icons.delete_rounded,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                  ),
                                ElevatedButton(
                                  onPressed: dokter.status == 3
                                      ? () => _batalFinalPetugas(
                                          dokter.idDokter, true)
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
                      title: Text('${perawat.perawat}'),
                      subtitle: Row(
                        children: [
                          Text('${perawat.profesi}'),
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
                      trailing: _data.status != 5
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!widget.isDokter! &&
                                    perawat.isAdminAdd == 1)
                                  IconButton(
                                    onPressed: () => _hapusPerawat(perawat),
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
                                if (perawat.isTimbangTerima == 1)
                                  SizedBox(
                                    width: 72,
                                    child: Text(
                                      'Timbang Terima',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                else
                                  ElevatedButton(
                                    onPressed: perawat.status == 3
                                        ? () => _batalFinalPetugas(
                                            perawat.idPerawat, false)
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
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

  Widget _streamTambahDokter(BuildContext context) {
    return StreamBuilder<ApiResponse<MrPetugasKonsulSaveModel>>(
      stream: _mrPetugasKonsulSaveBloc.petugasKonsulSaveStream,
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

  Widget _pilihanPetugas(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Text(
              'Plih Salah Satu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Divider(
            height: 0,
          ),
          ListTile(
            onTap: () => Navigator.pop(context, 1),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 22),
            title: Text('Konsul Kerja Sama'),
            leading: const Icon(Icons.arrow_right_rounded),
            minLeadingWidth: 18,
          ),
          ListTile(
            onTap: () => Navigator.pop(context, 2),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 22),
            title: Text('Konsul Alih Rawat'),
            leading: const Icon(Icons.arrow_right_rounded),
            minLeadingWidth: 18,
          )
        ],
      ),
    );
  }
}

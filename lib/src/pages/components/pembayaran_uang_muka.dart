import 'package:dokter_panggil/src/blocs/konfirmasi_deposit_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_biaya_admin_bloc.dart';
import 'package:dokter_panggil/src/models/konfirmasi_deposit_model.dart';
import 'package:dokter_panggil/src/models/master_biaya_admin_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/detail_tagihan.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/list_tagihan_widget.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';

class PembayaranUangMuka extends StatefulWidget {
  const PembayaranUangMuka({
    super.key,
    required this.id,
    required this.tindakan,
  });

  final int id;
  final List<Tindakan> tindakan;

  @override
  State<PembayaranUangMuka> createState() => _PembayaranUangMukaState();
}

class _PembayaranUangMukaState extends State<PembayaranUangMuka> {
  final _masterBiayaAdminBloc = MasterBiayaAdminBloc();

  @override
  void initState() {
    _masterBiayaAdminBloc.getMasterBiayaAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterBiayaAdminModel>>(
      stream: _masterBiayaAdminBloc.masterBiayaAdminStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 200,
                child: LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
              );
            case Status.completed:
              return FormUangMuka(
                id: widget.id,
                tindakan: widget.tindakan,
                biaya: snapshot.data!.data!.data!,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class FormUangMuka extends StatefulWidget {
  const FormUangMuka({
    super.key,
    required this.id,
    required this.tindakan,
    required this.biaya,
  });

  final int id;
  final List<Tindakan> tindakan;
  final List<MasterBiayaAdmin> biaya;

  @override
  State<FormUangMuka> createState() => _FormUangMukaState();
}

class _FormUangMukaState extends State<FormUangMuka> {
  final _konfirmasiDepositBloc = KonfirmasiDepositBloc();
  final _noRupiah =
      NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '');
  final List<BiayaAdminSelected> _selectedBiaya = [];
  final List<bool> _checked = [];
  int _nilaiBayar = 0;

  @override
  void initState() {
    super.initState();
    getTotalTindakan();
  }

  void getTotalTindakan() {
    var total = 0;
    var tindakans = widget.tindakan
        .where((tindakan) => tindakan.bayarLangsung == 1)
        .toList();
    for (var tindakan in tindakans) {
      total += tindakan.tarif!;
    }
    setState(() {
      _nilaiBayar = total;
    });
  }

  void _konfirmasiDeposit() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda yakin meng-konfirmasi pembayaran ini?',
          onConfirm: () => Navigator.pop(context, 'confirm'),
          labelConfirm: 'Ya, Lanjutkan',
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        List<String> deskripsiBiayaAdmin = [];
        List<int> nilaiBiayaAdmin = [];
        _selectedBiaya.map((biaya) {
          deskripsiBiayaAdmin.add(biaya.deskripsi!);
          nilaiBiayaAdmin.add(biaya.nilai);
        }).toList();
        _konfirmasiDepositBloc.idKunjunganSink.add(widget.id);
        _konfirmasiDepositBloc.statusSink.add(1);
        _konfirmasiDepositBloc.nilaiPembayaranSink.add('-$_nilaiBayar');
        _konfirmasiDepositBloc.deskripsiBiayaAdminSink.add(deskripsiBiayaAdmin);
        _konfirmasiDepositBloc.nilaiBiayaAdminSink.add(nilaiBiayaAdmin);
        _konfirmasiDepositBloc.konfirmasiPembayaran();
        _showDialogStream();
      }
    });
  }

  void _showDialogStream() {
    showDialog(
      context: context,
      builder: (context) {
        return _streamSaveDeposit();
      },
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        Future.delayed(const Duration(milliseconds: 200), () {
          if (!mounted) return;
          Navigator.pop(context, data);
        });
      }
    });
  }

  void _selectBiaya(bool val, MasterBiayaAdmin biaya) {
    if (val) {
      double persen = (biaya.nilai! * _nilaiBayar) / 100;
      _selectedBiaya.add(
        BiayaAdminSelected(
          id: biaya.id,
          deskripsi: biaya.deskripsi,
          nilai: biaya.persen == 1 ? persen.round() : biaya.nilai!,
        ),
      );
    } else {
      if (_selectedBiaya.isNotEmpty) {
        _selectedBiaya.removeWhere((selected) => selected.id == biaya.id);
      }
    }
  }

  @override
  void dispose() {
    _konfirmasiDepositBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pembayaran deposit',
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 32.0,
        ),
        const Text(
          'Layanan',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Column(
          children: widget.tindakan
              .map(
                (tindakan) => Detailtagihan(
                  namaTagihan: Text('${tindakan.namaTindakan}'),
                  tarifTagihan: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Rp. ',
                          style: TextStyle(fontSize: 13.0),
                        ),
                        Text(
                          _noRupiah.format(tindakan.jasaDokter! +
                              tindakan.jasaDokterPanggil!),
                          style: const TextStyle(fontSize: 13.0),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        _listBiayaAdmin(context),
        const SizedBox(
          height: 22.0,
        ),
        ElevatedButton(
          onPressed: () => _konfirmasiDeposit(),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 45),
            backgroundColor: kPrimaryColor,
          ),
          child: const Text('Konfirmasi Pembayaran'),
        ),
      ],
    );
  }

  Widget _listBiayaAdmin(BuildContext context) {
    double widthBox = 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: Colors.grey,
        ),
        const SizedBox(
          height: 12.0,
        ),
        const Text(
          'Biaya Admin',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Column(
          children: widget.biaya.map((biaya) {
            _checked.add(false);
            return CheckboxListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
              value: _checked[widget.biaya.indexOf(biaya)],
              dense: true,
              onChanged: (value) {
                _selectBiaya(value!, biaya);
                setState(() {
                  _checked[widget.biaya.indexOf(biaya)] = value;
                });
              },
              selectedTileColor: Colors.green,
              title: Row(
                children: [
                  Expanded(
                    child: Text('${biaya.deskripsi}'),
                  ),
                  SizedBox(
                    width: widthBox,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Rp. '),
                        Flexible(
                          child: Text(
                            _noRupiah.format(biaya.nilai),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Colors.green,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _streamSaveDeposit() {
    return StreamBuilder<ApiResponse<ResponseKonfirmasiDepositModel>>(
      stream: _konfirmasiDepositBloc.konfirmasiDepositStream,
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

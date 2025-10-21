import 'package:admin_dokter_panggil/src/blocs/kunjungan_batal_bloc.dart';
import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:admin_dokter_panggil/src/models/pendaftaran_kunjungan_save_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/badge.dart'
    as badgecustom;
import 'package:admin_dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/detail_layanan_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:admin_dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';

class DetailIdentitasWidget extends StatefulWidget {
  const DetailIdentitasWidget({
    super.key,
    required this.id,
    required this.data,
    this.type = 'create',
  });

  final int id;
  final DetailKunjungan data;
  final String type;

  @override
  State<DetailIdentitasWidget> createState() => _DetailIdentitasWidgetState();
}

class _DetailIdentitasWidgetState extends State<DetailIdentitasWidget> {
  final KunjunganBatalBloc _kunjunganBatalBloc = KunjunganBatalBloc();
  final DateFormat _tanggal = DateFormat('dd MMM yyyy', 'id');

  void _batal() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda yakin membatalkan layanan',
          onConfirm: () => Navigator.pop(context, 'confirm'),
          labelConfirm: 'Ya, Batalkan',
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _kunjunganBatalBloc.idSink.add(widget.id);
          _kunjunganBatalBloc.batalKunjungan();
          _showDialogStream();
        });
      }
    });
  }

  void _showDialogStream() {
    showDialog(
      context: context,
      builder: (context) {
        return StreamBuilder<
            ApiResponse<ResponsePendaftaranKunjunganSaveModel>>(
          stream: _kunjunganBatalBloc.kunjunganBatalStream,
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
                    onTap: () =>
                        Navigator.pop(context, snapshot.data!.data!.kunjungan),
                  );
              }
            }
            return const SizedBox();
          },
        );
      },
    ).then((value) {
      if (value != null) {
        HomeAction homeAction = HomeAction(type: 'batal');
        if (!mounted) return;
        Navigator.pop(context, homeAction);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.account_circle_outlined,
              color: Colors.grey[400],
              size: 52.0,
            ),
            title: Text('${widget.data.pasien!.namaPasien}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${widget.data.pasien!.jenisKelamin} - ${widget.data.pasien!.umur}'),
                const SizedBox(
                  height: 8.0,
                ),
              ],
            ),
            trailing: widget.type != 'view'
                ? IconButton(
                    onPressed: [1, 4].contains(widget.data.status) &&
                            widget.data.deposit == 0
                        ? _batal
                        : null,
                    color: Colors.red,
                    icon: const Icon(
                      Icons.delete,
                    ),
                  )
                : const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
          ),
          Container(
            height: widget.data.isPaket ? 80 : 70,
            decoration: BoxDecoration(
              color: kPrimaryColor.withAlpha(12),
              border: Border.all(width: 0.2, color: kPrimaryColor),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: DetailInfoRegPasien(
                    label: '#Registrasi',
                    body: Text('${widget.data.nomorRegistrasi}'),
                  ),
                ),
                VerticalDivider(
                  width: 0.0,
                  color: kPrimaryColor.withAlpha(120),
                ),
                Expanded(
                  child: DetailInfoRegPasien(
                    label: 'Tgl. Lahir',
                    body: Text(
                      _tanggal.format(
                          DateTime.parse(widget.data.pasien!.tanggalLahir!)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                VerticalDivider(
                  width: 0.0,
                  color: kPrimaryColor.withAlpha(120),
                ),
                Expanded(
                  child: DetailInfoRegPasien(
                    label: 'Status',
                    body: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _statusRegistrasi(widget.data.status),
                        widget.data.isPaket
                            ? const Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: badgecustom.Badge(
                                  label: 'Paket',
                                  color: Colors.blue,
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _statusRegistrasi(int? status) {
    if (status == 1) {
      return const badgecustom.Badge(
        label: 'Pending',
        color: Colors.red,
      );
    } else if (status == 2) {
      return const badgecustom.Badge(
        label: 'Pelayanan',
        color: Colors.green,
      );
    } else if (status == 3) {
      return const badgecustom.Badge(
        label: 'Final layanan',
        color: Colors.green,
      );
    } else if (status == 4) {
      return const badgecustom.Badge(
        label: 'Deposit',
        color: Colors.blue,
      );
    } else if (status == 5) {
      return const badgecustom.Badge(
        label: 'Final tagihan',
        color: Colors.green,
      );
    }
    return const SizedBox();
  }
}

class DetailInfoRegPasien extends StatelessWidget {
  const DetailInfoRegPasien({
    super.key,
    required this.label,
    required this.body,
  });

  final String label;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
          ),
        ),
        const SizedBox(
          height: 6.0,
        ),
        body
      ],
    );
  }
}

class DetailPasien extends StatelessWidget {
  const DetailPasien({
    super.key,
    this.title,
    this.body,
  });

  final String? title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$title',
          style: const TextStyle(fontSize: 12.0, color: Colors.grey),
        ),
        const SizedBox(
          height: 4.0,
        ),
        Text('$body')
      ],
    );
  }
}

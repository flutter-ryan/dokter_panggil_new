import 'dart:async';

import 'package:admin_dokter_panggil/src/blocs/admin_kunjungan_pasien_bloc.dart';
import 'package:admin_dokter_panggil/src/models/admin_kunjungan_pasien_delete_model.dart';
import 'package:admin_dokter_panggil/src/models/admin_kunjungan_pasien_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/close_button.dart';
import 'package:admin_dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/header.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:admin_dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminArea extends StatefulWidget {
  const AdminArea({super.key});

  @override
  State<AdminArea> createState() => _AdminAreaState();
}

class _AdminAreaState extends State<AdminArea> {
  final _adminKunjunganPasienBloc = AdminKunjunganPasienBloc();
  final controller = ScrollController();
  TextEditingController? _filter;
  List<StatusEnum> _statusEnum = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getAdminKunjungan();
    _filter = TextEditingController(text: '');
    _filter!.addListener(_filterListen);
    controller.addListener(_scrollListen);
    _statusEnum = [
      StatusEnum(
        status: 1,
        message: "Menunggu konfirmasi",
        color: Colors.orange,
      ),
      StatusEnum(
        status: 2,
        message: "Sedang dilayani",
        color: Colors.blue,
      ),
      StatusEnum(
        status: 4,
        message: "Menunggu pembayaran dimuka",
        color: Colors.amber,
      ),
      StatusEnum(
        status: 5,
        message: "Final Tagihan",
        color: Colors.green,
      )
    ];
  }

  void _filterListen() {
    if (_filter!.text.isNotEmpty) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _adminKunjunganPasienBloc.filterSink.add(_filter!.text);
        _adminKunjunganPasienBloc.getAdminKunjunganPasien();
        timer.cancel();
        setState(() {});
      });
    }
  }

  void _getAdminKunjungan() {
    _adminKunjunganPasienBloc.getAdminKunjunganPasien();
  }

  void _batalKunjungan(int id) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          onConfirm: () => Navigator.pop(context, 'confirm'),
          message: 'Anda yakin membatalkan kunjungan ini?',
          labelConfirm: 'Ya, Batalkan',
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _adminKunjunganPasienBloc.idKunjunganSink.add(id);
        _adminKunjunganPasienBloc.deleteAdminKunjungan();
        _showStreamDeleteAdminKunjungan();
      }
    });
  }

  void _showStreamDeleteAdminKunjungan() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamDeleteKunjunganAdmin(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    );
  }

  void _scrollListen() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      _adminKunjunganPasienBloc.getNextAdminKunjunganPasien();
    }
  }

  @override
  void dispose() {
    _adminKunjunganPasienBloc.dispose();
    _filter?.dispose();
    _filter?.removeListener(_filterListen);
    controller.removeListener(_scrollListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Column(
          children: [
            Header(
              title: 'Daftar Kunjungan',
              subtitle: SearchInputForm(
                controller: _filter,
                hint: 'Pencarian nama pasien',
              ),
              closeButton: const ClosedButton(),
            ),
            Expanded(
              child: _streamAdminKunjunganPasien(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _streamAdminKunjunganPasien(BuildContext context) {
    return StreamBuilder<ApiResponse<AdminKunjunganPasienModel>>(
      stream: _adminKunjunganPasienBloc.adminKunjunganPasienStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: kPrimaryColor,
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () {
                  _getAdminKunjungan();
                  setState(() {});
                },
              );
            case Status.completed:
              return ListView.separated(
                controller: controller,
                padding:
                    const EdgeInsets.symmetric(vertical: 22, horizontal: 12.0),
                itemBuilder: (context, i) {
                  if (i >= snapshot.data!.data!.data!.length) {
                    return const SizedBox(
                      height: 50,
                      child: Center(
                        child: SpinKitThreeBounce(
                          color: kPrimaryColor,
                          size: 20,
                        ),
                      ),
                    );
                  }
                  var kunjungan = snapshot.data!.data!.data![i];
                  StatusEnum status = _statusEnum
                      .where((status) => status.status == kunjungan.status)
                      .first;
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 18.0),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.grey,
                        child: const Icon(
                          Icons.person,
                          size: 28,
                        ),
                      ),
                      title: Text('${kunjungan.namaPasien}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${kunjungan.fullTanggal}'),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            '${status.message}',
                            style: TextStyle(color: status.color),
                          )
                        ],
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        onPressed: () => _batalKunjungan(kunjungan.id!),
                        icon: const FaIcon(FontAwesomeIcons.trashCan),
                        iconSize: 18,
                        color: kPrimaryColor,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, i) => const SizedBox(
                  height: 12.0,
                ),
                itemCount: snapshot.data!.data!.currentPage !=
                        snapshot.data!.data!.totalPage
                    ? snapshot.data!.data!.data!.length + 1
                    : snapshot.data!.data!.data!.length,
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _streamDeleteKunjunganAdmin(BuildContext context) {
    return StreamBuilder<ApiResponse<AdminKunjunganPasienDeleteModel>>(
        stream: _adminKunjunganPasienBloc.adminKunjunganStream,
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
                  onTap: () => Navigator.pop(context, 'success'),
                );
            }
          }
          return const SizedBox();
        });
  }
}

class StatusEnum {
  final int? status;
  final String? message;
  final Color? color;

  StatusEnum({
    this.status,
    this.message,
    this.color,
  });
}

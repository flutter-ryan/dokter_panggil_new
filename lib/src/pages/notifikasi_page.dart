import 'package:admin_dokter_panggil/src/blocs/notifikasi_admin_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/notifikasi_admin_save_bloc.dart';
import 'package:admin_dokter_panggil/src/models/notifikasi_admin_model.dart';
import 'package:admin_dokter_panggil/src/models/notifikasi_admin_save_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/close_button.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/header.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/detail_layanan_page.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({
    super.key,
    this.role,
  });

  final int? role;

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  final _notifikasiAdminBloc = NotifikasiAdminBloc();
  final _notifikasiAdminSaveBloc = NotifikasiAdminSaveBloc();
  bool _isStream = false;

  @override
  void initState() {
    super.initState();
    _notifikasiAdminBloc.getNotifikasi();
  }

  void _konfirmasi(NotifikasiAdmin? notifikasi) {
    _notifikasiAdminSaveBloc.idNotifikasiSink.add(notifikasi!.id!);
    _notifikasiAdminSaveBloc.updateNotifikasi();
    setState(() {
      _isStream = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _notifikasiAdminBloc.dispose();
    _notifikasiAdminSaveBloc.dispose();
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
              title: 'Pemberitahuan Masuk',
              closeButton: const ClosedButton(),
            ),
            Expanded(
              child: Stack(
                children: [
                  _buildStreamNotifikasiAdmin(context),
                  if (_isStream)
                    Container(
                        color: Colors.black54,
                        child: _buildStreamSaveNotifikasiAdmin(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamNotifikasiAdmin(BuildContext context) {
    return StreamBuilder<ApiResponse<NotifikasiAdminModel>>(
      stream: _notifikasiAdminBloc.notifikasiAdminStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingKit(
                color: kPrimaryColor,
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () {
                  _notifikasiAdminBloc.getNotifikasi();
                  setState(() {});
                },
              );
            case Status.completed:
              return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 22),
                  itemBuilder: (context, i) {
                    final data = snapshot.data!.data!.data![i];
                    return ListTile(
                      onTap: () => _konfirmasi(data),
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      title: Text('${data.body}'),
                      tileColor: data.isRead == 0 ? Colors.green[100] : null,
                      leading: CircleAvatar(
                        backgroundColor: kPrimaryColor.withValues(alpha: 0.1),
                        foregroundColor: kPrimaryColor,
                        child: Icon(Icons.campaign_rounded),
                      ),
                      subtitle: Text('${data.createdAt}'),
                    );
                  },
                  separatorBuilder: (context, i) => Divider(
                        height: 0,
                      ),
                  itemCount: snapshot.data!.data!.data!.length);
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildStreamSaveNotifikasiAdmin(
    BuildContext context,
  ) {
    return StreamBuilder<ApiResponse<NotifikasiAdminSaveModel>>(
      stream: _notifikasiAdminSaveBloc.notifikasiSaveStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Center(child: LoadingKit());
            case Status.error:
              return Center(
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () {
                    _isStream = false;
                  },
                ),
              );
            case Status.completed:
              final notifikasi = snapshot.data!.data!.data;
              Future.delayed(const Duration(milliseconds: 500), () {
                if (!mounted) return;
                Navigator.push(
                  context,
                  SlideLeftRoute(
                    page: DetailLayananPage(
                      id: notifikasi!.kunjunganId!,
                      type: notifikasi.finaltagihan == 0 ? 'create' : 'view',
                      role: widget.role,
                      notifikasi: notifikasi,
                    ),
                  ),
                ).then((value) {
                  _notifikasiAdminBloc.getNotifikasi();
                  setState(() {
                    _isStream = false;
                  });
                });
              });
              return SizedBox();
          }
        }
        return const SizedBox();
      },
    );
  }
}

import 'package:dokter_panggil/src/blocs/notifikasi_admin_bloc.dart';
import 'package:dokter_panggil/src/models/notifikasi_admin_model.dart';
import 'package:dokter_panggil/src/pages/components/close_button.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/header.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/pasien/detail_layanan_page.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/transition/slide_left_route.dart';
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

  @override
  void initState() {
    super.initState();
    _notifikasiAdminBloc.getNotifikasi();
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
            Expanded(child: _buildStreamNotifikasiAdmin(context)),
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
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 22),
                  itemBuilder: (context, i) {
                    final data = snapshot.data!.data!.data![i];
                    return ListTile(
                      onTap: () => Navigator.push(
                        context,
                        SlideLeftRoute(
                          page: DetailLayananPage(
                            id: data.kunjunganId!,
                            type: data.finaltagihan == 0 ? 'create' : 'view',
                            role: widget.role,
                          ),
                        ),
                      ),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      title: Text('${data.body}'),
                      leading: CircleAvatar(
                        backgroundColor: kPrimaryColor.withOpacity(0.1),
                        foregroundColor: kPrimaryColor,
                        child: Icon(Icons.campaign_rounded),
                      ),
                      subtitle: Text('${data.createdAt}'),
                      trailing: Icon(
                        Icons.circle_rounded,
                        color: Colors.red,
                        size: 12,
                      ),
                    );
                  },
                  separatorBuilder: (context, i) => Divider(
                        height: 18,
                      ),
                  itemCount: snapshot.data!.data!.data!.length);
          }
        }
        return const SizedBox();
      },
    );
  }
}

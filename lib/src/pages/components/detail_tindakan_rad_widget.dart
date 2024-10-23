import 'package:dokter_panggil/src/blocs/dokumen_pengantar_rad_bloc.dart';
import 'package:dokter_panggil/src/models/dokumen_pengantar_rad_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/pages/components/card_tagihan_lab.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

class DetailTindakanRadWidget extends StatefulWidget {
  const DetailTindakanRadWidget({
    super.key,
    required this.data,
    this.type = 'create',
    this.reload,
  });

  final DetailKunjungan data;
  final Function(DetailKunjungan data)? reload;
  final String type;

  @override
  State<DetailTindakanRadWidget> createState() =>
      _DetailTindakanRadWidgetState();
}

class _DetailTindakanRadWidgetState extends State<DetailTindakanRadWidget> {
  final _dokumenPengantarRadBloc = DokumenPengantarRadBloc();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  late DetailKunjungan _data;

  @override
  void initState() {
    super.initState();
    _loadTindakanRad();
  }

  void _loadTindakanRad() {
    _data = widget.data;
  }

  void _epengantar() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return _modalPilihPegawai(context);
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as int;
        _dokumenPengantarRadBloc.idPegawaiSink.add(data.toString());
        _dialogEpengantar();
      }
    });
  }

  void _dialogEpengantar() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda yakin mengirim pengantar radiologi ini?',
          onConfirm: () => Navigator.pop(context, 'kirim'),
          labelConfirm: 'Ya, Kirim',
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _dokumenPengantarRadBloc.idKunjunganSink.add(_data.id!);
        _dokumenPengantarRadBloc.getDokumenPengantarRad();
        _showStreamDokumenPengantarRad();
      }
    });
  }

  void _showStreamDokumenPengantarRad() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamDokumenPengantarRad(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as DokumenPengantarRad;
        _shareDokumenPengantarLab(data);
      }
    });
  }

  Future<void> _shareDokumenPengantarLab(DokumenPengantarRad data) async {
    await WhatsappShare.share(
      text:
          'Hai, ${data.pasien!.namaPasien}.\nDokumen ini adalah Pengantar Laboratorium',
      linkUrl: Uri.parse(data.linkDoc!).toString(),
      phone: '${data.pasien!.nomorTelepon}',
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dokumenPengantarRadBloc.dispose();
  }

  @override
  void didUpdateWidget(covariant DetailTindakanRadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _loadTindakanRad();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return CardTagihanLab(
      title: 'Tindakan Radiologi',
      buttonDetail: InkWell(
        onTap: _epengantar,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            'E-Pengantar',
            style: TextStyle(color: Colors.blue, fontSize: 12.0),
          ),
        ),
      ),
      tiles: Column(
        children: _data.tindakanRad!
            .map(
              (tindakanRad) => Column(
                children: [
                  ListTile(
                    dense: true,
                    horizontalTitleGap: 0,
                    contentPadding: EdgeInsets.zero,
                    title: Text('${tindakanRad.tindakanRad}'),
                    trailing: Text(
                      _rupiah.format(tindakanRad.tarif),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
      subTotal: Text(
        _rupiah.format(_data.totalTindakanRad! + _data.transportRad!),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _modalPilihPegawai(BuildContext context) {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Text(
              'Pengantar Radiologi',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            height: 0,
          ),
          Flexible(
            child: DefaultTabController(
              length: _data.pegawai!.length,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Colors.black,
                    isScrollable: true,
                    unselectedLabelColor: Colors.grey[400],
                    indicatorColor: kPrimaryColor,
                    tabs: _data.pegawai!
                        .map(
                          (pegawai) => Tab(
                            text: '${pegawai.nama}',
                          ),
                        )
                        .toList(),
                  ),
                  const Divider(
                    height: 0,
                  ),
                  Flexible(
                    child: TabBarView(
                      children: _data.pegawai!
                          .map(
                            (pegawai) => ListTindakanPengantarRad(
                              idKunjungan: _data.id!,
                              idPegawai: pegawai.id!,
                            ),
                          )
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _streamDokumenPengantarRad(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseDokumenPengantarRadModel>>(
      stream: _dokumenPengantarRadBloc.dokumenPengantarRadStream,
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
                onTap: () => Navigator.pop(context, snapshot.data!.data!.data),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListTindakanPengantarRad extends StatefulWidget {
  const ListTindakanPengantarRad({
    super.key,
    required this.idKunjungan,
    required this.idPegawai,
  });

  final int idKunjungan;
  final int idPegawai;

  @override
  State<ListTindakanPengantarRad> createState() =>
      _ListTindakanPengantarRadState();
}

class _ListTindakanPengantarRadState extends State<ListTindakanPengantarRad> {
  final _dokumenPengantarRadBloc = DokumenPengantarRadBloc();

  @override
  void initState() {
    super.initState();
    _getListTindakanRad();
  }

  void _getListTindakanRad() {
    _dokumenPengantarRadBloc.idKunjunganSink.add(widget.idKunjungan);
    _dokumenPengantarRadBloc.idPegawaiSink.add(widget.idPegawai.toString());
    _dokumenPengantarRadBloc.getListTindakanRad();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseListTindakanRadPengantarModel>>(
      stream: _dokumenPengantarRadBloc.listTindakanRadStream,
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
                  _getListTindakanRad();
                  setState(() {});
                },
              );
            case Status.completed:
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      itemCount: snapshot.data!.data!.data!.length,
                      itemBuilder: (context, i) {
                        var tindakan = snapshot.data!.data!.data![i];
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 22.0),
                          title: Text('${tindakan.tindakan}'),
                        );
                      },
                      separatorBuilder: (context, i) => const Divider(
                        height: 0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, widget.idPegawai),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      child: const Text('Kirim E-pengantar'),
                    ),
                  ),
                ],
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

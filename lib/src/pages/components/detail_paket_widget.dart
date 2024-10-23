import 'package:dokter_panggil/src/blocs/kunjungan_paket_delete_bloc.dart';
import 'package:dokter_panggil/src/blocs/kunjungan_paket_update_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_paket_create_bloc.dart';
import 'package:dokter_panggil/src/models/kunjungan_paket_update_model.dart';
import 'package:dokter_panggil/src/models/master_paket_create_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/pages/components/card_paket.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/detail_tagihan.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DetailPaketWidget extends StatefulWidget {
  const DetailPaketWidget({
    super.key,
    required this.data,
    this.type = 'create',
    this.reload,
  });

  final DetailKunjungan data;
  final Function(DetailKunjungan? data)? reload;
  final String type;

  @override
  State<DetailPaketWidget> createState() => _DetailPaketWidgetState();
}

class _DetailPaketWidgetState extends State<DetailPaketWidget> {
  final _filter = TextEditingController();
  final _masterPaketCreateBloc = MasterPaketCreateBloc();
  final _kunjunganPaketUpdateBloc = KunjunganPaketUpdateBloc();
  final _kunjunganPaketDeleteBloc = KunjunganPaketDeleteBloc();
  final _rupiah =
      NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp. ');

  @override
  void initState() {
    super.initState();
    _filter.addListener(_listenFilter);
  }

  void _editPaket() {
    showBarModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return _selectEditPaket(context);
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var type = value as String;
        if (type == 'update') {
          _updatePaket('update');
        } else {
          _showConfirmationPaket();
        }
      }
    });
  }

  void _showConfirmationPaket() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda yakin ingin menghapus data paket ini?',
          onConfirm: () => Navigator.pop(context, 'hapus'),
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _kunjunganPaketDeleteBloc.idKunjunganSink.add(widget.data.id!);
        _kunjunganPaketDeleteBloc.deleteKunjunganPaket();
        _showStreamDeletePaket();
      }
    });
  }

  void _updatePaket(String? type) {
    _masterPaketCreateBloc.getMasterPaket();
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            minHeight: SizeConfig.blockSizeVertical * 40,
            maxHeight: SizeConfig.blockSizeVertical * 90,
          ),
          child: _streamMasterPaketWidget(context),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as MasterPaket;
        Future.delayed(const Duration(milliseconds: 300), () {
          _showConfirmationDialog(data, type);
        });
      }
    });
  }

  void _showConfirmationDialog(MasterPaket data, type) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda yakin memperbaharui paket ini?',
          labelConfirm: 'Ya, Perbarui',
          onConfirm: () => Navigator.pop(context, 'confirm'),
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _kunjunganPaketUpdateBloc.idKunjunganSink.add(widget.data.id!);
        _kunjunganPaketUpdateBloc.idPaketSink.add(data.id!);
        if (type == 'store') {
          _kunjunganPaketUpdateBloc.storekunjunganPaket();
        } else {
          _kunjunganPaketUpdateBloc.updateKunjunganPaket();
        }
        _showStreamUpdatePaket();
      }
    });
  }

  void _showStreamUpdatePaket() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamUpdatePaketWidget(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromTopFade,
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        widget.reload!(data);
      }
    });
  }

  void _showStreamDeletePaket() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamDeletePaketWidget(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromTopFade,
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        widget.reload!(data);
      }
    });
  }

  void _listenFilter() {
    //
  }

  @override
  void dispose() {
    _filter.dispose();
    _filter.removeListener(_listenFilter);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return CardPaket(
      title: 'Paket',
      buttonDetail: widget.type != 'view' && widget.data.paket == null
          ? Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.transparent,
                foregroundColor: kPrimaryColor,
                child: IconButton(
                  onPressed: () => _updatePaket('store'),
                  icon: const Icon(Icons.add),
                  padding: EdgeInsets.zero,
                  iconSize: 22,
                ),
              ),
            )
          : null,
      tiles: [
        const SizedBox(
          height: 12.0,
        ),
        if (widget.data.paket != null)
          Detailtagihan(
            onTap: widget.type != 'view' ? () => _editPaket() : null,
            namaTagihan: Row(
              children: [
                Flexible(child: Text('${widget.data.paket!.paket!.namaPaket}')),
                const SizedBox(
                  width: 12.0,
                ),
                if (widget.type != 'view')
                  const Icon(
                    Icons.edit_note_rounded,
                    size: 22.0,
                    color: Colors.blue,
                  )
              ],
            ),
            tarifTagihan: Text(
              _rupiah.format(widget.data.paket!.harga),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
              child: Text(
                'Data tidak tersedia',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _streamMasterPaketWidget(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseMasterPaketCreateModel>>(
      stream: _masterPaketCreateBloc.masterPaketCreateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingKit(
                    color: kPrimaryColor,
                  ),
                ],
              );
            case Status.error:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ErrorResponse(
                      message: snapshot.data!.message,
                      onTap: () {},
                    ),
                  ],
                ),
              );
            case Status.completed:
              return MasterPaketWidget(
                data: snapshot.data!.data!.data,
                controller: _filter,
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _streamUpdatePaketWidget(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseKunjunganPaketUpdateModel>>(
      stream: _kunjunganPaketUpdateBloc.kunjunganPaketUpdateStream,
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

  Widget _streamDeletePaketWidget(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseKunjunganPaketUpdateModel>>(
      stream: _kunjunganPaketDeleteBloc.kunjunganPaketDeleteStream,
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

  Widget _selectEditPaket(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 22.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pilih Aksi',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: Colors.grey,
                )
              ],
            ),
          ),
          ListTile(
            onTap: () => Navigator.pop(context, 'update'),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 4),
            leading: const Icon(Icons.edit),
            title: const Text('Edit Paket'),
          ),
          const Divider(
            height: 0,
          ),
          ListTile(
            onTap: () => Navigator.pop(context, 'hapus'),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 4),
            leading: const Icon(Icons.delete),
            title: const Text('Hapus paket'),
          )
        ],
      ),
    );
  }
}

class MasterPaketWidget extends StatefulWidget {
  const MasterPaketWidget({
    super.key,
    this.data,
    this.controller,
  });

  final List<MasterPaket>? data;
  final TextEditingController? controller;

  @override
  State<MasterPaketWidget> createState() => _MasterPaketWidgetState();
}

class _MasterPaketWidgetState extends State<MasterPaketWidget> {
  List<MasterPaket> _data = [];

  @override
  void initState() {
    super.initState();
    _data = widget.data!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(22.0),
          child: Text(
            'Master Paket',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Flexible(
          child: ListView.builder(
            padding: const EdgeInsets.all(12.0),
            shrinkWrap: true,
            itemBuilder: (context, i) {
              var paket = _data[i];
              return ListTile(
                onTap: () => Navigator.pop(context, paket),
                title: Text('${paket.namaPaket}'),
              );
            },
            itemCount: _data.length,
          ),
        )
      ],
    );
  }
}

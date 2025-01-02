import 'package:dokter_panggil/src/blocs/delete_tagihan_bhp_bloc.dart';
import 'package:dokter_panggil/src/blocs/update_kunjungan_bhp_tagihan_bloc.dart';
import 'package:dokter_panggil/src/models/delete_tagihan_resep_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/models/update_kunjungan_resep_tagihan_model.dart';
import 'package:dokter_panggil/src/pages/components/card_tagihan_bhp.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/components/transaksi_bhp.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/transition/slide_bottom_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DetailTagihanBhpWidget extends StatefulWidget {
  const DetailTagihanBhpWidget({
    super.key,
    required this.data,
    this.type = 'create',
    this.reload,
  });

  final DetailKunjungan data;
  final Function(DetailKunjungan data)? reload;
  final String type;

  @override
  State<DetailTagihanBhpWidget> createState() => _DetailTagihanBhpWidgetState();
}

class _DetailTagihanBhpWidgetState extends State<DetailTagihanBhpWidget> {
  final _updateTagihanBhpBloc = UpdateKunjunganBhpTagihanBloc();
  final _deleteTagihanBhpBloc = DeleteTagihanBhpBloc();
  final NumberFormat _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  final _rupiahNo =
      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0);
  final _formKey = GlobalKey<FormState>();
  final _jumlah = TextEditingController();
  late DetailKunjungan _data;

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _loadDataBhp();
  }

  void _loadDataBhp() {
    _data = widget.data;
  }

  void _edit(BuildContext context, TagihanBhp data) {
    _jumlah.text = '${data.jumlah}';
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return _formUpdateTagihan(context, data.id);
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        widget.reload!(data);
      }
    });
  }

  void _update(int? id) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).unfocus();
    if (validateAndSave()) {
      _updateTagihanBhpBloc.idSink.add(id!);
      _updateTagihanBhpBloc.jumlahSink.add(int.parse(_jumlah.text));
      _updateTagihanBhpBloc.updateTagihanBhp();
      _showStreamUpdate();
    }
  }

  void _showStreamUpdate() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamUpdateTagihan(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      var data = value as DetailKunjungan;
      if (!mounted) return;
      Navigator.pop(context, data);
    });
  }

  void _hapus(BuildContext context, int? id) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda yakin menghapus data ini?',
          onConfirm: () => Navigator.pop(context, id),
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var id = value as int;
        _deleteTagihanBhpBloc.idSink.add(id);
        _deleteTagihanBhpBloc.deleteTagihanBhp();
        _showStreamDelete();
      }
    });
  }

  void _showStreamDelete() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamDeleteTagihanBhp(context);
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

  void _detail() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return _showDetailBhp(context);
      },
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didUpdateWidget(covariant DetailTagihanBhpWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _loadDataBhp();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _updateTagihanBhpBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CardTagihanBhp(
      title: 'Barang habis pakai',
      tiles: Column(
        children: [
          if (_data.bhp!.isEmpty)
            SizedBox(
              width: double.infinity,
              height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: kPrimaryColor,
                    size: 52,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  const Text(
                    'Data tagihan bhp tidak tersedia',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  if (widget.type == 'create')
                    const SizedBox(
                      height: 18.0,
                    ),
                  if (widget.type == 'create')
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        SlideBottomRoute(
                          page: TransaksiBhp(
                            idKunjungan: _data.id!,
                            dataBhp: _data.bhp!,
                          ),
                        ),
                      ).then((value) {
                        if (value != null) {
                          var data = value as DetailKunjungan;
                          widget.reload!(data);
                        }
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                      ),
                      child: const Text('Transaksi Barang Habis Pakai'),
                    )
                ],
              ),
            ),
          if (_data.tagihanBhp!.isNotEmpty && widget.type == 'create')
            Container(
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(20),
                border: Border.all(color: Colors.green, width: 0.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                onTap: () => Navigator.push(
                  context,
                  SlideBottomRoute(
                    page: TransaksiBhp(
                      idKunjungan: _data.id!,
                      dataBhp: _data.bhp!,
                    ),
                  ),
                ).then((value) {
                  if (value != null) {
                    var data = value as DetailKunjungan;
                    widget.reload!(data);
                  }
                }),
                dense: true,
                title: Text(
                  'Tambah Barang/Obat',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey,
                ),
              ),
            ),
          const SizedBox(
            height: 12,
          ),
          if (_data.tagihanBhp!.isNotEmpty)
            Column(
              children: ListTile.divideTiles(
                context: context,
                tiles: _data.tagihanBhp!
                    .map(
                      (tagihanBhp) => Slidable(
                        key: Key(tagihanBhp.id.toString()),
                        enabled: widget.type == 'create' ? true : false,
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          dragDismissible: false,
                          children: [
                            SlidableAction(
                              onPressed: (context) =>
                                  _edit(context, tagihanBhp),
                              backgroundColor: const Color(0xFF21B7CA),
                              foregroundColor: Colors.white,
                              icon: Icons.edit_rounded,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              onPressed: (context) =>
                                  _hapus(context, tagihanBhp.id),
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          horizontalTitleGap: 0,
                          title: Text('${tagihanBhp.namaBarang}'),
                          subtitle: Text(
                              '${tagihanBhp.jumlah} x ${_rupiahNo.format(tagihanBhp.hargaModal! + tagihanBhp.tarifAplikasi!)}'),
                          trailing: Text(
                            _rupiah.format(tagihanBhp.total),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ).toList(),
            ),
        ],
      ),
      buttonDetail: InkWell(
        onTap: _detail,
        child: const Text(
          'Detail',
          style: TextStyle(color: Colors.blue, fontSize: 12.0),
        ),
      ),
      subTotal: Text(
        _rupiah.format(widget.data.totalBhp),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _showDetailBhp(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(22.0),
          child: Text(
            'List barang habis pakai',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
        Flexible(
          child: ListView.separated(
            shrinkWrap: true,
            padding:
                const EdgeInsets.only(left: 22.0, right: 22.0, bottom: 32.0),
            itemBuilder: (context, i) {
              var data = _data.bhp![i];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${data.barang}'),
                trailing: Text(
                  '${data.jumlah} buah',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              );
            },
            separatorBuilder: (context, i) => const SizedBox(
              height: 18.0,
            ),
            itemCount: _data.bhp!.length,
          ),
        ),
      ],
    );
  }

  Widget _formUpdateTagihan(BuildContext context, int? id) {
    return Padding(
      padding: EdgeInsets.only(
        top: 32.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32.0,
        left: 18.0,
        right: 18.0,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Jumlah Barang/Obat',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 0.0,
            ),
            Input(
              controller: _jumlah,
              label: '',
              hint: 'Ketikkan jumlah barang/obat',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
              keyType: TextInputType.number,
            ),
            const SizedBox(
              height: 32.0,
            ),
            ElevatedButton(
              onPressed: () => _update(id),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 47)),
              child: const Text('Update'),
            )
          ],
        ),
      ),
    );
  }

  Widget _streamUpdateTagihan(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseUpdateKunjunganResepTagihanModel>>(
      stream: _updateTagihanBhpBloc.updateTagihanBhpStream,
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

  Widget _streamDeleteTagihanBhp(BuildContext context) {
    return StreamBuilder<ApiResponse<DeleteTagihanResepModel>>(
      stream: _deleteTagihanBhpBloc.deleteTagihanBhpStream,
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

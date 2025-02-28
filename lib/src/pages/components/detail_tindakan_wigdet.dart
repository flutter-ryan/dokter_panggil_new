import 'package:dokter_panggil/src/blocs/kunjungan_tindakan_update_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_transportasi_tindakan_bloc.dart';
import 'package:dokter_panggil/src/blocs/ojol_tindakan_bloc.dart';
import 'package:dokter_panggil/src/blocs/transportasi_tindakan_bloc.dart';
import 'package:dokter_panggil/src/models/kunjungan_tindakan_update_model.dart';
import 'package:dokter_panggil/src/models/master_transportasi_tindakan_model.dart';
import 'package:dokter_panggil/src/models/ojol_tindakan_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/models/transportasi_tindakan_model.dart';
import 'package:dokter_panggil/src/pages/components/card_tagihan.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/detail_tagihan.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/detail_card_tagihan.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:dokter_panggil/src/pages/components/badge.dart' as badge_custom;

class DetailTindakanWidget extends StatefulWidget {
  const DetailTindakanWidget({
    super.key,
    required this.data,
    this.subtotal,
    this.reload,
    this.type = 'create',
    this.role,
  });

  final DetailKunjungan data;
  final Widget? subtotal;
  final Function(DetailKunjungan? data)? reload;
  final String type;
  final int? role;

  @override
  State<DetailTindakanWidget> createState() => _DetailTindakanWidgetState();
}

class _DetailTindakanWidgetState extends State<DetailTindakanWidget> {
  final _kunjunganTindakanUpdateBloc = KunjunganTindakanUpdateBloc();
  final _masterTransportasiTindakanBloc = MasterTransportasiTindakanBloc();
  final NumberFormat _rupiah =
      NumberFormat.currency(symbol: 'Rp. ', locale: 'id', decimalDigits: 0);
  final _qty = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      return true;
    }
    return false;
  }

  void _tambahTransport(Tindakan data) {
    _masterTransportasiTindakanBloc.getTransportasiTindakan();
    showBarModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: _streamMasterTransportasiTindakan(context, data),
          );
        }).then(
      (value) {
        if (value != null) {
          var data = value as DetailKunjungan;
          widget.reload!(data);
        }
        if (!mounted) return;
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  void _tambahOjol(Tindakan data) {
    _masterTransportasiTindakanBloc.getTransportasiTindakan();
    showBarModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            constraints: BoxConstraints(
              minHeight: SizeConfig.blockSizeVertical * 20,
              maxHeight: SizeConfig.blockSizeVertical * 80,
            ),
            padding: EdgeInsets.only(
              top: 32.0,
              left: 32.0,
              right: 32.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 32,
            ),
            child: FormOjol(
              data: data,
              id: widget.data.id!,
            ),
          );
        }).then(
      (value) {
        if (value != null) {
          var data = value as DetailKunjungan;
          widget.reload!(data);
        }
        if (!mounted) return;
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  void _editQty(Tindakan? data) {
    _qty.text = '${data!.quantity}';
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _formQuantityTindakan(context, data),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        widget.reload!(data);
      }
    });
  }

  void _simpan(Tindakan? data) {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(FocusNode());
      _kunjunganTindakanUpdateBloc.idSink.add(data!.id!);
      _kunjunganTindakanUpdateBloc.quantitySink.add(int.parse(_qty.text));
      _kunjunganTindakanUpdateBloc.updateKunjunganTindakan();
      _showStreamUpdateTindakan();
    }
  }

  void _showStreamUpdateTindakan() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamUpdateTindakan(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        Future.delayed(
          const Duration(milliseconds: 600),
          () {
            if (!mounted) return;
            Navigator.pop(context, data);
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _masterTransportasiTindakanBloc.dispose();
    _kunjunganTindakanUpdateBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmr == 0) {
      return _oldCardTagihan(context);
    }
    return Cardtagihan(
      title: 'Tindakan',
      tiles: widget.data.tindakan!
          .map(
            (tindakan) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  DetailCardTagihan(
                    tanggal: '${tindakan.createdAt}\n${tindakan.jamAt}',
                    deskripsi: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${tindakan.namaTindakan}',
                          style: TextStyle(fontSize: 12),
                        ),
                        if (tindakan.foc == 1)
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: badge_custom.Badge(
                                color: Colors.green,
                                label: 'FOC',
                              )),
                      ],
                    ),
                    petugas: '${tindakan.petugas}',
                    tarif: _rupiah.format(tindakan.tarif),
                  ),
                  if (tindakan.transportasi == 1)
                    TileTransportTindakan(
                      onTap: widget.type != 'view'
                          ? () => _tambahTransport(tindakan)
                          : null,
                      title: Row(
                        children: [
                          const Text(
                            'Transportasi',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          if (widget.type != 'view')
                            const Icon(
                              Icons.edit_note_rounded,
                              size: 22.0,
                              color: Colors.blue,
                            )
                        ],
                      ),
                      trailing: Text(
                        _rupiah.format(tindakan.dataTransportasi != null
                            ? tindakan.dataTransportasi!.biaya
                            : 0),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  if (tindakan.gojek == 1)
                    TileTransportTindakan(
                      onTap: widget.type != 'view'
                          ? () => _tambahOjol(tindakan)
                          : null,
                      leading: const Icon(
                        Icons.keyboard_arrow_right,
                        size: 20.0,
                      ),
                      title: Row(
                        children: [
                          const Text(
                            'Transportasi Online',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          if (widget.type != 'view')
                            const Icon(
                              Icons.edit_note_rounded,
                              size: 22.0,
                              color: Colors.blue,
                            )
                        ],
                      ),
                      trailing: Text(
                        _rupiah.format(tindakan.dataOjol != null
                            ? tindakan.dataOjol!.total
                            : 0),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          )
          .toList(),
      subTotal: widget.subtotal,
    );
  }

  Widget _streamMasterTransportasiTindakan(
      BuildContext context, Tindakan data) {
    return StreamBuilder<ApiResponse<MasterTransportasiTindakanModel>>(
      stream: _masterTransportasiTindakanBloc.transportasiTindakanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 200,
                child: Center(
                  child: LoadingKit(
                    color: kPrimaryColor,
                  ),
                ),
              );
            case Status.error:
              return SizedBox(
                height: 350,
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () => Navigator.pop(context),
                ),
              );
            case Status.completed:
              return FormTransportasi(
                id: widget.data.id!,
                data: data,
                transportasi: snapshot.data!.data!.data!,
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _formQuantityTindakan(BuildContext context, Tindakan? data) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Input quantity tindakan',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 32.0,
            ),
            Input(
              controller: _qty,
              label: 'Quantity',
              hint: 'Input quantity tindakan',
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
              onPressed: () => _simpan(data),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }

  Widget _streamUpdateTindakan(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseKunjunganTindakanUpdateModel>>(
      stream: _kunjunganTindakanUpdateBloc.kunjunganTindakanUpdateStream,
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

  Widget _oldCardTagihan(BuildContext context) {
    return Cardtagihan(
      title: 'Tindakan',
      tiles: widget.data.tindakan!
          .map(
            (tindakan) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Detailtagihan(
                  onTap: widget.type != 'view' && widget.role == 99
                      ? () => _editQty(tindakan)
                      : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  namaTagihan: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(child: Text('${tindakan.namaTindakan}')),
                      if (widget.type != 'view' && widget.role == 99)
                        const SizedBox(
                          width: 12.0,
                        ),
                      if (widget.type != 'view' && widget.role == 99)
                        const Icon(
                          Icons.edit_note_rounded,
                          size: 22.0,
                          color: Colors.blue,
                        )
                    ],
                  ),
                  subTagihan: tindakan.foc == 1
                      ? const Align(
                          alignment: Alignment.centerLeft,
                          child: badge_custom.Badge(
                            color: Colors.green,
                            label: 'Free of Charge',
                          ))
                      : null,
                  tarifTagihan: Text(
                    _rupiah.format(tindakan.tarif),
                  ),
                ),
                if (tindakan.transportasi == 1)
                  TileTransportTindakan(
                    onTap: widget.type != 'view'
                        ? () => _tambahTransport(tindakan)
                        : null,
                    title: Row(
                      children: [
                        const Text('Transportasi'),
                        const SizedBox(
                          width: 8,
                        ),
                        if (widget.type != 'view')
                          const Icon(
                            Icons.edit_note_rounded,
                            size: 22.0,
                            color: Colors.blue,
                          )
                      ],
                    ),
                    leading: const Icon(
                      Icons.keyboard_arrow_right,
                      size: 20.0,
                    ),
                    trailing: Text(
                      _rupiah.format(tindakan.dataTransportasi != null
                          ? tindakan.dataTransportasi!.biaya
                          : 0),
                    ),
                  ),
                if (tindakan.gojek == 1)
                  TileTransportTindakan(
                    onTap: widget.type != 'view'
                        ? () => _tambahOjol(tindakan)
                        : null,
                    leading: const Icon(
                      Icons.keyboard_arrow_right,
                      size: 20.0,
                    ),
                    title: Row(
                      children: [
                        const Text('Transportasi Online'),
                        const SizedBox(
                          width: 8,
                        ),
                        if (widget.type != 'view')
                          const Icon(
                            Icons.edit_note_rounded,
                            size: 22.0,
                            color: Colors.blue,
                          )
                      ],
                    ),
                    trailing: Text(
                      _rupiah.format(tindakan.dataOjol != null
                          ? tindakan.dataOjol!.total
                          : 0),
                    ),
                  )
              ],
            ),
          )
          .toList(),
      subTotal: widget.subtotal,
    );
  }
}

class FormOjol extends StatefulWidget {
  const FormOjol({
    super.key,
    required this.id,
    required this.data,
  });

  final int id;
  final Tindakan data;

  @override
  State<FormOjol> createState() => _FormOjolState();
}

class _FormOjolState extends State<FormOjol> {
  final _ojolTindakanBloc = OjolTindakanBloc();
  final _formKey = GlobalKey<FormState>();
  final _biaya = TextEditingController();
  final _persen = TextEditingController();

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      return true;
    }
    return false;
  }

  void _simpan() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus();
      _ojolTindakanBloc.idSink.add(widget.id);
      _ojolTindakanBloc.tindakanKunjunganSink.add(widget.data.id!);
      _ojolTindakanBloc.biayaSink.add(int.parse(_biaya.text));
      _ojolTindakanBloc.persenSink.add(int.parse(_persen.text));
      _ojolTindakanBloc.simpanOjolTindakan();
      _showStreamOjolTindakan();
    }
  }

  void _showStreamOjolTindakan() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamOjolTindakan(context);
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          Navigator.pop(context, data);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Transportasi Online ${widget.data.namaTindakan}',
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 32.0,
          ),
          Input(
            controller: _biaya,
            label: 'Biaya',
            hint: 'Input biaya ojek online',
            maxLines: 1,
            validator: (val) {
              if (val!.isEmpty) {
                return 'Input required';
              }
              return null;
            },
            keyType: TextInputType.number,
          ),
          const SizedBox(
            height: 22.0,
          ),
          Input(
            controller: _persen,
            label: 'Persen',
            hint: 'Input persen kenaikan ojek online',
            maxLines: 1,
            validator: (val) {
              if (val!.isEmpty) {
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
            onPressed: _simpan,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Simpan'),
          )
        ],
      ),
    );
  }

  Widget _streamOjolTindakan(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseOjolTindakanModel>>(
      stream: _ojolTindakanBloc.ojolTindakanStream,
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

class FormTransportasi extends StatefulWidget {
  const FormTransportasi({
    super.key,
    required this.id,
    required this.data,
    required this.transportasi,
  });

  final int id;
  final Tindakan data;
  final List<TransportasiTindakan> transportasi;

  @override
  State<FormTransportasi> createState() => _FormTransportasiState();
}

class _FormTransportasiState extends State<FormTransportasi> {
  final _transportasiTindakanBloc = TransportasiTindakanBloc();
  final _jarak = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final NumberFormat _rupiah =
      NumberFormat.currency(symbol: 'Rp. ', locale: 'id', decimalDigits: 0);
  int? _selectedTransport;
  int _nilaiTransportasi = 0;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    if (widget.data.dataTransportasi != null) {
      _selectedTransport = widget.data.dataTransportasi!.id;
      _jarak.text = '${widget.data.dataTransportasi!.jarak}';
    }
  }

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _simpan() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus();
      if (_selectedTransport == null) {
        setState(() {
          _isError = true;
        });
        return;
      }
      _transportasiTindakanBloc.idSink.add(widget.id);
      _transportasiTindakanBloc.tindakanKunjunganSink.add(widget.data.id!);
      _transportasiTindakanBloc.jarakSink.add(int.parse(_jarak.text));
      _transportasiTindakanBloc.nilaiSink.add(_nilaiTransportasi);
      _transportasiTindakanBloc.simpanTransportasiTindakan();
      _showStreamTransportasiTindakan();
    }
  }

  void _showStreamTransportasiTindakan() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamTransportasiTindakan();
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          Navigator.pop(context, data);
        });
      }
    });
  }

  void _hapus() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          onConfirm: () => Navigator.pop(context, 'confirm'),
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _transportasiTindakanBloc.idTransportTindakan
            .add(widget.data.dataTransportasi!.id!);
        _transportasiTindakanBloc.deleteTransportasiTindakan();
        _showStreamTransportasiTindakan();
      }
    });
  }

  @override
  void dispose() {
    _transportasiTindakanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Transportasi ${widget.data.namaTindakan}',
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 32.0,
            ),
            Input(
              controller: _jarak,
              label: 'Jarak',
              hint: 'Input jarak lokasi pasien',
              maxLines: 1,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
              keyType: TextInputType.number,
            ),
            const SizedBox(
              height: 22.0,
            ),
            const Text(
              'Jenis Transportasi',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.transportasi.map((e) {
                return RadioListTile<int?>(
                  contentPadding: EdgeInsets.zero,
                  value: e.id,
                  groupValue: _selectedTransport,
                  activeColor: kPrimaryColor,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedTransport = value;
                      _nilaiTransportasi = e.nilai!;
                      _isError = false;
                    });
                  },
                  title: Text('${e.deskripsi} (${_rupiah.format(e.nilai)})'),
                );
              }).toList(),
            ),
            if (_isError)
              const Text(
                'Pilih sala satu',
                style: TextStyle(fontSize: 12.0, color: Colors.red),
              ),
            const SizedBox(
              height: 32.0,
            ),
            Row(
              children: [
                if (widget.data.dataTransportasi != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _hapus,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text('Hapus'),
                    ),
                  ),
                if (widget.data.dataTransportasi != null)
                  const SizedBox(
                    width: 18.0,
                  ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _simpan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Simpan'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _streamTransportasiTindakan() {
    return StreamBuilder<ApiResponse<ResponseTransportasiTindakanModel>>(
      stream: _transportasiTindakanBloc.transportasiTindakanStream,
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

class TileTransportTindakan extends StatelessWidget {
  const TileTransportTindakan({
    super.key,
    this.onTap,
    this.title,
    this.trailing,
    this.leading,
  });

  final VoidCallback? onTap;
  final Widget? title;
  final Widget? trailing;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      horizontalTitleGap: 0.0,
      minLeadingWidth: 25.0,
      contentPadding: EdgeInsets.zero,
      style: ListTileStyle.list,
      titleTextStyle:
          TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
      visualDensity: VisualDensity.compact,
      title: title,
      trailing: trailing,
    );
  }
}

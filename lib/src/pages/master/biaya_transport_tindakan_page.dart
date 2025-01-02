import 'package:dokter_panggil/src/blocs/biaya_transportasi_tindakan_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_transportasi_tindakan_bloc.dart';
import 'package:dokter_panggil/src/models/biaya_transportasi_tindakan_model.dart';
import 'package:dokter_panggil/src/models/master_transportasi_tindakan_model.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class BiayaTransportTindakanPage extends StatefulWidget {
  const BiayaTransportTindakanPage({super.key});

  @override
  State<BiayaTransportTindakanPage> createState() =>
      _BiayaTransportTindakanPageState();
}

class _BiayaTransportTindakanPageState
    extends State<BiayaTransportTindakanPage> {
  final _masterTransportasiTindakanBloc = MasterTransportasiTindakanBloc();

  @override
  void initState() {
    super.initState();
    _masterTransportasiTindakanBloc.getTransportasiTindakan();
  }

  @override
  void dispose() {
    _masterTransportasiTindakanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Transportasi Tindakan'),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: _streamTransportasiTindakan(context),
    );
  }

  Widget _streamTransportasiTindakan(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterTransportasiTindakanModel>>(
      stream: _masterTransportasiTindakanBloc.transportasiTindakanStream,
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
                  _masterTransportasiTindakanBloc.getTransportasiTindakan();
                  setState(() {});
                },
              );
            case Status.completed:
              return ListTranportasiTindakanWidget(
                  data: snapshot.data!.data!.data!);
          }
        }
        return const SizedBox();
      },
    );
  }
}

class FormTransportasiTindakan extends StatefulWidget {
  const FormTransportasiTindakan({
    super.key,
    this.data,
  });

  final TransportasiTindakan? data;

  @override
  State<FormTransportasiTindakan> createState() =>
      _FormTransportasiTindakanState();
}

class _FormTransportasiTindakanState extends State<FormTransportasiTindakan> {
  final _biayaTransportasiTindakanBloc = BiayaTransportasiTindakanBloc();
  final _formKey = GlobalKey<FormState>();
  final _jenis = TextEditingController();
  final _biaya = TextEditingController();

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _jenis.text = widget.data!.deskripsi!;
      _biaya.text = widget.data!.nilai.toString();
    }
  }

  void _simpan() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(FocusNode());
      _biayaTransportasiTindakanBloc.jenisSink.add(_jenis.text);
      _biayaTransportasiTindakanBloc.biayaSink.add(int.parse(_biaya.text));
      _biayaTransportasiTindakanBloc.saveTransportasiTindakan();
      _showStreamTransportasiTindakan('create');
    }
  }

  void _update() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(FocusNode());
      _biayaTransportasiTindakanBloc.idSink.add(widget.data!.id!);
      _biayaTransportasiTindakanBloc.biayaSink.add(int.parse(_biaya.text));
      _biayaTransportasiTindakanBloc.jenisSink.add(_jenis.text);
      _biayaTransportasiTindakanBloc.updateTransportasiTindakan();
      _showStreamTransportasiTindakan('update');
    }
  }

  void _hapus() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).requestFocus(FocusNode());
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda yakin menghapus data ini?',
          onConfirm: () => Navigator.pop(context, 'hapus'),
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _biayaTransportasiTindakanBloc.idSink.add(widget.data!.id!);
        _biayaTransportasiTindakanBloc.deleteTransportasiTindakan();
        _showStreamTransportasiTindakan('hapus');
      }
    });
  }

  void _showStreamTransportasiTindakan(String type) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamTransportasiTindakan(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as TransportasiTindakan;
        BiayaTransportTindakanMod biayaMod = BiayaTransportTindakanMod(
          type: type,
          data: data,
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          Navigator.pop(context, biayaMod);
        });
      }
    });
  }

  @override
  void dispose() {
    _biayaTransportasiTindakanBloc.dispose();
    _biaya.dispose();
    _jenis.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Biaya Transportasi Tindakan',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 32.0,
            ),
            Input(
              controller: _jenis,
              label: 'Jenis',
              hint: 'Inputkan jenis transportasi',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              textCap: TextCapitalization.words,
            ),
            const SizedBox(
              height: 22.0,
            ),
            Input(
              controller: _biaya,
              label: 'Biaya',
              hint: 'Inputkan nilai transportasi',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
              keyType: TextInputType.number,
            ),
            const SizedBox(
              height: 42.0,
            ),
            if (widget.data == null)
              ElevatedButton(
                onPressed: _simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  minimumSize: const Size(double.infinity, 45.0),
                ),
                child: const Text('SIMPAN'),
              )
            else
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: _hapus,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: kPrimaryColor,
                        minimumSize: const Size.fromHeight(45),
                      ),
                      child: const Icon(Icons.delete_rounded),
                    ),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    flex: 4,
                    child: ElevatedButton(
                      onPressed: _update,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        minimumSize: const Size.fromHeight(45),
                      ),
                      child: const Text('UPDATE'),
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _streamTransportasiTindakan(BuildContext context) {
    return StreamBuilder<ApiResponse<BiayaTransportasiTindakanModel>>(
      stream: _biayaTransportasiTindakanBloc.biayaTransportasiTindakanStream,
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

class ListTranportasiTindakanWidget extends StatefulWidget {
  const ListTranportasiTindakanWidget({
    super.key,
    this.data,
  });

  final List<TransportasiTindakan>? data;

  @override
  State<ListTranportasiTindakanWidget> createState() =>
      _ListTranportasiTindakanWidgetState();
}

class _ListTranportasiTindakanWidgetState
    extends State<ListTranportasiTindakanWidget> {
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  List<TransportasiTindakan> _data = [];

  @override
  void initState() {
    super.initState();
    _data = widget.data!;
  }

  void _tambah() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const FormTransportasiTindakan(),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as BiayaTransportTindakanMod;
        _data.add(data.data!);
        setState(() {});
      }
    });
  }

  void _edit(TransportasiTindakan data) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: FormTransportasiTindakan(
            data: data,
          ),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as BiayaTransportTindakanMod;
        switch (data.type) {
          case 'update':
            _data[_data.indexWhere((e) => e.id == data.data!.id)] = data.data!;
            setState(() {});
            break;
          case 'hapus':
            _data.removeWhere((e) => e.id == data.data!.id);
            setState(() {});
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 22.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor, width: 0.5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              onTap: _tambah,
              dense: true,
              horizontalTitleGap: 0.0,
              textColor: Colors.grey[600],
              leading: const Icon(
                Icons.add_rounded,
                color: kPrimaryColor,
              ),
              title: const Text('Tambah Transportasi'),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
            ),
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(
              bottom: 22.0,
            ),
            itemBuilder: (context, i) {
              var transportasi = _data[i];
              return ListTile(
                onTap: () => _edit(transportasi),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 2.0),
                title: Text('${transportasi.deskripsi}'),
                subtitle: Text(_rupiah.format(transportasi.nilai)),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              );
            },
            separatorBuilder: (context, i) => const Divider(
              height: 0,
            ),
            itemCount: _data.length,
          ),
        ),
      ],
    );
  }
}

class BiayaTransportTindakanMod {
  BiayaTransportTindakanMod({
    this.type,
    this.data,
  });

  final String? type;
  final TransportasiTindakan? data;
}

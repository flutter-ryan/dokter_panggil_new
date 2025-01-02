import 'package:dokter_panggil/src/blocs/master_biaya_admin_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_biaya_admin_save_bloc.dart';
import 'package:dokter_panggil/src/models/master_biaya_admin_model.dart';
import 'package:dokter_panggil/src/models/master_biaya_admin_save_model.dart';
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

class BiayaAdminPage extends StatefulWidget {
  const BiayaAdminPage({super.key});

  @override
  State<BiayaAdminPage> createState() => _BiayaAdminPageState();
}

class _BiayaAdminPageState extends State<BiayaAdminPage> {
  final _masterBiayaAdminBloc = MasterBiayaAdminBloc();

  @override
  void initState() {
    super.initState();
    _masterBiayaAdminBloc.getMasterBiayaAdmin();
  }

  @override
  void dispose() {
    _masterBiayaAdminBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Biaya Administrasi'),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: _streamBiayaAdministrasi(context),
    );
  }

  Widget _streamBiayaAdministrasi(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterBiayaAdminModel>>(
      stream: _masterBiayaAdminBloc.masterBiayaAdminStream,
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
                  _masterBiayaAdminBloc.getMasterBiayaAdmin();
                  setState(() {});
                },
              );
            case Status.completed:
              return ListBiayaAdmin(
                data: snapshot.data!.data!.data,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListBiayaAdmin extends StatefulWidget {
  const ListBiayaAdmin({
    super.key,
    this.data,
  });

  final List<MasterBiayaAdmin>? data;

  @override
  State<ListBiayaAdmin> createState() => _ListBiayaAdminState();
}

class _ListBiayaAdminState extends State<ListBiayaAdmin> {
  List<MasterBiayaAdmin> _data = [];
  final _filter = TextEditingController();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _data = widget.data!;
    _filter.addListener(_filterListener);
  }

  void _filterListener() {
    if (_filter.text.isEmpty) {
      _data = widget.data!;
    } else {
      _data = widget.data!
          .where((e) =>
              e.deskripsi!.toLowerCase().contains(_filter.text.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  void _tambah() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const FormBiayaAdminWidget(),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as BiayaAdminMod;
        _data.add(data.data!);
        setState(() {});
      }
    });
  }

  void _edit(MasterBiayaAdmin data) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: FormBiayaAdminWidget(
            data: data,
          ),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as BiayaAdminMod;
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
                Icons.monetization_on_rounded,
                color: kPrimaryColor,
              ),
              title: const Text('Tambah Biaya Admin'),
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
              var biayaAdmin = _data[i];
              return ListTile(
                onTap: () => _edit(biayaAdmin),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 2.0),
                title: Text('${biayaAdmin.deskripsi}'),
                subtitle: biayaAdmin.persen == 1
                    ? Text('${biayaAdmin.nilai}%')
                    : Text(_rupiah.format(biayaAdmin.nilai)),
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

class FormBiayaAdminWidget extends StatefulWidget {
  const FormBiayaAdminWidget({
    super.key,
    this.data,
  });

  final MasterBiayaAdmin? data;

  @override
  State<FormBiayaAdminWidget> createState() => _FormBiayaAdminWidgetState();
}

class _FormBiayaAdminWidgetState extends State<FormBiayaAdminWidget> {
  final _masterBiayaAdminSaveBloc = MasterBiayaAdminSaveBloc();
  final _formKey = GlobalKey<FormState>();
  final _deskripsi = TextEditingController();
  final _biaya = TextEditingController();
  String _groupJenisBiaya = 'rupiah';

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
      _deskripsi.text = widget.data!.deskripsi!;
      _biaya.text = widget.data!.nilai.toString();
      _groupJenisBiaya = widget.data!.persen == 0 ? 'rupiah' : 'persen';
      setState(() {});
    }
  }

  void _simpan() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(FocusNode());
      _masterBiayaAdminSaveBloc.deskripsiSink.add(_deskripsi.text);
      _masterBiayaAdminSaveBloc.nilaiSink.add(int.parse(_biaya.text));
      _masterBiayaAdminSaveBloc.jenisSink.add(_groupJenisBiaya);
      _masterBiayaAdminSaveBloc.saveBiayaAdmin();
      _showStreamSaveBiayaAdmin('create');
    }
  }

  void _update() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(FocusNode());
      _masterBiayaAdminSaveBloc.idSink.add(widget.data!.id!);
      _masterBiayaAdminSaveBloc.nilaiSink.add(int.parse(_biaya.text));
      _masterBiayaAdminSaveBloc.deskripsiSink.add(_deskripsi.text);
      _masterBiayaAdminSaveBloc.jenisSink.add(_groupJenisBiaya);
      _masterBiayaAdminSaveBloc.updateBiayaAdmin();
      _showStreamSaveBiayaAdmin('update');
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
        _masterBiayaAdminSaveBloc.idSink.add(widget.data!.id!);
        _masterBiayaAdminSaveBloc.deleteBiayaAdmin();
        _showStreamSaveBiayaAdmin('hapus');
      }
    });
  }

  void _showStreamSaveBiayaAdmin(String type) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamBiayaAdmin(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as MasterBiayaAdmin;
        BiayaAdminMod biayaMod = BiayaAdminMod(
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
    _masterBiayaAdminSaveBloc.dispose();
    _biaya.dispose();
    _deskripsi.dispose();
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
            const Text(
              'Jenis Biaya',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.3, color: Colors.grey),
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.grey[200],
                    ),
                    child: Center(
                      child: RadioListTile(
                        value: 'rupiah',
                        activeColor: kPrimaryColor,
                        groupValue: _groupJenisBiaya,
                        onChanged: (newval) {
                          setState(() {
                            _groupJenisBiaya = '$newval';
                            _biaya.clear();
                          });
                        },
                        title: const Text('Rupiah'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.3, color: Colors.grey),
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.grey[200],
                    ),
                    child: Center(
                      child: RadioListTile(
                        value: 'persen',
                        groupValue: _groupJenisBiaya,
                        activeColor: kPrimaryColor,
                        onChanged: (newval) {
                          setState(() {
                            _groupJenisBiaya = '$newval';
                            _biaya.clear();
                          });
                        },
                        title: const Text('Persen'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 22.0,
            ),
            Input(
              controller: _deskripsi,
              label: 'Deskripsi',
              hint: 'Inputkan deskripsi biaya admin',
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
              label: _groupJenisBiaya == 'rupiah' ? 'Biaya' : 'Persentase',
              hint: _groupJenisBiaya == 'rupiah'
                  ? 'Inputkan nilai admin'
                  : 'Inputkan persentase biaya',
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

  Widget _streamBiayaAdmin(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseMasterBiayaAdminSaveModel>>(
      stream: _masterBiayaAdminSaveBloc.biayaAdminSaveStream,
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

class BiayaAdminMod {
  BiayaAdminMod({
    this.type,
    this.data,
  });

  final String? type;
  final MasterBiayaAdmin? data;
}

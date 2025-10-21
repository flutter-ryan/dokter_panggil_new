import 'package:admin_dokter_panggil/src/blocs/update_harga_farmasi_bloc.dart';
import 'package:admin_dokter_panggil/src/models/master_farmasi_paginate_model.dart';
import 'package:admin_dokter_panggil/src/models/update_harga_farmasi_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/input_form.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:admin_dokter_panggil/src/source/transition/animated_dialog.dart';

class FormBarangMitra extends StatefulWidget {
  const FormBarangMitra({
    super.key,
    required this.data,
  });

  final BarangFarmasi data;

  @override
  State<FormBarangMitra> createState() => _FormBarangMitraState();
}

class _FormBarangMitraState extends State<FormBarangMitra> {
  final _updateHargaFarmasiBloc = UpdateHargaFarmasiBloc();
  final _formKey = GlobalKey<FormState>();
  final _hargaModal = TextEditingController();

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _hargaModal.text = '${widget.data.hargaModal}';
  }

  void _updateHarga() {
    if (validateAndSave()) {
      _updateHargaFarmasiBloc.idSink.add(widget.data.id!);
      _updateHargaFarmasiBloc.hargaModalSink.add(int.parse(_hargaModal.text));
      _updateHargaFarmasiBloc.updateHargaFarmasi();
      _showStreamUpdateHargaFarmasi();
    }
  }

  void _showStreamUpdateHargaFarmasi() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamUpdateHargaFarmasi(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        var data = value as BarangFarmasi;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          Navigator.pop(context, data);
        });
      }
    });
  }

  @override
  void dispose() {
    _hargaModal.dispose();
    _updateHargaFarmasiBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'Edit Barang Mitra',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
        Flexible(
          child: Form(
            key: _formKey,
            child: ListView(
              padding:
                  const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
              shrinkWrap: true,
              children: [
                Input(
                  controller: _hargaModal,
                  label: 'Harga',
                  hint: 'Input harga barang mitra',
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
                  onPressed: _updateHarga,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    backgroundColor: kPrimaryColor,
                  ),
                  child: const Text('Update Harga'),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _streamUpdateHargaFarmasi(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseUpdateHargaFarmasiModel>>(
      stream: _updateHargaFarmasiBloc.updateHargaFarmasiStream,
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
}

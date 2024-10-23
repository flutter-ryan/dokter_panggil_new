import 'package:dokter_panggil/src/blocs/pegawai_updatE_akun_bloc.dart';
import 'package:dokter_panggil/src/models/pegawai_update_akun_model.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormAkun extends StatefulWidget {
  const FormAkun({
    Key? key,
    this.id,
    this.namaPegawai,
    this.profesi,
    this.idProfesi,
    this.namaAkun,
    this.password,
  }) : super(key: key);

  final int? id;
  final String? namaPegawai;
  final String? profesi;
  final int? idProfesi;
  final String? namaAkun;
  final String? password;

  @override
  State<FormAkun> createState() => _FormAkunState();
}

class _FormAkunState extends State<FormAkun> {
  final PegawaiUpdateAkunBloc _pegawaiUpdateAkunBloc = PegawaiUpdateAkunBloc();
  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _profesi = TextEditingController();
  final _name = TextEditingController();
  final _password = TextEditingController();
  final _konfirmPass = TextEditingController();

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
    _fillInput();
  }

  void _fillInput() {
    _nama.text = '${widget.namaPegawai}';
    _profesi.text = '${widget.profesi}';
    _name.text = '${widget.namaAkun}';
  }

  void _update() {
    if (validateAndSave()) {
      _pegawaiUpdateAkunBloc.nameSink.add(_nama.text);
      _pegawaiUpdateAkunBloc.nameSink.add(_name.text);
      _pegawaiUpdateAkunBloc.passwordSink.add(_password.text);
      _pegawaiUpdateAkunBloc.updateAkun();
      _showStreamUpdate();
    }
  }

  void _showStreamUpdate() {
    showDialog(
      context: context,
      builder: (context) {
        return _streamUpdate();
      },
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pop(context, 'reload');
        });
      }
    });
  }

  @override
  void dispose() {
    _nama.dispose();
    _profesi.dispose();
    _name.dispose();
    _password.dispose();
    _konfirmPass.dispose();
    _pegawaiUpdateAkunBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 32.0),
          children: [
            if (widget.namaPegawai != null)
              Input(
                controller: _nama,
                label: 'Nama',
                hint: 'Nama lengkap pegawai',
                maxLines: 1,
              ),
            if (widget.profesi != null)
              Input(
                controller: _profesi,
                label: 'Profesi',
                hint: 'Pilih profesi',
                maxLines: 1,
              ),
            if (widget.namaAkun != null)
              Input(
                controller: _name,
                label: 'Nama',
                hint: 'Nama user akun',
                maxLines: 1,
              ),
            if (widget.password != null)
              Input(
                controller: _password,
                label: 'Password',
                hint: 'Password akun',
                maxLines: 1,
              ),
            if (widget.password != null)
              Input(
                controller: _konfirmPass,
                label: 'Konfirmasi password',
                hint: 'Konfirmasi password akun',
                maxLines: 1,
              ),
            const SizedBox(
              height: 32.0,
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _update,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                ),
                child: const Text('Update'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _streamUpdate() {
    return StreamBuilder<ApiResponse<ResponsePegawaiUpdateAkunModel>>(
      stream: _pegawaiUpdateAkunBloc.pegawaiUpdateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit();
            case Status.error:
              return ErrorDialog(
                message: snapshot.data!.message,
              );
            case Status.completed:
              return SuccessDialog(
                message: snapshot.data!.data!.message,
                onTap: () => Navigator.pop(context, 'success'),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

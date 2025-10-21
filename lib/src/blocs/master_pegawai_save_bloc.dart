import 'dart:async';

import 'package:admin_dokter_panggil/src/models/master_pegawai_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/master_pegawai_save_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterPegawaiSaveBloc {
  final _repo = MasterPegawaiSaveRepo();
  StreamController<ApiResponse<ResponseMasterPegawaiSaveModel>>?
      _streamSavePegawai;
  final BehaviorSubject<String> _nama = BehaviorSubject();
  final BehaviorSubject<int> _profesi = BehaviorSubject();
  final BehaviorSubject<String> _nomorSip = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _tanggalSip = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _email = BehaviorSubject();
  final BehaviorSubject<String> _password = BehaviorSubject.seeded('password');
  final BehaviorSubject<String> _ulangiPassword =
      BehaviorSubject.seeded('password');
  final BehaviorSubject<int> _role = BehaviorSubject();

  StreamSink<String> get namaSink => _nama.sink;
  StreamSink<int> get profesiSink => _profesi.sink;
  StreamSink<String> get nomorSipSink => _nomorSip.sink;
  StreamSink<String> get tanggalSipSink => _tanggalSip.sink;
  StreamSink<String> get emailSink => _email.sink;
  StreamSink<String> get passwordSink => _password.sink;
  StreamSink<String> get ulangiPasswordSink => _ulangiPassword.sink;
  StreamSink<int> get roleSink => _role.sink;
  StreamSink<ApiResponse<ResponseMasterPegawaiSaveModel>> get savePegawaiSink =>
      _streamSavePegawai!.sink;
  Stream<ApiResponse<ResponseMasterPegawaiSaveModel>> get savePegawaiStream =>
      _streamSavePegawai!.stream;

  Future<void> savePegawai() async {
    _streamSavePegawai = StreamController();
    final nama = _nama.value;
    final profesi = _profesi.value;
    final nomorSip = _nomorSip.value;
    final tanggalSip = _tanggalSip.value;
    final email = _email.value;
    final password = _password.value;
    final ulangiPassword = _ulangiPassword.value;
    final role = _role.value;
    savePegawaiSink.add(ApiResponse.loading('Memuat...'));
    MasterPegawaiSaveModel masterPegawaiSaveModel = MasterPegawaiSaveModel(
      nama: nama,
      profesi: profesi,
      email: email,
      password: password,
      passwordConfirmation: ulangiPassword,
      nomorSip: nomorSip,
      tanggalSip: tanggalSip,
      role: role,
    );
    try {
      final res = await _repo.savePegawai(masterPegawaiSaveModel);
      if (_streamSavePegawai!.isClosed) return;
      savePegawaiSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamSavePegawai!.isClosed) return;
      savePegawaiSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamSavePegawai?.close();
    _nama.close();
    _profesi.close();
    _nomorSip.close();
    _tanggalSip.close();
    _email.close();
    _password.close();
    _ulangiPassword.close();
    _role.close();
  }
}

import 'dart:async';

import 'package:admin_dokter_panggil/src/models/pegawai_update_akun_model.dart';
import 'package:admin_dokter_panggil/src/repositories/pegawai_update_akun_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class PegawaiUpdateAkunBloc {
  final PegawaiUpdateAkunRepo _repo = PegawaiUpdateAkunRepo();
  StreamController<ApiResponse<ResponsePegawaiUpdateAkunModel>>?
      _streamUpdateAkun;
  final BehaviorSubject<String> _password = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _passwordConfirmation =
      BehaviorSubject.seeded('');
  final BehaviorSubject<String> _name = BehaviorSubject.seeded('');
  StreamSink<String> get passwordSink => _password.sink;
  StreamSink<String> get passwordConfirmationSink => _passwordConfirmation.sink;
  StreamSink<String> get nameSink => _name.sink;
  StreamSink<ApiResponse<ResponsePegawaiUpdateAkunModel>>
      get pegawaiUpdateSink => _streamUpdateAkun!.sink;
  Stream<ApiResponse<ResponsePegawaiUpdateAkunModel>> get pegawaiUpdateStream =>
      _streamUpdateAkun!.stream;

  Future<void> updateAkun() async {
    _streamUpdateAkun = StreamController();
    final password = _password.value;
    final name = _name.value;
    final passwordConfirmation = _passwordConfirmation.value;
    pegawaiUpdateSink.add(ApiResponse.loading('Memuat...'));
    PegawaiUpdateAkunModel pegawaiUpdateAkunModel = PegawaiUpdateAkunModel(
      password: password,
      name: name,
      passwordConfirmation: passwordConfirmation,
    );
    try {
      final res = await _repo.updateAkun(pegawaiUpdateAkunModel);
      if (_streamUpdateAkun!.isClosed) return;
      pegawaiUpdateSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamUpdateAkun!.isClosed) return;
      pegawaiUpdateSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamUpdateAkun?.close();
    _password.close();
  }
}

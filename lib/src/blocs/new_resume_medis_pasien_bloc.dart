import 'dart:async';

import 'package:admin_dokter_panggil/src/models/new_resume_medis_pasien_model.dart';
import 'package:admin_dokter_panggil/src/repositories/new_resume_medis_pasien_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class NewResumeMedisPasienBloc {
  final _repo = NewResumeMedisPasienRepo();
  StreamController<ApiResponse<NewResumeMedisPasienModel>>?
      _streamNewResumePasien;

  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<NewResumeMedisPasienModel>> get newResumePasienSink =>
      _streamNewResumePasien!.sink;
  Stream<ApiResponse<NewResumeMedisPasienModel>> get newResumePaienStream =>
      _streamNewResumePasien!.stream;

  Future<void> getResumePasien() async {
    _streamNewResumePasien = StreamController();
    final idKunjungan = _idKunjungan.value;
    newResumePasienSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getResumePasien(idKunjungan);
      if (_streamNewResumePasien!.isClosed) return;
      newResumePasienSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamNewResumePasien!.isClosed) return;
      newResumePasienSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamNewResumePasien?.close();
    _idKunjungan.close();
  }
}

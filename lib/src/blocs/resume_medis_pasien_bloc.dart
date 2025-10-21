import 'dart:async';

import 'package:admin_dokter_panggil/src/models/resume_medis_pasien_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/resume_medis_pasien_repo.dart';
import 'package:rxdart/rxdart.dart';

class ResumeMedisPasienBloc {
  final _repo = ResumeMedisPasieRepo();
  StreamController<ApiResponse<ResumeMedisPasienModel>>? _streamResumePasien;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<ResumeMedisPasienModel>> get resumePasienSink =>
      _streamResumePasien!.sink;
  Stream<ApiResponse<ResumeMedisPasienModel>> get resumePasienStream =>
      _streamResumePasien!.stream;

  Future<void> getResumeMedis() async {
    _streamResumePasien = StreamController();
    final idKunjungan = _idKunjungan.value;
    resumePasienSink.add(ApiResponse.loading('Loading...'));
    try {
      final res = await _repo.getResumeMedis(idKunjungan);
      if (_streamResumePasien!.isClosed) return;
      resumePasienSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamResumePasien!.isClosed) return;
      resumePasienSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamResumePasien?.close();
    _idKunjungan.close();
  }
}

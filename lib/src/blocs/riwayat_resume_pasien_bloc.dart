import 'dart:async';

import 'package:admin_dokter_panggil/src/models/riwayat_pasien_resume_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/riwayat_pasien_resume_repo.dart';
import 'package:rxdart/rxdart.dart';

class RiwayatResumePasienBloc {
  final _repo = RiwayatPasienResumeRepo();
  StreamController<ApiResponse<RiwayatResumePasienModel>>?
      _streamRiwayatResumePasien;
  final BehaviorSubject<String> _norm = BehaviorSubject();
  StreamSink<String> get normSink => _norm.sink;
  StreamSink<ApiResponse<RiwayatResumePasienModel>>
      get riwayatResumePasienSink => _streamRiwayatResumePasien!.sink;
  Stream<ApiResponse<RiwayatResumePasienModel>> get riwayatResumePasienStream =>
      _streamRiwayatResumePasien!.stream;

  Future<void> getRiwayatResume() async {
    _streamRiwayatResumePasien = StreamController();
    final norm = _norm.value;
    riwayatResumePasienSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getRiwayatResume(norm);
      if (_streamRiwayatResumePasien!.isClosed) return;
      riwayatResumePasienSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamRiwayatResumePasien!.isClosed) return;
      riwayatResumePasienSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamRiwayatResumePasien?.close();
    _norm.close();
  }
}

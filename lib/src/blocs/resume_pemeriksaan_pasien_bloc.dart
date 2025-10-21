import 'dart:async';

import 'package:admin_dokter_panggil/src/models/resume_pemeriksaan_pasien_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/resume_pemeriksaan_pasien_repo.dart';
import 'package:rxdart/rxdart.dart';

class ResumePemeriksaanPasienBloc {
  final _repo = ResumePemeriksaanPasienRepo();
  StreamController<ApiResponse<ResponseResumePemeriksaanPasienModel>>?
      _streamResumePemeriksaanPasien;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<int> _idPetugas = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<int> get idPetugasSink => _idPetugas.sink;
  StreamSink<ApiResponse<ResponseResumePemeriksaanPasienModel>>
      get resumePemeriksaanPasienSink => _streamResumePemeriksaanPasien!.sink;
  Stream<ApiResponse<ResponseResumePemeriksaanPasienModel>>
      get resumePemeriksaanPasienStream =>
          _streamResumePemeriksaanPasien!.stream;

  Future<void> getResumePemeriksaanPasien() async {
    _streamResumePemeriksaanPasien = StreamController();
    final idKunjungan = _idKunjungan.value;
    final idPetugas = _idPetugas.value;
    resumePemeriksaanPasienSink.add(ApiResponse.loading('Memuat...'));
    ResumePemeriksaanPasienModel resumePemeriksaanPasienModel =
        ResumePemeriksaanPasienModel(
            idKunjungan: idKunjungan, idPetugas: idPetugas);
    try {
      final res =
          await _repo.getResumePemeriksaanPasien(resumePemeriksaanPasienModel);
      if (_streamResumePemeriksaanPasien!.isClosed) return;
      resumePemeriksaanPasienSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamResumePemeriksaanPasien!.isClosed) return;
      resumePemeriksaanPasienSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamResumePemeriksaanPasien?.close();
    _idKunjungan.close();
    _idPetugas.close();
  }
}

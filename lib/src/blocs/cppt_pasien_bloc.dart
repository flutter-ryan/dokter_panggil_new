import 'dart:async';

import 'package:dokter_panggil/src/models/cppt_pasien_model.dart';
import 'package:dokter_panggil/src/repositories/cppt_pasien_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class CpptPasienBloc {
  final _repo = CpptPasienRepo();
  StreamController<ApiResponse<CpptPasienModel>>? _streamCpptPasien;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<int> _idPegawai = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<int> get idPegawaiSink => _idPegawai.sink;
  StreamSink<ApiResponse<CpptPasienModel>> get cpptPasienSink =>
      _streamCpptPasien!.sink;
  Stream<ApiResponse<CpptPasienModel>> get cpptPasienStream =>
      _streamCpptPasien!.stream;

  Future<void> getCpptPasien() async {
    _streamCpptPasien = StreamController();
    final idPegawai = _idPegawai.value;
    final idKunjungan = _idKunjungan.value;
    cpptPasienSink.add(ApiResponse.loading('Memuat...'));
    CpptPasienRequestModel cpptPasienRequestModel =
        CpptPasienRequestModel(idKunjungan: idKunjungan, idPetugas: idPegawai);
    try {
      final res = await _repo.getCpptPasien(cpptPasienRequestModel);
      if (_streamCpptPasien!.isClosed) return;
      cpptPasienSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamCpptPasien!.isClosed) return;
      cpptPasienSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamCpptPasien?.close();
    _idKunjungan.close();
    _idPegawai.close();
  }
}

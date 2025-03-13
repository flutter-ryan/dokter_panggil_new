import 'dart:async';

import 'package:dokter_panggil/src/models/mr_petugas_konsul_save_model.dart';
import 'package:dokter_panggil/src/repositories/mr_petugas_konsul_save_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MrPetugasKonsulSaveBloc {
  final _repo = MrPetugasKonsulSaveRepo();
  StreamController<ApiResponse<MrPetugasKonsulSaveModel>>?
      _streamPetugasKonsulSave;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<int> _idPetugas = BehaviorSubject();
  final BehaviorSubject<int> _pilihanPetugas = BehaviorSubject();
  final BehaviorSubject<int> _idKonfirmasi = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<int> get idPetugasSink => _idPetugas.sink;
  StreamSink<int> get pilihanPetugasSink => _pilihanPetugas.sink;
  StreamSink<int> get idKonfirmasiSink => _idKonfirmasi.sink;
  StreamSink<ApiResponse<MrPetugasKonsulSaveModel>> get petugasKonsulSaveSink =>
      _streamPetugasKonsulSave!.sink;
  Stream<ApiResponse<MrPetugasKonsulSaveModel>> get petugasKonsulSaveStream =>
      _streamPetugasKonsulSave!.stream;

  Future<void> simpanPetugasKonsul() async {
    _streamPetugasKonsulSave = StreamController();
    final idKunjungan = _idKunjungan.value;
    final idPetugas = _idPetugas.value;
    final pilihanPetugas = _pilihanPetugas.value;
    petugasKonsulSaveSink.add(ApiResponse.loading('Memuat...'));
    MrPetugasKonsulRequestModel mrPetugasKonsulRequestModel =
        MrPetugasKonsulRequestModel(
            idKunjungan: idKunjungan,
            idPetugas: idPetugas,
            pilihanPetugas: pilihanPetugas);

    try {
      final res = await _repo.simpanPetugasKonsul(mrPetugasKonsulRequestModel);
      if (_streamPetugasKonsulSave!.isClosed) return;
      petugasKonsulSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPetugasKonsulSave!.isClosed) return;
      petugasKonsulSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deletePetugasKonsul() async {
    _streamPetugasKonsulSave = StreamController();
    final idKonfirmasi = _idKonfirmasi.value;
    petugasKonsulSaveSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deletePetugasKonsul(idKonfirmasi);
      if (_streamPetugasKonsulSave!.isClosed) return;
      petugasKonsulSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPetugasKonsulSave!.isClosed) return;
      petugasKonsulSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamPetugasKonsulSave?.close();
    _idKunjungan.close();
    _idPetugas.close();
    _pilihanPetugas.close();
  }
}

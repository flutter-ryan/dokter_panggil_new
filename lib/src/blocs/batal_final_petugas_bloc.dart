import 'dart:async';

import 'package:dokter_panggil/src/models/batal_final_petugas_model.dart';
import 'package:dokter_panggil/src/repositories/batal_final_petugas_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class BatalFinalPetugasBloc {
  final _repo = BatalFinalPetugasRepo();
  StreamController<ApiResponse<ResponseBatalFinalPetugasModel>>?
      _streamBatalFinal;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<int> _idPetugas = BehaviorSubject();
  final BehaviorSubject<bool> _isDokter = BehaviorSubject();
  StreamSink<int> get idPetugasSink => _idPetugas.sink;
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<bool> get isDokterSink => _isDokter.sink;
  StreamSink<ApiResponse<ResponseBatalFinalPetugasModel>> get batalFinalSink =>
      _streamBatalFinal!.sink;
  Stream<ApiResponse<ResponseBatalFinalPetugasModel>> get batalFinalStream =>
      _streamBatalFinal!.stream;

  Future<void> batalFinal() async {
    _streamBatalFinal = StreamController();
    final id = _idKunjungan.value;
    final idPetugas = _idPetugas.value;
    final isDokter = _isDokter.value;
    BatalFinalPetugasModel batalFinalPetugasModel =
        BatalFinalPetugasModel(idPetugas: idPetugas, isDokter: isDokter);
    batalFinalSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.batalFinalPetugas(batalFinalPetugasModel, id);
      if (_streamBatalFinal!.isClosed) return;
      batalFinalSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBatalFinal!.isClosed) return;
      batalFinalSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamBatalFinal?.close();
    _idKunjungan.close();
    _idPetugas.close();
  }
}

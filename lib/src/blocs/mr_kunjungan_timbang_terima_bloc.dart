import 'dart:async';

import 'package:admin_dokter_panggil/src/models/mr_kunjungan_timbang_terima_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_kunjungan_timbang_terima_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrKunjunganTimbangTerimaBloc {
  final _repo = MrKunjunganTimbangTerimaRepo();
  StreamController<ApiResponse<MrKunjunganTimbangTerimaModel>>?
      _streamTimbangTerima;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<MrKunjunganTimbangTerimaModel>>
      get timbangTerimaSink => _streamTimbangTerima!.sink;
  Stream<ApiResponse<MrKunjunganTimbangTerimaModel>> get timbangTerimaStream =>
      _streamTimbangTerima!.stream;

  Future<void> getTimbangTerima() async {
    _streamTimbangTerima = StreamController();
    final idKunjungan = _idKunjungan.value;
    timbangTerimaSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getTimbangTerima(idKunjungan);
      if (_streamTimbangTerima!.isClosed) return;
      timbangTerimaSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTimbangTerima!.isClosed) return;
      timbangTerimaSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamTimbangTerima?.close();
    _idKunjungan.close();
  }
}

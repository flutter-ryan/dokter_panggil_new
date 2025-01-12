import 'dart:async';

import 'package:dokter_panggil/src/models/kwitansi_sementara_model.dart';
import 'package:dokter_panggil/src/repositories/kwitansi_sementara_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class KwitansiSementaraBloc {
  final _repo = KwitansiSementaraRepo();
  StreamController<ApiResponse<KwitansiSementaraModel>>?
      _streamKwitansiSemenetara;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjungSink => _idKunjungan.sink;
  StreamSink<ApiResponse<KwitansiSementaraModel>> get kwitansiSementaraSink =>
      _streamKwitansiSemenetara!.sink;
  Stream<ApiResponse<KwitansiSementaraModel>> get kwitansiSementaraStream =>
      _streamKwitansiSemenetara!.stream;

  Future<void> getKwitansiSementara() async {
    _streamKwitansiSemenetara = StreamController();
    final idKunjungan = _idKunjungan.value;
    kwitansiSementaraSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getKwitansiSementara(idKunjungan);
      if (_streamKwitansiSemenetara!.isClosed) return;
      kwitansiSementaraSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKwitansiSemenetara!.isClosed) return;

      kwitansiSementaraSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamKwitansiSemenetara?.close();
    _idKunjungan.close();
  }
}

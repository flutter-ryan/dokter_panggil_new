import 'dart:async';

import 'package:dokter_panggil/src/models/kunjungan_model.dart';
import 'package:dokter_panggil/src/repositories/kunjungan_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';

class KunjunganBloc {
  final KunjunganRepo _repo = KunjunganRepo();
  StreamController<ApiResponse<KunjunganModel>>? _streamKunjungan;
  StreamSink<ApiResponse<KunjunganModel>> get kunjunganSink =>
      _streamKunjungan!.sink;
  Stream<ApiResponse<KunjunganModel>> get kunjunganStream =>
      _streamKunjungan!.stream;

  Future<void> kunjunganPasien() async {
    _streamKunjungan = StreamController();
    kunjunganSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getKunjungan();
      if (_streamKunjungan!.isClosed) return;
      kunjunganSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKunjungan!.isClosed) return;
      kunjunganSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamKunjungan?.close();
  }
}

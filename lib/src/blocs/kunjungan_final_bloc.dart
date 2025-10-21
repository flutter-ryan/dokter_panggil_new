import 'dart:async';

import 'package:admin_dokter_panggil/src/models/kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/kunjungan_final_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';

class KunjunganFinalBloc {
  final KunjunganFinalRepo _repo = KunjunganFinalRepo();
  StreamController<ApiResponse<KunjunganModel>>? _streamKunjunganFinal;
  StreamSink<ApiResponse<KunjunganModel>> get kunjunganFinalSink =>
      _streamKunjunganFinal!.sink;
  Stream<ApiResponse<KunjunganModel>> get kunjunganFinalStream =>
      _streamKunjunganFinal!.stream;
  Future<void> kunjunganFinal() async {
    _streamKunjunganFinal = StreamController();
    kunjunganFinalSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.kunjunganFinal();
      if (_streamKunjunganFinal!.isClosed) return;
      kunjunganFinalSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKunjunganFinal!.isClosed) return;
      kunjunganFinalSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamKunjunganFinal?.close();
  }
}

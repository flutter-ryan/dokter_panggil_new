import 'dart:async';

import 'package:admin_dokter_panggil/src/models/response_batal_paket_model.dart';
import 'package:admin_dokter_panggil/src/repositories/batal_paket_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class BatalPaketBloc {
  final _repo = BatalPaketRepo();
  StreamController<ApiResponse<ResponseBatalPaketModel>>? _streamBatalPaket;
  final BehaviorSubject<int> _kunjungan = BehaviorSubject();
  StreamSink<int> get kunjunganSin => _kunjungan.sink;
  StreamSink<ApiResponse<ResponseBatalPaketModel>> get batalPaketSink =>
      _streamBatalPaket!.sink;
  Stream<ApiResponse<ResponseBatalPaketModel>> get batalPaketStream =>
      _streamBatalPaket!.stream;

  Future<void> batalPaket() async {
    _streamBatalPaket = StreamController();
    final kunjungan = _kunjungan.value;
    batalPaketSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.batalPaket(kunjungan);
      if (_streamBatalPaket!.isClosed) return;
      batalPaketSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBatalPaket!.isClosed) return;
      batalPaketSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamBatalPaket?.close();
    _kunjungan.close();
  }
}

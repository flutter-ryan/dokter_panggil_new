import 'dart:async';

import 'package:dokter_panggil/src/models/kunjungan_paket_update_model.dart';
import 'package:dokter_panggil/src/repositories/kunjungan_paket_update_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class KunjunganPaketUpdateBloc {
  final _repo = KunjunganPaketUpdateRepo();
  StreamController<ApiResponse<ResponseKunjunganPaketUpdateModel>>?
      _streamKunjunganPaketUpdate;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<int> _idPaket = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<int> get idPaketSink => _idPaket.sink;
  StreamSink<ApiResponse<ResponseKunjunganPaketUpdateModel>>
      get kunjunganPaketUpdateSink => _streamKunjunganPaketUpdate!.sink;
  Stream<ApiResponse<ResponseKunjunganPaketUpdateModel>>
      get kunjunganPaketUpdateStream => _streamKunjunganPaketUpdate!.stream;

  Future<void> updateKunjunganPaket() async {
    _streamKunjunganPaketUpdate = StreamController();
    final idKunjungan = _idKunjungan.value;
    final idPaket = _idPaket.value;
    kunjunganPaketUpdateSink.add(ApiResponse.loading('Memuat...'));
    KunjunganPaketUpdateModel kunjunganPaketUpdateModel =
        KunjunganPaketUpdateModel(idPaket: idPaket);

    try {
      final res = await _repo.updateKunjunganPaket(
          kunjunganPaketUpdateModel, idKunjungan);
      if (_streamKunjunganPaketUpdate!.isClosed) return;
      kunjunganPaketUpdateSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKunjunganPaketUpdate!.isClosed) return;
      kunjunganPaketUpdateSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> storekunjunganPaket() async {
    _streamKunjunganPaketUpdate = StreamController();
    final idKunjungan = _idKunjungan.value;
    final idPaket = _idPaket.value;
    kunjunganPaketUpdateSink.add(ApiResponse.loading('Memuat...'));
    KunjunganPaketUpdateModel kunjunganPaketUpdateModel =
        KunjunganPaketUpdateModel(idPaket: idPaket);

    try {
      final res = await _repo.storeKunjunganPaket(
          kunjunganPaketUpdateModel, idKunjungan);
      if (_streamKunjunganPaketUpdate!.isClosed) return;
      kunjunganPaketUpdateSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKunjunganPaketUpdate!.isClosed) return;
      kunjunganPaketUpdateSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamKunjunganPaketUpdate?.close();
    _idKunjungan.close();
    _idPaket.close();
  }
}

import 'dart:async';

import 'package:admin_dokter_panggil/src/models/kunjungan_paket_update_model.dart';
import 'package:admin_dokter_panggil/src/repositories/kunjungan_paket_delete_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class KunjunganPaketDeleteBloc {
  final _repo = KunjunganPaketDeleteRepo();
  StreamController<ApiResponse<ResponseKunjunganPaketUpdateModel>>?
      _streamKunjunganPaketDelete;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<ResponseKunjunganPaketUpdateModel>>
      get kunjunganPaketDeleteSink => _streamKunjunganPaketDelete!.sink;
  Stream<ApiResponse<ResponseKunjunganPaketUpdateModel>>
      get kunjunganPaketDeleteStream => _streamKunjunganPaketDelete!.stream;

  Future<void> deleteKunjunganPaket() async {
    _streamKunjunganPaketDelete = StreamController();
    final idKunjungan = _idKunjungan.value;
    kunjunganPaketDeleteSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deletePaket(idKunjungan);
      if (_streamKunjunganPaketDelete!.isClosed) return;
      kunjunganPaketDeleteSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKunjunganPaketDelete!.isClosed) return;
      kunjunganPaketDeleteSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamKunjunganPaketDelete?.close();
    _idKunjungan.close();
  }
}

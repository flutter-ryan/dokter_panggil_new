import 'dart:async';

import 'package:admin_dokter_panggil/src/models/mr_kunjungan_edukasi_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_kunjungan_edukasi_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrKunjunganEdukasiBloc {
  final _repo = MrKunjunganEdukasiRepo();
  StreamController<ApiResponse<MrKunjunganEdukasiModel>>? _streamEdukasi;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<MrKunjunganEdukasiModel>> get edukasiSink =>
      _streamEdukasi!.sink;
  Stream<ApiResponse<MrKunjunganEdukasiModel>> get edukasiStream =>
      _streamEdukasi!.stream;

  Future<void> getEdukasi() async {
    _streamEdukasi = StreamController();
    final idKunjungan = _idKunjungan.value;
    edukasiSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getEdukasi(idKunjungan);
      if (_streamEdukasi!.isClosed) return;
      edukasiSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamEdukasi!.isClosed) return;
      edukasiSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamEdukasi?.close();
    _idKunjungan.close();
  }
}

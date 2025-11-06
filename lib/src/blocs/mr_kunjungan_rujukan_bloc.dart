import 'dart:async';

import 'package:admin_dokter_panggil/src/models/mr_kunjungan_rujukan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_kunjungan_rujukan_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrKunjunganRujukanBloc {
  final _repo = MrKunjunganRujukanRepo();
  StreamController<ApiResponse<MrKunjunganRujukanModel>>? _streamRujukan;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<MrKunjunganRujukanModel>> get rujukanSink =>
      _streamRujukan!.sink;
  Stream<ApiResponse<MrKunjunganRujukanModel>> get rujukanStream =>
      _streamRujukan!.stream;

  Future<void> getRujukan() async {
    _streamRujukan = StreamController();
    final idKunjungan = _idKunjungan.value;
    rujukanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getRujukan(idKunjungan);
      if (_streamRujukan!.isClosed) return;
      rujukanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamRujukan!.isClosed) return;
      rujukanSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamRujukan?.close();
    _idKunjungan.close();
  }
}

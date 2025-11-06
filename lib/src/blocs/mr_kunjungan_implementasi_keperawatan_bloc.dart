import 'dart:async';

import 'package:admin_dokter_panggil/src/models/mr_kunjungan_implementasi_keperawatan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_kunjungan_implementasi_keperawatan_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrKunjunganImplementasiKeperawatanBloc {
  final _repo = MrKunjunganImplementasiKeperawatanRepo();
  StreamController<ApiResponse<MrKunjunganImplementasiKeperawatanModel>>?
      _streamImplementasiKeperawatan;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<MrKunjunganImplementasiKeperawatanModel>>
      get implementasiKeperawatanSink => _streamImplementasiKeperawatan!.sink;
  Stream<ApiResponse<MrKunjunganImplementasiKeperawatanModel>>
      get implementasiKeperawatanStream =>
          _streamImplementasiKeperawatan!.stream;

  Future<void> getImplementasiKeperawatan() async {
    _streamImplementasiKeperawatan = StreamController();
    final idKunjungan = _idKunjungan.value;
    implementasiKeperawatanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getImplementasiKeperawatan(idKunjungan);
      if (_streamImplementasiKeperawatan!.isClosed) return;
      implementasiKeperawatanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamImplementasiKeperawatan!.isClosed) return;
      implementasiKeperawatanSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamImplementasiKeperawatan?.close();
    _idKunjungan.close();
  }
}

import 'dart:async';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_resume_medis_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_kunjungan_resume_medis_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrKunjunganResumeMedisBloc {
  final _repo = MrKunjunganResumeMedisRepo();
  StreamController<ApiResponse<MrKunjunganResumeMedisModel>>?
      _streamResumeMedis;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<MrKunjunganResumeMedisModel>> get resumeMedisSink =>
      _streamResumeMedis!.sink;
  Stream<ApiResponse<MrKunjunganResumeMedisModel>> get resumeMedisStream =>
      _streamResumeMedis!.stream;
  Future<void> getResumeMedis() async {
    _streamResumeMedis = StreamController();
    final idKunjungan = _idKunjungan.value;
    resumeMedisSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getResumeMedis(idKunjungan);
      if (_streamResumeMedis!.isClosed) return;
      resumeMedisSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamResumeMedis!.isClosed) return;
      resumeMedisSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamResumeMedis?.close();
    _idKunjungan.close();
  }
}

import 'dart:async';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_pengobatan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_kunjungan_pengobatan_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrKunjunganPengobatanBloc {
  final _repo = MrKunjunganPengobatanRepo();
  StreamController<ApiResponse<MrKunjunganPengobatanModel>>? _streamPengobatan;
  final BehaviorSubject<String> _jenis = BehaviorSubject();
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<String> get jenisSink => _jenis.sink;
  StreamSink<ApiResponse<MrKunjunganPengobatanModel>> get pengobatanSink =>
      _streamPengobatan!.sink;
  Stream<ApiResponse<MrKunjunganPengobatanModel>> get pengobatanStream =>
      _streamPengobatan!.stream;

  Future<void> getPengobatan() async {
    _streamPengobatan = StreamController();
    final idKunjungan = _idKunjungan.value;
    final jenis = _jenis.value;
    pengobatanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getPengbatan(idKunjungan, jenis);
      if (_streamPengobatan!.isClosed) return;
      pengobatanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPengobatan!.isClosed) return;
      pengobatanSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamPengobatan?.close();
    _idKunjungan.close();
  }
}
